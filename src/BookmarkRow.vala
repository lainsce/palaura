public class Palaura.BookmarkRow : Gtk.ListBoxRow {
    public Gtk.Label label;

    string? _path = "";
    public string title {
        owned get {
            return label.label;
        }
        set {
            _path = value;
            if (label != null) {
                label.label = _path;
            }
        }
    }

    public BookmarkRow (string title) {
        this.activatable = true;
        this.title = title;

        var row_grid = new Gtk.Grid ();
        row_grid.margin = 6;
        row_grid.margin_start = 12;

        this.add (row_grid);
        this.show_all ();

        label = new Gtk.Label (title);
        row_grid.add (label);
        row_grid.show_all ();
    }
}
