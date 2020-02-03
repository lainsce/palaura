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
                border_width: 6,
                deletable: false,
                resizable: false,
                title: _("Preferences"),
                transient_for: parent,
                destroy_with_parent: true,
                window_position: Gtk.WindowPosition.CENTER_ON_PARENT
            );
        }

        construct {
            var header = new Granite.HeaderLabel (_("Dictionary Preferences"));
            var label = new SettingsLabel (_("Lookup language:"));
            var lang = new Gtk.ComboBoxText ();
            lang.append_text (_("English"));
            lang.append_text (_("Spanish"));
            var dict_lang = Palaura.Application.gsettings.get_string("dict-lang");

            switch (dict_lang) {
                case "en":
                    lang.active = 0;
                    break;
                case "es":
                    lang.active = 1;
                    break;
                default:
                    lang.active = 0;
                    break;
            }
            lang.changed.connect (() => {
                switch (lang.active) {
                    case 0:
                        Palaura.Application.gsettings.set_string("dict-lang", "en");
                        break;
                    case 1:
                        Palaura.Application.gsettings.set_string("dict-lang", "es");
                        break;
                }
            });

            var main_grid = new Gtk.Grid ();
            main_grid.margin_top = 0;
            main_grid.margin = 6;
            main_grid.column_spacing = 12;
            main_grid.column_homogeneous = true;
            main_grid.attach (header, 0, 1, 1, 1);
            main_grid.attach (label, 0, 2, 1, 1);
            main_grid.attach (lang, 1, 2, 1, 1);

            ((Gtk.Container) get_content_area ()).add (main_grid);

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
    }
}
