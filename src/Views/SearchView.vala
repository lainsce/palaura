public class Palaura.SearchView : Palaura.View {

    int64 last_ts;
    Views.WordListView list_view;
    GLib.ListStore search_results;
    Gtk.Box spinner_container;
    Gtk.Box spinner_support_container;
    Gtk.Spinner spinner;
    Gtk.Label label_loading_info;

    Core.Dict client;

    string last_searched_word;

    public SearchView() {
        search_results = new GLib.ListStore (typeof (Core.Definition));
        client = new Core.Dict();

        list_view.bind_model (search_results, (obj) => {
                return new Widgets.WordListRow(obj as Core.Definition);
            });
        list_view.show_definition.connect ((definition) => {
                show_definition(definition);
            });
        list_view.edge_reached.connect (on_scroll);
    }

    construct {
        list_view = new Views.WordListView ();
        list_view.get_style_context ().add_class ("palaura-view");

        spinner_support_container = new Gtk.Box(Gtk.Orientation.VERTICAL, 14);
        list_view.stack.add (spinner_support_container);

        spinner_container = new Gtk.Box(Gtk.Orientation.VERTICAL, 14);
        spinner_support_container.set_center_widget (spinner_container);

        spinner = new Gtk.Spinner ();
        spinner.set_size_request (32, 32);
        spinner_container.pack_start (spinner);

        label_loading_info = new Gtk.Label ("Finding your word, please wait...");
        spinner_container.pack_start (label_loading_info);


        list_view.stack.set_visible_child (spinner_support_container);
        list_view.stack.show_all ();
        spinner.active = true;

        add (list_view);
    }

    public override string get_header_name () {
        return "Search";
    }

    public void search (string word, bool append = false) {
        int64 ts = GLib.get_real_time() / 1000;

        last_searched_word = word;

        list_view.stack.set_visible_child (spinner_support_container);
        list_view.stack.show_all ();
		spinner.active = true;

        if(!append) search_results.remove_all();
        client.search_word.begin (word, (obj, res) => {
                Core.Definition[] definitions = client.search_word.end(res);
                if(last_ts > ts) return;
                last_ts = ts;
                if(definitions.length == 0) {
                    list_view.stack.set_visible_child (list_view.alert_view);
                }
                foreach (var definition in definitions)
                    search_results.append(definition);
            });
    }

    public void on_scroll (Gtk.PositionType pos) {
        if (pos == Gtk.PositionType.BOTTOM) {
            search (last_searched_word, true);
        }
    }

}
