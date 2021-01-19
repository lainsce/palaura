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
        public string audio;

        public static Pronunciation parse_json(Json.Object root) {
            Pronunciation obj = new Pronunciation();

            obj.text = root.get_string_member("text");
            obj.audio = root.get_string_member("audio");

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
        Synonym[] synonyms = {};
        Antonym[] antonyms = {};

        public string[] get_definitions () {
            return definition;
        }

        public string[] get_examples () {
            return examples;
        }

        public Synonym[] get_synonyms () {
            return synonyms;
        }
    
        public Antonym[] get_antonyms () {
            return antonyms;
        }

        public class Synonym {
            public string text;

            public static Synonym parse_json (Json.Object root) {
                Synonym obj = new Synonym ();

                if (root.has_member ("text"))
                    obj.text = root.get_string_member ("text");

                return obj;
            }
        }

        public class Antonym {
            public string text;

            public static Antonym parse_json (Json.Object root) {
                Antonym obj = new Antonym ();

                if (root.has_member ("text"))
                    obj.text = root.get_string_member ("text");

                return obj;
            }
        }

        public static Sense parse_json (Json.Object root) {
            Sense obj = new Sense();

            Json.Array definitions = root.get_array_member ("definitions");
            foreach (var def in definitions.get_elements()) {
                var def_obj = def.get_object ();
                obj.definition += def_obj.get_string_member ("definition");
                obj.examples += def_obj.get_string_member ("example");
            }

            if (root.has_member ("synonyms")) {
                Json.Array synonyms = root.get_array_member ("synonyms");
                foreach (var synonym in synonyms.get_elements ())
                    obj.synonyms += Synonym.parse_json (synonym.get_object ());
            }

            if (root.has_member ("antonyms")) {
                Json.Array antonyms = root.get_array_member ("antonyms");
                foreach (var antonym in antonyms.get_elements ())
                    obj.antonyms += Antonym.parse_json (antonym.get_object ());
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
