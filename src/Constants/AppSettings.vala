namespace Palaura {
    public class AppSettings : Granite.Services.Settings {
        public int window_x { get; set; }
        public int window_y { get; set; }
        public string dict_lang { get; set; }
        private static AppSettings? instance;

        public static unowned AppSettings get_default () {
            if (instance == null) {
                instance = new AppSettings ();
            }
            return instance;
        }

        private AppSettings () {
            base ("com.github.lainsce.palaura");
        }
    }
}