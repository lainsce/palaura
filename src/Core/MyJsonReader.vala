public errordomain MyError {
    INVALID_FORMAT
}

public class MyJsonReader {

    public string word                        { public get; public set; }
    public string audioFile                   { public get; public set; }
    public Gee.ArrayList<Gee.HashMap> entries { public get; public set; }

    public MyJsonReader (string text) {
        try {
            
            Json.Parser parser = new Json.Parser ();
            parser.load_from_data (text);

            unowned Json.Node node = parser.get_root ();
            process (node);
        } catch (Error e) {
            GLib.warning (e.message);
        }
    }

    public void process (Json.Node node) {
        try {
            if (node.get_node_type () != Json.NodeType.OBJECT) {
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
            }

            unowned Json.Object obj = node.get_object ();

            foreach (unowned string name in obj.get_members ()) {
                 
                switch (name) {
                    case "results":
                        unowned Json.Node node_results = obj.get_member (name);
                        results_process_role_array (node_results);
                        break;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);   
        }
    }

    public void results_process_role_array (Json.Node node) {
        try {
            if (node.get_node_type () != Json.NodeType.ARRAY) {
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
            } 

            unowned Json.Array array = node.get_array ();

            foreach (unowned Json.Node item in array.get_elements ()) {
                results_process_role_object (item);
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
    }

    public void results_process_role_object (Json.Node node) {
        try {
            if (node.get_node_type () != Json.NodeType.OBJECT) {
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
            }

            unowned Json.Object obj = node.get_object ();

            foreach (unowned string name in obj.get_members ()) {

                switch (name) {
                    case "lexicalEntries":
                        unowned Json.Node item = obj.get_member (name);
                        lexicalEntries_process_role_array (item);
                        break;

                    case "word":
                        unowned Json.Node item = obj.get_member (name);
                        if (item.get_node_type () != Json.NodeType.VALUE) {
                            throw new MyError.INVALID_FORMAT ("Unexpected element type %s", item.type_name ());
                        }

                        this.word = obj.get_string_member ("word");
                        break;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
    }

    public void lexicalEntries_process_role_array (Json.Node node) {
        try {
            if (node.get_node_type () != Json.NodeType.ARRAY) {
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
            } 

            unowned Json.Array array = node.get_array ();

            foreach (unowned Json.Node item in array.get_elements ()) {
                lexicalEntries_process_role_object (item);
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
    }

    public void lexicalEntries_process_role_object (Json.Node node) {
        try {
            if (node.get_node_type () != Json.NodeType.OBJECT) {
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
            }

            unowned Json.Object obj = node.get_object ();

            foreach (unowned string name in obj.get_members ()) {

                switch (name) {
                    case "entries":
                        //unowned Json.Node item = obj.get_member (name);
                        //entries_process_role_array (item);
                        break;

                    case "pronunciations":
                        unowned Json.Node item = obj.get_member (name);
                        pronunciations_process_role_array (item);
                        break;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
    }

    public void pronunciations_process_role_array (Json.Node node) {
        try {
            if (node.get_node_type () != Json.NodeType.ARRAY) {
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
            } 

            unowned Json.Array array = node.get_array ();

            foreach (unowned Json.Node item in array.get_elements ()) {
                pronunciations_process_role_object (item);
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
    }

    public void pronunciations_process_role_object (Json.Node node) {
        try {
            if (node.get_node_type () != Json.NodeType.OBJECT) {
                throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
            }

            unowned Json.Object obj = node.get_object ();

            foreach (unowned string name in obj.get_members ()) {

                switch (name) {
                    case "audioFile":
                        unowned Json.Node item = obj.get_member (name);
                        if (item.get_node_type () != Json.NodeType.VALUE) {
                            throw new MyError.INVALID_FORMAT ("Unexpected element type %s", item.type_name ());
                        }

                        this.audioFile = obj.get_string_member ("audioFile");
                        break;
                }
            }
        } catch (Error e) {
            GLib.warning (e.message);
        }
    }
}