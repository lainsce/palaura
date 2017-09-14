public class Core.Definition : Object {
    public string headword;
    public string part_of_speech;
    public string url;
    public string id;
    string[] datasets = {};

    Sense[] senses = {};
    Pronunciation[] pronunciations = {};

    public static Core.Definition parse_json (Json.Object root) {

        Core.Definition obj = new Core.Definition ();

        if (root.has_member ("datasets")) {
            Json.Array datasets = root.get_array_member ("datasets");
            foreach (var dataset in datasets.get_elements ())
                obj.datasets += dataset.get_string ();
        }

        if (root.has_member ("headword"))
            obj.headword = root.get_string_member ("headword");

        if (root.has_member ("id"))
            obj.id = root.get_string_member ("id");

        if (root.has_member ("part_of_speech"))
            obj.part_of_speech = root.get_string_member ("part_of_speech");


        if (root.has_member ("pronunciations")) {
            Json.Array pronunciations = root.get_array_member ("pronunciations");
            foreach (var pronunciation in pronunciations.get_elements())
                obj.pronunciations += Pronunciation.parse_json (pronunciation.get_object ());
        }

        if (root.has_member ("senses")) {
            Json.Array senses = root.get_array_member ("senses");
            foreach (var sense in senses.get_elements())
                obj.senses += Sense.parse_json (sense.get_object ());
        }

        if (root.has_member ("url"))
            obj.url = root.get_string_member("url");

        return obj;

    }

    public class Sense {
        string[] definitions = {};
        public string synonym;
        public string lexical_unit;
        public string signpost;
        public string opposite;

        Example[] examples = {};
        CollocationExample[] collocation_examples = {};
        GramaticalExample[] grammatical_examples = {};

        public string[] get_definitions () {
            return definitions;
        }

        public Example[] get_examples () {
            return examples;
        }

        public CollocationExample[] get_collocation_examples () {
            return collocation_examples;
        }

        public GramaticalExample[] get_grammatical_examples () {
            return grammatical_examples;
        }

        public class Example {
            public string text;

            Audio[] audios = {};

            public Audio[] get_audios () {
                return audios;
            }

            public class Audio {
                public string type;
                public string url;

                public static Audio parse_json(Json.Object root) {
                    Audio obj = new Audio();

                    if (root.has_member ("type"))
                        obj.type = root.get_string_member("type");

                    if (root.has_member ("url"))
                        obj.url = root.get_string_member("url");

                    return obj;
                }
            }

            public static Example parse_json (Json.Object root) {
                Example obj = new Example ();

                if (root.has_member ("text"))
                    obj.text = root.get_string_member ("text");

                if (root.has_member ("audio")) {
                    Json.Array audios = root.get_array_member ("audio");
                    foreach (var audio in audios.get_elements ())
                        obj.audios += Audio.parse_json (audio.get_object ());
                }

                return obj;
            }
        }

        public class CollocationExample {
            public Example example;
            public string collocation;

            public static CollocationExample parse_json (Json.Object root) {
                CollocationExample obj = new CollocationExample();

                if (root.has_member ("collocation"))
                    obj.collocation = root.get_string_member ("collocation");

                if (root.has_member ("example"))
                    obj.example = Example.parse_json (root.get_object_member ("example"));

                return obj;
            }
        }

        public class GramaticalExample {
            Example[] examples = {};
            public string pattern;

            public Example[] get_examples () {
                return examples;
            }

            public static GramaticalExample parse_json (Json.Object root) {
                GramaticalExample obj = new GramaticalExample();

                if (root.has_member ("pattern"))
                    obj.pattern = root.get_string_member ("pattern");

                if (root.has_member ("examples")) {
                    Json.Array examples = root.get_array_member ("examples");
                    foreach (var example in examples.get_elements ())
                        obj.examples += Example.parse_json (example.get_object ());
                }

                return obj;
            }
        }

        public static Sense parse_json (Json.Object root) {
            Sense obj = new Sense();

            if (root.has_member ("definition")) {
                Json.Array definitions = root.get_array_member ("definition");
                foreach (var definition in definitions.get_elements ())
                    obj.definitions += definition.get_string ();
            }

            if (root.has_member ("examples")) {
                Json.Array examples = root.get_array_member ("examples");
                foreach (var example in examples.get_elements ())
                    obj.examples += Example.parse_json (example.get_object ());
            }

            if (root.has_member ("gramatical_examples")) {
                Json.Array grammatical_examples = root.get_array_member("gramatical_examples");
                foreach (var grammatical_example in grammatical_examples.get_elements ())
                    obj.grammatical_examples += GramaticalExample.parse_json (grammatical_example.get_object ());
            }

            if (root.has_member ("collocation_examples")) {
                Json.Array collocation_examples = root.get_array_member("collocation_examples");
                foreach (var collocation_example in collocation_examples.get_elements ())
                    obj.collocation_examples += CollocationExample.parse_json (collocation_example.get_object ());
            }


            if (root.has_member ("lexical_unit"))
                obj.lexical_unit = root.get_string_member ("lexical_unit");

            if (root.has_member ("signpost"))
                obj.signpost = root.get_string_member ("signpost");

            if (root.has_member ("synonym"))
                obj.synonym = root.get_string_member ("synonym");

            if (root.has_member ("opposite"))
                obj.opposite = root.get_string_member ("opposite");

            return obj;
        }
    }

    public class Pronunciation {
        public string ipa;
        public string lang;

        Audio[] audios = {};

        public class Audio {
            public string lang;
            public string type;
            public string url;

            public static Audio parse_json(Json.Object root) {
                Audio obj = new Audio();

                if (root.has_member ("lang"))
                    obj.lang = root.get_string_member("lang");

                if (root.has_member ("type"))
                    obj.type = root.get_string_member("type");

                if (root.has_member ("url"))
                    obj.url = root.get_string_member("url");

                return obj;
            }
        }

        public Audio[] get_audios () {
            return audios;
        }

        public static Pronunciation parse_json(Json.Object root) {
            Pronunciation obj = new Pronunciation();

            if (root.has_member ("audio")) {
                Json.Array audios = root.get_array_member("audio");
                foreach (var audio in audios.get_elements ())
                    obj.audios += Audio.parse_json (audio.get_object ());
            }

            if (root.has_member ("ipa"))
                obj.ipa = root.get_string_member("ipa");

            if (root.has_member ("lang"))
                obj.lang = root.get_string_member("lang");

            return obj;
        }
    }

    public Pronunciation[] get_pronunciations () {
        return pronunciations;
    }

    public Sense[] get_senses () {
        return senses;
    }
}
