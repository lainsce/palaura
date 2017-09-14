namespace Widgets {
    public class WordListRow : Gtk.ListBoxRow {

        WordContainerGrid grid;

        public WordListRow(Core.Definition definition) {
            var context = this.get_style_context ();
            context.add_class ("palaura-view");
            grid = new WordContainerGrid(definition);
            add(grid);
            show_all();
        }

        public class WordContainerGrid : Gtk.Grid {

            public Core.Definition definition;
            Gtk.Label headword;

            construct {
                column_spacing = 12;
                row_spacing = 12;
                margin = 12;

                headword = new Gtk.Label ("");
                headword.set_line_wrap (true);
                headword.set_lines (2);
                headword.set_ellipsize (Pango.EllipsizeMode.END);
                headword.set_justify (Gtk.Justification.FILL);
                attach (headword, 0, 0, 1, 1);
            }

            public WordContainerGrid(Core.Definition definition) {
                this.definition = definition;

                string markup = @"<span weight=\"bold\" font_family=\"serif\" size=\"large\">$(definition.headword)</span>";

                Core.Definition.Pronunciation pronunciation = definition.get_pronunciations()[0];
                if (pronunciation != null) {
                    string ipa = pronunciation.ipa;
                    markup += @"<span font_family=\"serif\" size=\"large\"> /$ipa/ </span>";
                }

                if(definition.part_of_speech != null)
                    markup += @"<span style=\"italic\" font_family=\"serif\" size=\"large\"> $(definition.part_of_speech) </span>";

                if(definition.get_senses ().length > 0)
                    markup += @"\n<span font_family=\"serif\" size=\"large\">" + definition.get_senses ()[0].get_definitions ()[0] + "</span>";

                headword.set_markup (markup);
            }
        }

        public Core.Definition get_definition () {
            return grid.definition;
        }
    }
}
