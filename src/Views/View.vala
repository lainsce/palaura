public abstract class Palaura.View : Gtk.Stack {
    public signal void show_definition (Core.Definition definition);
    
    construct
    {
        transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
        expand = true;
    }

    public abstract string get_header_name ();

}
