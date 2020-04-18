public class Palaura.DefinitionView : Palaura.View {

    Gtk.ScrolledWindow scrolled_window;
    Gtk.SourceView text_view;
    Gtk.SourceBuffer buffer;
    Gtk.TextTag tag_word;
    Gtk.TextTag tag_pronunciation;
    Gtk.TextTag tag_lexical_category;
    Gtk.TextTag tag_sense_numbering;
    Gtk.TextTag tag_sense_definition;
    Gtk.TextTag tag_sense_examples;
    Gtk.TextTag tag_sense_explaining;
    Gtk.TextTag tag_sense_lexicon;
    Gtk.TextTag tag_sense_caption;
    Gtk.TextTag tag_sense_description;

    Core.Definition definition;

    construct {
        scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        scrolled_window.set_border_width (0);
        add (scrolled_window);

        text_view = new Gtk.SourceView ();
        text_view.set_wrap_mode (Gtk.WrapMode.WORD_CHAR);
        text_view.set_editable (false);
        text_view.set_cursor_visible (false);
        buffer = new Gtk.SourceBuffer (null);
        text_view.buffer = buffer;
        var style_manager = Gtk.SourceStyleSchemeManager.get_default ();
        if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
            var style = style_manager.get_scheme ("solarized-dark");
            buffer.set_style_scheme (style);
            scrolled_window.get_style_context ().add_class ("palaura-view-dark");
            scrolled_window.get_style_context ().remove_class ("palaura-view");
        } else {
            var style = style_manager.get_scheme ("solarized-light");
            buffer.set_style_scheme (style);
            scrolled_window.get_style_context ().remove_class ("palaura-view-dark");
            scrolled_window.get_style_context ().add_class ("palaura-view");
        }

        Palaura.Application.gsettings.changed.connect (() => {
            if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
                var style = style_manager.get_scheme ("solarized-dark");
                buffer.set_style_scheme (style);
                scrolled_window.get_style_context ().add_class ("palaura-view-dark");
                scrolled_window.get_style_context ().remove_class ("palaura-view");
            } else {
                var style = style_manager.get_scheme ("solarized-light");
                buffer.set_style_scheme (style);
                scrolled_window.get_style_context ().remove_class ("palaura-view-dark");
                scrolled_window.get_style_context ().add_class ("palaura-view");
            }
        });
        
        scrolled_window.add (text_view);

        tag_word = buffer.create_tag (null, "weight", Pango.Weight.BOLD, "font", "serif 18");
        tag_pronunciation = buffer.create_tag (null, "font", "serif 12");
        tag_lexical_category = buffer.create_tag (null, "font", "serif 12", "pixels-above-lines", 8, "pixels-inside-wrap", 8);
        tag_sense_numbering = buffer.create_tag (null, "font", "sans 12", "weight", Pango.Weight.HEAVY, "left-margin", 10, "pixels-above-lines", 8, "pixels-inside-wrap", 8);
        tag_sense_definition = buffer.create_tag (null, "font", "serif 12", "left-margin", 10);
        tag_sense_examples = buffer.create_tag (null, "font", "serif 12", "left-margin", 40, "pixels-above-lines", 8, "pixels-inside-wrap", 8);
        tag_sense_explaining = buffer.create_tag (null, "font", "sans 12", "left-margin", 20, "pixels-above-lines", 8, "pixels-inside-wrap", 8);
        tag_sense_lexicon = buffer.create_tag (null, "font", "sans 12", "left-margin", 10, "pixels-above-lines", 8, "pixels-inside-wrap", 8);
        tag_sense_caption = buffer.create_tag (null, "font", "sans 8", "weight", Pango.Weight.HEAVY, "variant", Pango.Variant.SMALL_CAPS, "pixels-above-lines", 8, "pixels-inside-wrap", 8, "left-margin", 40);
        tag_sense_description = buffer.create_tag (null, "font", "serif italic 12");
    }

    public void set_definition (Core.Definition definition) {
        this.definition = definition;

        Gtk.TextIter iter;
        buffer.text = "";
        buffer.get_end_iter (out iter);
        if(definition.text != null) {
            buffer.insert_with_tags (ref iter, @"■ $(definition.text) ", -1, tag_word);
        }

        var pronunciations = definition.get_pronunciations ();
        string pronunciation_str = "";
        for (int i = 0; i < pronunciations.length; i++) {
            if (pronunciations.length > 0) {
                if (i == 0) {
                    pronunciation_str += "/";
                } else {
                    pronunciation_str += "; ";
                }

                pronunciation_str += pronunciations[i].phonetic_spelling;

                if (i == pronunciations.length - 1) {
                    pronunciation_str += "/";
                }
            }
        }
        if(pronunciation_str != null) {
            buffer.insert_with_tags (ref iter, @" $(pronunciation_str) ", -1, tag_pronunciation);
        }

        buffer.insert(ref iter, "\n", -1);

        if(definition.lexical_category != null) {
            buffer.insert_with_tags (ref iter, @"▰  ", -1, tag_sense_lexicon);
            buffer.insert_with_tags (ref iter, @"$(definition.lexical_category)", -1, tag_lexical_category);
        }

        buffer.insert(ref iter, "\n", -1);

        if(definition.get_senses() != null) {
            var senses = definition.get_senses();
            for (int i = 0; i < senses.length; i++) {
                var definitions = senses[i].get_definitions ();
                if (definitions.length > 0) {
                    buffer.insert_with_tags (ref iter, @"$(i + 1).  ", -1, tag_sense_numbering);
                    buffer.insert_with_tags (ref iter, @"$(definitions[0])\n", -1, tag_sense_definition);
                }

                var examples = senses[i].get_examples ();
                if (examples.length > 0) {
                    buffer.insert_with_tags (ref iter, @"◆  ", -1, tag_sense_explaining);
                    buffer.insert_with_tags (ref iter, @"$(examples[0].text)\n", -1, tag_sense_examples);
                }
            }
        }
    }

    public override string get_header_name () {
        return _("Definition");
    }
}
