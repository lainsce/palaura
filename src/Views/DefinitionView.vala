public class Palaura.DefinitionView : Palaura.View {
    Gtk.ScrolledWindow scrolled_window;
    Gtk.SourceView text_view;
    Gtk.Label word_label;
    Gtk.SourceBuffer buffer;
    Gtk.Grid definition_grid;
    Gtk.TextTag tag_word;
    Gtk.TextTag tag_pronunciation;
    Gtk.TextTag tag_pos;
    Gtk.TextTag tag_sense_numbering;
    Gtk.TextTag tag_sense_definition;
    Gtk.TextTag tag_sense_examples;
    Gtk.TextTag tag_sense_explaining;
    Gtk.TextTag tag_sense_lexicon;
    Gtk.TextTag tag_sense_caption;
    Gtk.TextTag tag_sense_description;

    Core.Definition definition;

    construct {
        set_size_request (360, -1);

        scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.set_border_width (0);

        text_view = new Gtk.SourceView ();
        text_view.expand = true;
        text_view.bottom_margin = text_view.left_margin = text_view.right_margin = 12;
        text_view.set_wrap_mode (Gtk.WrapMode.WORD_CHAR);
        text_view.set_editable (false);
        text_view.set_cursor_visible (false);
        buffer = new Gtk.SourceBuffer (null);
        text_view.buffer = buffer;
        var style_manager = Gtk.SourceStyleSchemeManager.get_default ();
        if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
            scrolled_window.get_style_context ().add_class ("palaura-view-dark");
            scrolled_window.get_style_context ().remove_class ("palaura-view");
        } else {
            scrolled_window.get_style_context ().remove_class ("palaura-view-dark");
            scrolled_window.get_style_context ().add_class ("palaura-view");
        }

        Palaura.Application.gsettings.changed.connect (() => {
            if (Palaura.Application.gsettings.get_boolean("dark-mode")) {
                scrolled_window.get_style_context ().add_class ("palaura-view-dark");
                scrolled_window.get_style_context ().remove_class ("palaura-view");
            } else {
                scrolled_window.get_style_context ().remove_class ("palaura-view-dark");
                scrolled_window.get_style_context ().add_class ("palaura-view");
            }
        });

        word_label = new Gtk.Label ("");
        word_label.use_markup = true;

        var word_play_button = new Gtk.Button ();
        word_play_button.image = new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.BUTTON);
        word_play_button.clicked.connect (() => {
            var player = new StreamPlayer ();
            var word_audio_str = definition.get_phonetics ()[0].audio;
            player.play (word_audio_str);
        });

        var word_grid = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        word_grid.margin = 6;
        word_grid.add (word_label);
        word_grid.add (word_play_button);

        definition_grid = new Gtk.Grid ();
        definition_grid.attach (word_grid, 0, 0, 1, 1);
        definition_grid.attach (text_view, 0, 1, 1, 2);
        definition_grid.show_all ();

        scrolled_window.add (definition_grid);
        add (scrolled_window);

        tag_word = buffer.create_tag (null, "weight", Pango.Weight.BOLD, "font", "serif 18");
        tag_pronunciation = buffer.create_tag (null, "font", "serif 14");
        tag_pos = buffer.create_tag (null, "font", "serif 12", "pixels-above-lines", 8, "pixels-inside-wrap", 8);
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
        
        var pronunciations = definition.get_phonetics ();
        string pronunciation_str = "";
        for (int i = 0; i < pronunciations.length; i++) {
            if (pronunciations.length > 0) {
                if (i == 0) {
                } else {
                    pronunciation_str += "; ";
                }
                pronunciation_str += pronunciations[i].text;
            }
        }

        if(definition.word != null) {
            word_label.label = @"<span weight=\"bold\" font_family=\"serif\" size=\"xx-large\">■ $(definition.word) - $(pronunciation_str)</span>";
        }

        buffer.insert(ref iter, "\n", -1);

        Core.Definition.Pos pos = definition.get_pos()[0];
        if (pos != null) {
            string pos_text = pos.text;
            buffer.insert_with_tags (ref iter, @"▰  ", -1, tag_sense_lexicon);
            buffer.insert_with_tags (ref iter, @"$(pos_text)", -1, tag_pos);
        }

        buffer.insert(ref iter, "\n", -1);

        if(definition.get_senses() != null) {
            var senses = definition.get_senses();
            for (int i = 0; i < senses.length +1; i++) {
                var definitions = senses[i].get_definitions ();
                if (definitions.length > 0) {
                    buffer.insert_with_tags (ref iter, @"$(i + 1).  ", -1, tag_sense_numbering);
                    buffer.insert_with_tags (ref iter, @"$(definitions[0])\n", -1, tag_sense_definition);
                }

                var examples = senses[i].get_examples ();
                if (examples.length > 0) {
                    buffer.insert_with_tags (ref iter, @"◆  ", -1, tag_sense_explaining);
                    buffer.insert_with_tags (ref iter, @"$(examples[0])\n", -1, tag_sense_examples);
                }

                var synonyms = senses[i].get_synonyms ();
                if (synonyms.length > 0) {
                    buffer.insert_with_tags (ref iter, @"⊕  ", -1, tag_sense_explaining);
                    buffer.insert_with_tags (ref iter, @"$(synonyms[0].text)\n", -1, tag_sense_examples);
                }

                var antonyms = senses[i].get_antonyms ();
                if (antonyms.length > 0) {
                    buffer.insert_with_tags (ref iter, @"⊗  ", -1, tag_sense_explaining);
                    buffer.insert_with_tags (ref iter, @"$(antonyms[0].text)\n", -1, tag_sense_examples);
                }
            }
        }
    }

    public override string get_header_name () {
        return _("«Definition");
    }
}

public class Palaura.StreamPlayer {

    private MainLoop loop = new MainLoop ();
    dynamic Gst.Element playef;

    private bool bus_callback (Gst.Bus bus, Gst.Message message) {
        switch (message.type) {
        case Gst.MessageType.ERROR:
            GLib.Error err;
            string debug;
            message.parse_error (out err, out debug);
            stdout.printf ("Error: %s\n", err.message);
            loop.quit ();
            break;
        case Gst.MessageType.EOS:
            playef.set_state (Gst.State.NULL);
            loop.quit ();
            break;
        case Gst.MessageType.STATE_CHANGED:
            Gst.State oldstate;
            Gst.State newstate;
            Gst.State pending;
            message.parse_state_changed (out oldstate, out newstate,
                                         out pending);
            stdout.printf ("state changed: %s->%s:%s\n",
                           oldstate.to_string (), newstate.to_string (),
                           pending.to_string ());
            break;
        default:
            break;
        }

        return true;
    }

    public void play (string stream) {
        playef = Gst.ElementFactory.make ("playbin", "playef");
        playef.uri = stream;

        Gst.Bus bus = playef.get_bus ();
        bus.add_watch (0, bus_callback);
        playef.set_state (Gst.State.PLAYING);

        loop.run ();
    }
}
