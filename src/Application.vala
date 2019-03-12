using Granite.Widgets;

public class Palaura.App : Granite.Application {

    public Palaura.MainWindow main_window;

    construct
    {
        application_id = "com.github.lainsce.palaura";
        program_name = _("Palaura");
        app_launcher = "com.github.lainsce.palaura.desktop";
        exec_name = "com.github.lainsce.palaura";

        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);
        add_accelerator ("<Control>q", "app.quit", null);
        quit_action.activate.connect (() => {
            if (main_window != null) {
                main_window.destroy ();
            }
        });
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
        var application = new Palaura.App ();
        return application.run (args);
    }
}
