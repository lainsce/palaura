public class Palaura.MainWindow : Gtk.ApplicationWindow {

    private Gtk.HeaderBar headerbar;
    private Gtk.Stack stack;
    private Gtk.SearchEntry search_entry;
    private Gtk.Stack button_stack;
    private Gtk.Button return_button;
    public Granite.ModeSwitch mode_switch;

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

        key_press_event.connect ((e) => {
            uint keycode = e.hardware_keycode;
            if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                if (match_keycode (Gdk.Key.q, keycode)) {
                    this.destroy ();
                }
            }
            return false;
        });

        Palaura.Application.gsettings.changed.connect (() => {
            if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
                Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
                this.get_style_context ().add_class ("palaura-window-dark");
                this.get_style_context ().remove_class ("palaura-window");
                search_view.get_style_context ().add_class ("palaura-view-dark");
                search_view.get_style_context ().remove_class ("palaura-view");
                normal_view.get_style_context ().add_class ("palaura-view-dark");
                normal_view.get_style_context ().remove_class ("palaura-view");
                definition_view.get_style_context ().add_class ("palaura-view-dark");
                definition_view.get_style_context ().remove_class ("palaura-view");
                stack.get_style_context ().add_class ("palaura-view-dark");
                stack.get_style_context ().remove_class ("palaura-view");
            } else {
                Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = false;
                this.get_style_context ().remove_class ("palaura-window-dark");
                this.get_style_context ().add_class ("palaura-window");
                search_view.get_style_context ().add_class ("palaura-view");
                search_view.get_style_context ().remove_class ("palaura-view-dark");
                normal_view.get_style_context ().add_class ("palaura-view");
                normal_view.get_style_context ().remove_class ("palaura-view-dark");
                definition_view.get_style_context ().add_class ("palaura-view");
                definition_view.get_style_context ().remove_class ("palaura-view-dark");
                stack.get_style_context ().add_class ("palaura-view");
                stack.get_style_context ().remove_class ("palaura-view-dark");
            }
        });
    }

#if VALA_0_42
    protected bool match_keycode (uint keyval, uint code) {
#else
    protected bool match_keycode (int keyval, uint code) {
#endif
        Gdk.KeymapKey [] keys;
        Gdk.Keymap keymap = Gdk.Keymap.get_for_display (Gdk.Display.get_default ());
        if (keymap.get_entries_for_keyval (keyval, out keys)) {
            foreach (var key in keys) {
                if (code == key.keycode)
                    return true;
                }
            }

        return false;
    }

    public void show_definition (Core.Definition definition) {
        definition_view.set_definition (definition);
        push_view (definition_view);
    }

    construct {
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/lainsce/palaura/stylesheet.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
            this.get_style_context ().add_class ("palaura-window-dark");
            this.get_style_context ().remove_class ("palaura-window");
        } else {
            this.get_style_context ().remove_class ("palaura-window-dark");
            this.get_style_context ().add_class ("palaura-window");
        }

        search_entry = new Gtk.SearchEntry ();
        search_entry.placeholder_text = _("Search words");

        button_stack = new Gtk.Stack ();
        return_button = new Gtk.Button.with_label (_("Home"));
        return_button.get_style_context ().add_class ("back-button");
        button_stack.add (return_button);
        button_stack.no_show_all = true;

        mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
        mode_switch.primary_icon_tooltip_text = _("Light Mode");
        mode_switch.secondary_icon_tooltip_text = _("Dark Mode");
        mode_switch.valign = Gtk.Align.CENTER;
        mode_switch.has_focus = false;

        if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
            mode_switch.active = true;
        } else {
            mode_switch.active = false;
        }

        mode_switch.notify["active"].connect (() => {
            if (mode_switch.active) {
                debug ("Get dark!");
                Palaura.Application.gsettings.set_boolean("dark-mode", true);
            } else {
                debug ("Get light!");
                Palaura.Application.gsettings.set_boolean("dark-mode", false);
            }
        });

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
        headerbar.set_title (_("Palaura"));
        headerbar.has_subtitle = false;
        headerbar.pack_start (button_stack);
        headerbar.pack_end (menu_button);
        headerbar.pack_end (mode_switch);
        headerbar.pack_start (search_entry);
        set_titlebar (headerbar);

        search_view = new Palaura.SearchView();
        normal_view = new Palaura.NormalView();
        definition_view = new Palaura.DefinitionView();
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
        stack.add (normal_view);
        stack.add (search_view);
        stack.add (definition_view);
        add (stack);

        return_history = new Gee.LinkedList<Palaura.View> ();

        int x = Palaura.Application.gsettings.get_int("window-x");
        int y = Palaura.Application.gsettings.get_int("window-y");

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
        int x, y;
        get_position (out x, out y);
        Palaura.Application.gsettings.set_int("window-x", x);
        Palaura.Application.gsettings.set_int("window-y", y);
        return false;
    }
}
