public class Palaura.DefinitionView : Palaura.View {

    Gtk.ScrolledWindow scrolled_window;
    Gtk.TextView text_view;
    Gtk.TextBuffer buffer;
    Gtk.TextTag tag_word;
    Gtk.TextTag tag_pronunciation;
    Gtk.TextTag tag_lexical_category;
    Gtk.TextTag tag_sense_numbering;
    Gtk.TextTag tag_sense_definition;
    Gtk.TextTag tag_sense_examples;
    Gtk.TextTag tag_sense_caption;
    Gtk.TextTag tag_sense_description;

    Core.Definition definition;

    construct {
        scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.get_style_context ().add_class ("palaura-view");
        scrolled_window.set_policy (Gtk.PolicyType.NEVER,
            Gtk.PolicyType.AUTOMATIC);
        scrolled_window.set_border_width (12);
        add (scrolled_window);

        text_view = new Gtk.TextView ();
        text_view.get_style_context ().add_class ("palaura-view");
        text_view.set_wrap_mode (Gtk.WrapMode.WORD_CHAR);
        text_view.set_editable (false);
        text_view.set_cursor_visible (false);
        scrolled_window.add (text_view);

        buffer = text_view.get_buffer ();
        tag_word = buffer.create_tag (null, "weight", Pango.Weight.BOLD, "font", "serif 18");
        tag_pronunciation = buffer.create_tag (null, "font", "serif 12");
        tag_lexical_category = buffer.create_tag (null, "font", "serif 12");
        tag_sense_numbering = buffer.create_tag (null, "font", "sans 12", "weight", Pango.Weight.HEAVY, "left-margin", 10, "pixels-above-lines", 14);
        tag_sense_definition = buffer.create_tag (null, "font", "serif 12", "left-margin", 10);
        tag_sense_examples = buffer.create_tag (null, "font", "serif 12", "left-margin", 40, "pixels-above-lines", 8);
        tag_sense_caption = buffer.create_tag (null, "font", "sans 8", "weight", Pango.Weight.HEAVY, "variant", Pango.Variant.SMALL_CAPS, "pixels-above-lines", 8, "left-margin", 40);
        tag_sense_description = buffer.create_tag (null, "font", "serif italic 12");
    }

    public void set_definition (Core.Definition definition) {
        this.definition = definition;


        Gtk.TextIter iter;
        buffer.text = "";
        buffer.get_end_iter (out iter);
        buffer.insert_with_tags (ref iter, @"■ $(definition.text) ", -1, tag_word);

        var pronunciations = definition.get_pronunciations ();
        string pronunciation_str = "";
        for (int i = 0; i < pronunciations.length; i++) {
            if(i == 0) pronunciation_str += "/";
            else pronunciation_str += "; ";
            pronunciation_str += pronunciations[i].phonetic_spelling;
            if(i == pronunciations.length - 1) pronunciation_str += "/";
        }
        buffer.insert_with_tags (ref iter, @" $(pronunciation_str) ", -1, tag_pronunciation);

        buffer.insert(ref iter, "\n\n", -1);

        if(definition.lexical_category != null)
            buffer.insert_with_tags (ref iter, @"💬 $(definition.lexical_category)", -1, tag_lexical_category);

        buffer.insert(ref iter, "\n", -1);

        var senses = definition.get_senses();
        for (int i = 0; i < senses.length; i++) {
            string definition_str = "";
            var definitions = senses[i].get_definitions ();
            for (int j = 0; j < definitions.length; j++) {
                if(j != definitions.length - 1) definition_str += "; ";
                definition_str += definitions[i];
            }
            buffer.insert_with_tags (ref iter, @"$(i + 1). ", -1, tag_sense_numbering);
            buffer.insert_with_tags (ref iter, @"\t$definition_str\n", -1, tag_sense_definition);

            var examples = senses[i].get_examples ();
            buffer.insert_with_tags (ref iter, @"◆\t$(examples[i].text)\n", -1, tag_sense_examples);
        }
    }

    public override string get_header_name () {
        return "Definition";
    }
}
