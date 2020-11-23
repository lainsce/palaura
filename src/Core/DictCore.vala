public class Palaura.Core.Dict {
    public async string get_entries (string text) throws GLib.Error {
        string dict = Palaura.Application.gsettings.get_string("dict-lang");
        Palaura.Application.gsettings.changed.connect (() => {
            if (Palaura.Application.gsettings.get_string("dict-lang") == "en") {
                dict = "en";
            } else if (Palaura.Application.gsettings.get_string("dict-lang") == "es") {
                dict = "es";
            }
        });

        string ltext = text.down ();
        string uri = @"https://api.dictionaryapi.dev/api/v2/entries/$dict/$ltext";
        string response = "";

        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", uri);

        session.queue_message (message, (sess, mess) => {
            response = (string) mess.response_body.data;

            Idle.add (get_entries.callback);
        });

        yield;
        return response;
    }

    public async Core.Definition[] search_text (string word) {
        Core.Definition[] definitions = {};

        try {
            var parser = new Json.Parser();
            parser.load_from_data (yield get_entries (word));

            var root_object = parser.get_root ();
            var results = root_object.get_array ();

            foreach (var w in results.get_elements ())
                definitions += Core.Definition.parse_json (w.get_object ());
        } catch (Error e) {
            warning (e.message);
        }

        return definitions;
    }

}
