public class Core.Definition : Object {
    public string text;
    public string lexical_category;

    Sense[] senses = {};
    Pronunciation[] pronunciations = {};

    public static Core.Definition parse_json (Json.Object root) {

        Core.Definition obj = new Core.Definition ();

        if (root.has_member ("text"))
            obj.text = root.get_string_member ("text");

        if (root.has_member ("lexicalCategory"))
            obj.lexical_category = root.get_string_member ("lexicalCategory");

        if (root.has_member ("pronunciations")) {
            Json.Array pronunciations = root.get_array_member ("pronunciations");
            foreach (var pronunciation in pronunciations.get_elements())
                obj.pronunciations += Pronunciation.parse_json (pronunciation.get_object ());
        }

        if (root.has_member ("entries")) {
            Json.Array entries = root.get_array_member ("entries");
            var obj_entries = entries.get_object_element(0);
            Json.Array senses = obj_entries.get_array_member("senses");
            foreach (var sense in senses.get_elements())
                obj.senses += Sense.parse_json (sense.get_object ());
        }

        return obj;

    }

    public class Sense {
        string[] definitions = {};
        Example[] examples = {};

        public string[] get_definitions () {
            return definitions;
        }

        public Example[] get_examples () {
            return examples;
        }

        public class Example {
            public string text;

            public static Example parse_json (Json.Object root) {
                Example obj = new Example ();

                if (root.has_member ("text"))
                    obj.text = root.get_string_member ("text");

                return obj;
            }
        }

        public static Sense parse_json (Json.Object root) {
            Sense obj = new Sense();

            if (root.has_member ("definitions")) {
                Json.Array definitions = root.get_array_member ("definitions");
                foreach (var definition in definitions.get_elements ())
                    obj.definitions += definition.get_string ();
            }

            if (root.has_member ("examples")) {
                Json.Array examples = root.get_array_member ("examples");
                foreach (var example in examples.get_elements ())
                    obj.examples += Example.parse_json (example.get_object ());
            }

            return obj;
        }
    }

    public class Pronunciation {
        public string phonetic_spelling;

        public static Pronunciation parse_json(Json.Object root) {
            Pronunciation obj = new Pronunciation();

            if (root.has_member ("phoneticSpelling"))
                obj.phonetic_spelling = root.get_string_member("phoneticSpelling");

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
