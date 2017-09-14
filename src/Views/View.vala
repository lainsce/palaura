public abstract class Palaura.View : Gtk.Stack {
    public signal void show_definition (Core.Definition definition);
    
    construct
    {
    	this.get_style_context ().add_class ("paraula-view");
        transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
        expand = true;
    }

    public abstract string get_header_name ();

}
