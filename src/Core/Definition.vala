public class Palaura.Core.Definition : Object {
    public string word;

    Pronunciation[] phonetics = {};
    Pos[] pos = {};
    Sense[] senses = {};

    public static Core.Definition parse_json (Json.Object root) {

        Core.Definition obj = new Core.Definition ();

        if (root.has_member ("word"))
            obj.word = root.get_string_member ("word");

        if (root.has_member ("meanings")) {
            Json.Array meanings = root.get_array_member ("meanings");
            foreach (var pos in meanings.get_elements()) {
                obj.pos += Pos.parse_json (pos.get_object ());
                obj.senses += Sense.parse_json (pos.get_object ());
            }
        }

        if (root.has_member ("phonetics")) {
            Json.Array phonetics = root.get_array_member ("phonetics");
            foreach (var pronunciation in phonetics.get_elements())
                obj.phonetics += Pronunciation.parse_json (pronunciation.get_object ());
        }

        return obj;

    }

    public class Pronunciation {
        public string text;

        public static Pronunciation parse_json(Json.Object root) {
            Pronunciation obj = new Pronunciation();

            obj.text = root.get_string_member("text");

            return obj;
        }
    }

    public class Pos {
        public string text;

        public static Pos parse_json(Json.Object root) {
            Pos obj = new Pos();

            obj.text = root.get_string_member("partOfSpeech");

            return obj;
        }
    }

    public class Sense {
        string[] definition = {};
        string[] examples = {};

        public string[] get_definitions () {
            return definition;
        }

        public string[] get_examples () {
            return examples;
        }

        public static Sense parse_json (Json.Object root) {
            Sense obj = new Sense();

            Json.Array definitions = root.get_array_member ("definitions");
            foreach (var def in definitions.get_elements()) {
                var def_obj = def.get_object ();
                obj.definition += def_obj.get_string_member ("definition");
                obj.examples += def_obj.get_string_member ("example");
            }

            return obj;
        }
    }

    public Pronunciation[] get_phonetics () {
        return phonetics;
    }

    public Pos[] get_pos () {
        return pos;
    }

    public Sense[] get_senses () {
        return senses;
    }
}
