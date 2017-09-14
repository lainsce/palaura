public errordomain ApiError {
    API_RESPONSE_NOT_SUCCESS
}

public class Core.PearsonDictionaryApiClient {

    public Soup.Message http_get_entries(string dictionary, string headword, int limit) throws GLib.Error {
        string uri = @"http://api.pearson.com/v2/dictionaries/$dictionary/entries?limit=$limit&headword=$headword*";

        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", uri);
        session.send_message (message);

        if(message.status_code != 200)
            throw new ApiError.API_RESPONSE_NOT_SUCCESS(@"Undefined response $(message.status_code)");

        return message;
    }

    public async Core.Definition[] search_word(string word) {

        SourceFunc callback = search_word.callback;

        Core.Definition[] definitions = {};

        ThreadFunc<void*> run = () => {
            try {
                var parser = new Json.Parser();
                parser.load_from_data( (string) http_get_entries ("ldoce5", word, 10).response_body.flatten().data, -1);

                var root_object = parser.get_root().get_object ();
                var results = root_object.get_array_member("results");

                stdout.printf("Searching %s, %lld obtained of %lld results\n\n", word, (int64) results.get_length(), (int64) root_object.get_int_member("total"));
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
