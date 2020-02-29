public class Palaura.Application : Gtk.Application {
    public static GLib.Settings gsettings;
    public Palaura.MainWindow main_window;

    static construct {
        gsettings = new GLib.Settings ("com.github.lainsce.palaura");
    }

    construct {
        application_id = "com.github.lainsce.palaura";
    }

    public override void activate () {
        if (main_window == null) {
            main_window = new Palaura.MainWindow (this);
            main_window.destroy.connect (() => {
                    main_window = null;
                });
            add_window (main_window);
            main_window.show_all ();
        }

        main_window.present ();
    }

    public static int main (string[] args) {
        var application = new Palaura.Application ();
        return application.run (args);
    }
}
