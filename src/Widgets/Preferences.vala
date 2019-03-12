/*
* Copyright (c) 2017 Lains
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/
namespace Palaura.Widgets {
    public class Preferences : Gtk.Dialog {
        public Gtk.ComboBoxText lang;

        public Preferences (Gtk.Window? parent) {
            Object (
                border_width: 0,
                deletable: false,
                resizable: false,
                title: _("Preferences"),
                transient_for: parent,
                destroy_with_parent: true,
                window_position: Gtk.WindowPosition.CENTER_ON_PARENT
            );
        }

        construct {
            var settings = AppSettings.get_default ();

            var header = new Granite.HeaderLabel (_("Dictionary Preferences"));
            var label = new SettingsLabel (_("Lookup language:"));
            var lang = new Granite.Widgets.ModeButton ();
            lang.append_text (_("English"));
            lang.append_text (_("Spanish"));

            var dict_lang = settings.dict_lang;

            switch (dict_lang) {
                case "en":
                    lang.selected = 0;
                    break;
                case "es":
                    lang.selected = 1;
                    break;
                default:
                    lang.selected = 0;
                    break;
            }

            lang.mode_changed.connect (() => {
                switch (lang.selected) {
                    case 0:
                        settings.dict_lang = "en";
                        break;
                    case 1:
                        settings.dict_lang = "es";
                        break;
                }
            });

            var main_grid = new Gtk.Grid ();
            main_grid.margin_top = 0;
            main_grid.column_spacing = 12;
            main_grid.column_homogeneous = true;
            main_grid.attach (header, 0, 1, 1, 1);
            main_grid.attach (label, 0, 2, 1, 1);
            main_grid.attach (lang, 1, 2, 1, 1);

            get_action_area ().margin = 6;

            var content = this.get_content_area () as Gtk.Box;
            content.margin = 6;
            content.margin_top = 0;
            content.add (main_grid);

            var action_area = this.get_action_area () as Gtk.Box;
            action_area.margin = 0;
            action_area.margin_top = 6;

            var close_button = this.add_button (_("Close"), Gtk.ResponseType.CLOSE);
            ((Gtk.Button) close_button).clicked.connect (() => destroy ());
        }

        private class SettingsLabel : Gtk.Label {
            public SettingsLabel (string text) {
                label = text;
                halign = Gtk.Align.END;
                margin_start = 12;
            }
        }

        private class SettingsSwitch : Gtk.Switch {
            public SettingsSwitch (string setting) {
                var main_settings = AppSettings.get_default ();
                halign = Gtk.Align.START;
                main_settings.schema.bind (setting, this, "active", SettingsBindFlags.DEFAULT);
            }
        }
    }
}
