namespace Palaura.Widgets {
    public class WordListRow : Gtk.ListBoxRow {

        Palaura.WordContainerGrid grid;

        public WordListRow(Core.Definition definition) {
            grid = new Palaura.WordContainerGrid(definition);

            if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
                this.get_style_context ().add_class ("palaura-view-dark");
                this.get_style_context ().remove_class ("palaura-view");
            } else {
                this.get_style_context ().remove_class ("palaura-view-dark");
                this.get_style_context ().add_class ("palaura-view");
            }
    
            Palaura.Application.gsettings.changed.connect (() => {
                if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
                    this.get_style_context ().add_class ("palaura-view-dark");
                    this.get_style_context ().remove_class ("palaura-view");
                } else {
                    this.get_style_context ().remove_class ("palaura-view-dark");
                    this.get_style_context ().add_class ("palaura-view");
                }
            });

            add(grid);
            show_all();
        }

        public Core.Definition get_definition () {
            return grid.definition;
        }
    }
}
