namespace Palaura {
    public class Views.WordListView : Gtk.ScrolledWindow {
        public signal void show_definition (Core.Definition definition);
        protected Gtk.ListBox list_box;
        public Granite.Widgets.AlertView alert_view;
        public Gtk.Stack stack;

        construct {
            alert_view = new Granite.Widgets.AlertView(_("No words found"), _("Try fixing your search term."), "dialog-information-symbolic");
            alert_view.show_all();

            set_policy(Gtk.PolicyType.NEVER,
                Gtk.PolicyType.AUTOMATIC);

            stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.CROSSFADE);
            stack.set_transition_duration (400);
            stack.add (alert_view);

            list_box = new Gtk.ListBox ();
            list_box.expand = true;
            list_box.set_placeholder (stack);
            list_box.activate_on_single_click = true;
            list_box.row_activated.connect ((r) => {
                    var row = (Widgets.WordListRow) r;
                    show_definition (row.get_definition ());
                });
            add(list_box);

            if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
                alert_view.get_style_context ().add_class ("palaura-view-dark");
                alert_view.get_style_context ().remove_class ("palaura-view");
                list_box.get_style_context ().add_class ("palaura-view-dark");
                list_box.get_style_context ().remove_class ("palaura-view");
                stack.get_style_context ().add_class ("palaura-view-dark");
                stack.get_style_context ().remove_class ("palaura-view");
            } else {
                alert_view.get_style_context ().add_class ("palaura-view");
                alert_view.get_style_context ().remove_class ("palaura-view-dark");
                list_box.get_style_context ().add_class ("palaura-view");
                list_box.get_style_context ().remove_class ("palaura-view-dark");
                stack.get_style_context ().add_class ("palaura-view");
                stack.get_style_context ().remove_class ("palaura-view-dark");
            }
    
            Palaura.Application.gsettings.changed.connect (() => {
                if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
                    alert_view.get_style_context ().add_class ("palaura-view-dark");
                    alert_view.get_style_context ().remove_class ("palaura-view");
                    list_box.get_style_context ().add_class ("palaura-view-dark");
                    list_box.get_style_context ().remove_class ("palaura-view");
                    stack.get_style_context ().add_class ("palaura-view-dark");
                    stack.get_style_context ().remove_class ("palaura-view");
                } else {
                    alert_view.get_style_context ().add_class ("palaura-view");
                    alert_view.get_style_context ().remove_class ("palaura-view-dark");
                    list_box.get_style_context ().add_class ("palaura-view");
                    list_box.get_style_context ().remove_class ("palaura-view-dark");
                    stack.get_style_context ().add_class ("palaura-view");
                    stack.get_style_context ().remove_class ("palaura-view-dark");
                }
            });
        }

        public void bind_model(ListModel model, Gtk.ListBoxCreateWidgetFunc func) {
            list_box.bind_model(model, func);
        }
    }
}
