namespace Palaura.Widgets {
    public class WordListRow : Gtk.ListBoxRow {

        Palaura.WordContainerGrid grid;

        public WordListRow(Core.Definition definition) {
            var context = this.get_style_context ();
            context.add_class ("palaura-view");
            grid = new Palaura.WordContainerGrid(definition);
            add(grid);
            show_all();
        }

        public Core.Definition get_definition () {
            return grid.definition;
        }
    }
}
