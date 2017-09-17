public class Palaura.NormalView : Palaura.View {
    Views.WordListView list_view;

    construct {
        list_view = new Views.WordListView ();
        list_view.alert_view.title = "Search a Word";
        list_view.alert_view.description = "Use the searchbar to find the word you're looking for.";
        list_view.alert_view.icon_name = "edit-find-symbolic";
        list_view.stack.show_all ();
        add (list_view);
    }

    public override string get_header_name () {
        return "Home";
    }
}
