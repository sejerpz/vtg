/*
 *  vtgutils.vala - Vala developer toys for GEdit
 *  
 *  Copyright (C) 2008 - Andrea Del Signore <sejerpz@tin.it>
 *  
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *   
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *   
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330,
 *  Boston, MA 02111-1307, USA.
 */

using GLib;
using Gsc;
using Gtk;
using Vsc;
using Vtg.ProjectManager;

namespace Vtg
{
	namespace StringUtils
	{
		public static bool is_null_or_empty (string? data)
		{
			return data == null || data == "";
		}
		
		public static string replace (string data, string search, string replace) 
		{
			try {
				var regex = new GLib.Regex (GLib.Regex.escape_string (search));
				return regex.replace_literal (data, -1, 0, replace);
			} catch (GLib.RegexError e) {
				GLib.assert_not_reached ();
			}
		}
	}
	
	public class Utils : GLib.Object
	{
		private static bool _initialized = false;
		private static Proposal[] _proposals = null;
		private static Gee.List<ProjectPackage> _available_packages = null;
		private static Gtk.Builder _builder = null;
		
		public const int prealloc_count = 500;


		public static Gtk.Builder get_builder ()
		{
			if (_builder == null) {
				_builder = new Gtk.Builder ();
				try {
					_builder.add_from_file (get_ui_path ("vtg.ui"));
				} catch (Error err) {
					GLib.warning ("initialize_ui: %s", err.message);
				}
			}	
			return _builder;
		}
		
		public static weak Proposal[] get_proposal_cache ()
		{
			if (!_initialized) {
				initialize ();
			}
			return _proposals;
		}

		public static string get_image_path (string id) {
			var result = Path.build_filename (Config.PACKAGE_DATADIR, "images", id);
			return result;
		}

		public static string get_ui_path (string id) {
			var result = Path.build_filename (Config.PACKAGE_DATADIR, "ui", id);
			return result;
		}

		private static void initialize ()
		{
			try {
				_proposals = new Proposal[prealloc_count];
				var _icon_generic = IconTheme.get_default().load_icon(Gtk.STOCK_FILE,16,IconLookupFlags.GENERIC_FALLBACK);
				for (int idx = 0; idx < prealloc_count; idx++) {
					var obj = new Proposal ("", "", _icon_generic);
					_proposals[idx] = obj;
				}

				_initialized = true;
			} catch (Error err) {
				warning (err.message);
			}
		}

		public static Gee.List<ProjectPackage> get_available_packages ()
		{
			if (_available_packages == null) {
				initialize_packages_cache ();
			}
			return _available_packages;
		}

		private static void initialize_packages_cache ()
		{
			List<string> vapidirs = new List<string> ();
		        vapidirs.append ("/usr/share/vala/vapi");
			vapidirs.append ("/usr/local/share/vala/vapi");

			_available_packages = new Gee.ArrayList<ProjectPackage> ();

			foreach (string vapidir in vapidirs) {
				Dir dir;
				try {					      
					dir = Dir.open (vapidir);
				} catch (FileError err) {
					//do nothing
					continue;
				}
				string? filename = dir.read_name ();
				while (filename != null) {
					if (filename.has_suffix (".vapi")) {
						filename = filename.down ();
						_available_packages.add (new ProjectPackage (filename.substring (0, filename.length - 5)));
					}
					filename = dir.read_name ();
				}
			}
		}
	}
}
