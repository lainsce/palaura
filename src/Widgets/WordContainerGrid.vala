namespace Palaura {
    public class WordContainerGrid : Gtk.Grid {
        public Core.Definition definition;
        Gtk.Label text;
        string markup;

        construct {
            column_spacing = 12;
            row_spacing = 12;
            margin = 12;

            text = new Gtk.Label ("");
            text.use_markup = true;
            text.set_line_wrap (true);
            text.set_lines (2);
            text.set_ellipsize (Pango.EllipsizeMode.END);
            text.set_justify (Gtk.Justification.FILL);
            add (text);
        }

        public WordContainerGrid(Core.Definition definition) {
            this.definition = definition;

            markup = "<span weight=\"bold\" font_family=\"serif\" size=\"large\">"+definition.word+" </span>";

            Core.Definition.Pronunciation pronunciation = definition.get_phonetics()[0];
            if (pronunciation != null) {
                string phonetic_spelling = pronunciation.text;
                markup += @"<span font_family=\"serif\" size=\"large\">"+phonetic_spelling+"</span>";
            }

            Core.Definition.Pos pos = definition.get_pos()[0];
            if (pos != null) {
                string pos_text = pos.text;
                markup += @"<span style=\"italic\" font_family=\"serif\" size=\"large\"> "+pos_text+" </span>";
            }

            if(definition.get_senses ().length > 0)
                markup += @"\n<span font_family=\"serif\" size=\"large\"> "+definition.get_senses ()[0].get_definitions ()[0]+" </span>";

            text.set_markup (markup);
        }
    }
}