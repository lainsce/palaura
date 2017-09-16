public class Core.Dict {

    public Soup.Message get_entries(string word) throws GLib.Error {
        string uri = @"https://od-api.oxforddictionaries.com:443/api/v1/entries/en/$word";

        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", uri);
        Soup.MessageHeaders headers = message.request_headers;
        headers.append ("Accept","application/json");
        headers.append ("app_id","db749a02");
        headers.append ("app_key","bf44ba104ce6d42d444db54fa878a52b");
        session.send_message (message);
        return message;
    }

    public async Core.Definition[] search_word(string word) {

        SourceFunc callback = search_word.callback;

        Core.Definition[] definitions = {};

        GLib.ThreadFunc<void*> run = () => {
            try {
                var parser = new Json.Parser();
                parser.load_from_data( (string) get_entries (word).response_body.data, -1);

                // TODO: Make this result in every entry instead of erroring out.
                var root_object = parser.get_root().get_object ();
                var results = root_object.get_array_member("results");

                stdout.printf("\nSearching %s\n", word);
                foreach (var w in results.get_elements())
                    definitions += Core.Definition.parse_json (w.get_object ());

                Idle.add((owned) callback);
            } catch (Error e) {
                stderr.printf(e.message);
            }
            return null;
        };

        new GLib.Thread<void*> ("", run);
        yield;

        return definitions;
    }

}
