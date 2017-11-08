public class Core.Dict {
    public async GLib.InputStream get_entries (string text) throws GLib.Error {
        string uri = @"https://od-api.oxforddictionaries.com:443/api/v1/entries/en/$text";

        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", uri);
        Soup.MessageHeaders headers = message.request_headers;
        headers.append ("Accept","application/json");
        headers.append ("app_id","db749a02");
        headers.append ("app_key","bf44ba104ce6d42d444db54fa878a52b");
        return yield session.send_async (message);
    }

    public async Core.Definition[] search_text (string word) {
        Core.Definition[] definitions = {};

        try {
            var parser = new Json.Parser();
            parser.load_from_stream_async (yield get_entries (word), (GLib.Cancellable) null);

            var root_object = parser.get_root().get_object ();
            var results = root_object.get_array_member("results");
            var obj_results = results.get_object_element(0);
            var lexentry = obj_results.get_array_member("lexicalEntries");

            foreach (var w in lexentry.get_elements())
                definitions += Core.Definition.parse_json (w.get_object ());
        } catch (Error e) {
            warning (e.message);
        }

        return definitions;
    }

}
