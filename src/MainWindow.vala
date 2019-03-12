public class Palaura.MainWindow : Gtk.ApplicationWindow {

    private Gtk.HeaderBar headerbar;
    private Gtk.Stack stack;
    private Gtk.SearchEntry search_entry;
    private Gtk.Stack button_stack;
    private Gtk.Button return_button;

    private Palaura.SearchView search_view;
    private Palaura.NormalView normal_view;
    private Palaura.DefinitionView definition_view;

    private Gee.LinkedList<View> return_history;

    public MainWindow(Gtk.Application app) {
        Object (application: app,
                title: _("Palaura"),
                height_request: 700,
                width_request: 800);

        search_entry.search_changed.connect (trigger_search);
        search_entry.key_press_event.connect ((event) => {
            if (event.keyval == Gdk.Key.Escape) {
                search_entry.text = "";
                return true;
            }
            return false;
        });

        search_entry.grab_focus_without_selecting();

        search_view.show_definition.connect (show_definition);
        normal_view.show_definition.connect (show_definition);

        return_button.clicked.connect (on_return_clicked);
    }

    public void show_definition (Core.Definition definition) {
        definition_view.set_definition (definition);
        push_view (definition_view);
    }

    construct
    {
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/lainsce/palaura/stylesheet.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        var context = this.get_style_context ();
        context.add_class ("palaura-window");

        search_entry = new Gtk.SearchEntry ();
        search_entry.placeholder_text = _("Search words");

        button_stack = new Gtk.Stack ();
        return_button = new Gtk.Button.with_label _("Home");
        return_button.get_style_context ().add_class ("back-button");
        button_stack.add (return_button);
        button_stack.no_show_all = true;

        var menu_button = new Gtk.Button ();
        menu_button.has_tooltip = true;
        menu_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        menu_button.tooltip_text = _("Settings");
        menu_button.clicked.connect (() => {
            debug ("Prefs button pressed.");
            var preferences_dialog = new Widgets.Preferences (this);
            preferences_dialog.show_all ();
        });

        headerbar = new Gtk.HeaderBar ();
        headerbar.show_close_button = true;
        headerbar.set_title _("Palaura");
        headerbar.has_subtitle = false;
        headerbar.pack_start (button_stack);
        headerbar.pack_end (menu_button);
        headerbar.pack_end (search_entry);
        set_titlebar (headerbar);

        search_view = new Palaura.SearchView();
        search_view.get_style_context ().add_class ("palaura-view");
        normal_view = new Palaura.NormalView();
        normal_view.get_style_context ().add_class ("palaura-view");
        definition_view = new Palaura.DefinitionView();
        definition_view.get_style_context ().add_class ("palaura-view");
        stack = new Gtk.Stack ();
        stack.get_style_context ().add_class ("palaura-view");
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
        stack.add (normal_view);
        stack.add (search_view);
        stack.add (definition_view);
        add (stack);

        return_history = new Gee.LinkedList<Palaura.View> ();

        var settings = AppSettings.get_default ();
        int x = settings.window_x;
        int y = settings.window_y;

        if (x != -1 && y != -1) {
            move (x, y);
        }
    }

    private void trigger_search () {
        unowned string search = search_entry.text;
        if (search.length < 2) {
            if (stack.get_visible_child () == search_view) {
                pop_view ();
            }
        } else {
            if (stack.get_visible_child () != search_view) push_view (search_view);
            search_view.search(search_entry.text);
        }
    }

    private void push_view (Palaura.View new_view) {

        if(return_history.is_empty) {
            button_stack.no_show_all = false;
            button_stack.show_all ();
        }

        View old_view = stack.get_visible_child () as View;
        return_history.offer_head (old_view);
        stack.set_visible_child (new_view);
        return_button.label = old_view.get_header_name ();
    }

    private void pop_view () {
        if(!return_history.is_empty) {
            View previous_view = return_history.poll_head ();
            stack.set_visible_child (previous_view);

            if(!return_history.is_empty)
                return_button.label = return_history.peek_head ().get_header_name ();
            else {
                button_stack.hide();
            }
        }
        else {
            return_button.label = _("Home");
            button_stack.hide();
        }
    }

    private void on_return_clicked() {
        if(stack.get_visible_child() == search_view) {
            search_entry.text = "";
        }

        pop_view ();
    }

    public override bool delete_event (Gdk.EventAny event) {
        var settings = AppSettings.get_default ();
        
        int x, y;
        get_position (out x, out y);
        settings.window_x = x;
        settings.window_y = y;
        return false;
    }
}
