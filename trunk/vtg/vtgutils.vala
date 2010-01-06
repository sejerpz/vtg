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
using Afrodite;
using Vbf;

namespace Vtg
{
	public errordomain ProjectManagerError
	{
		NO_BACKEND
	}
	
	public enum VcsTypes
	{
		NONE,
		GIT,
		BZR,
		SVN
	}
	
	namespace Interaction
	{
		public static void error_message (string message, Error err)
		{
			var dialog = new MessageDialog (null,
                                  DialogFlags.DESTROY_WITH_PARENT,
                                  MessageType.ERROR,
                                  ButtonsType.CLOSE,
			          message);
			dialog.secondary_text = err.message;
			dialog.run ();
			dialog.destroy ();
		}
	}
	
	public class Caches
	{
		private const int CACHE_LIMIT = 20;
		
		private static Gtk.ListStore _build_cache = null;
		private static Gtk.ListStore _compile_cache = null;
		private static Gtk.ListStore _configure_cache = null;
		private static Gtk.ListStore _executer_cache = null;
		
		public static Gtk.ListStore get_build_cache ()		
		{
			if (_build_cache == null) {
				_build_cache = new Gtk.ListStore (1, typeof (string));
			}
			
			return _build_cache;
		}

		public static Gtk.ListStore get_compile_cache ()		
		{
			if (_compile_cache == null) {
				_compile_cache = new Gtk.ListStore (1, typeof (string));
			}
			
			return _compile_cache;
		}

		public static Gtk.ListStore get_configure_cache ()		
		{
			if (_configure_cache == null) {
				_configure_cache = new Gtk.ListStore (1, typeof (string));
			}
			
			return _configure_cache;
		}

		public static Gtk.ListStore get_executer_cache ()		
		{
			if (_executer_cache == null) {
				_executer_cache = new Gtk.ListStore (1, typeof (string));
			}
			
			return _executer_cache;
		}
		
		public static bool cache_contains (Gtk.ListStore cache, string data)
		{
			TreeIter iter;
			bool found = false;
			
			if (cache.get_iter_first (out iter)) {
				do {
					string tmp;
					cache.get (iter, 0, out tmp);
					if (tmp == data) {
						found = true;
						break;
					}
				} while (cache.iter_next (ref iter));
			}
			return found;
		}
		
		public static void cache_add (Gtk.ListStore cache, string data)
		{
			TreeIter iter;
			if (cache_count (cache) > CACHE_LIMIT) {
				if (cache.get_iter_first (out iter)) {
					TreeIter target = iter;
					//find last iter
					while (cache.iter_next (ref iter)) {
						target = iter;
					}
					cache.remove (target);
				}
			}
			cache.insert (out iter, 0);
			cache.set (iter, 0, data);
		}
		
		public static int cache_count (Gtk.ListStore cache)
		{
			int count = 0;
			TreeIter iter;
			if (cache.get_iter_first (out iter)) {
				do {
					count++;
				} while (cache.iter_next (ref iter));

			}
			return count;
		}
	}
	
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
	
	namespace PathUtils
	{
		public static string normalize_path (string name)
		{
			if (name == null || name.length < 2)
				return name;
				
			string[] name_parts = name.substring (1, name.length - 1).split ("/");
			string last_item = null;

			string target_name = "";

			foreach (string item in name_parts) {
				if (item != "..") {
					if (last_item != null) {
						target_name += "/" + last_item;
					}

					last_item = item;
				} else {
					last_item = null;
				}
			}

			if (last_item != null && last_item != "..") {
				target_name += "/" + last_item;
			}

			return target_name;
		}
		
		public static int compare_vala_filenames (string filea, string fileb)
		{
			string dataa = filea;
			string datab = fileb;
			
			if (dataa.has_suffix (".vala") || dataa.has_suffix(".vapi")) {
				dataa = dataa.substring (0, dataa.length - 5);
			}
			if (datab.has_suffix (".vala") || datab.has_suffix(".vapi")) {
				datab = datab.substring (0, datab.length - 5);
			}
			return strcmp (dataa, datab);
		}
	}
	
	public class Utils : GLib.Object
	{
		private static bool _initialized = false;
		private static Proposal[] _proposals = null;
		private static Vala.List<Package> _available_packages = null;
		private static Gtk.Builder _builder = null;
		
		public const int prealloc_count = 500;

		public static Gdk.Pixbuf icon_generic;
		public static Gdk.Pixbuf icon_field;
		public static Gdk.Pixbuf icon_method;
		public static Gdk.Pixbuf icon_class;
		public static Gdk.Pixbuf icon_struct;
		public static Gdk.Pixbuf icon_property;
		public static Gdk.Pixbuf icon_signal;
		public static Gdk.Pixbuf icon_iface;
		public static Gdk.Pixbuf icon_const;
		public static Gdk.Pixbuf icon_enum;
		public static Gdk.Pixbuf icon_namespace;

		public static bool is_vala_doc (Gedit.Document doc)
		{
			return doc.language != null && doc.language.id == "vala";
		}

		public static string get_document_name (Gedit.Document doc)
		{
			string name = doc.get_uri ();
			if (name == null) {
				name = doc.get_short_name_for_display ();
			} else {
				try {
					name = Filename.from_uri (name);
				} catch (Error e) {
					GLib.warning ("error %s converting file %s to uri", e.message, name);
				}
			}
			return name;
		}

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
			
				icon_generic = IconTheme.get_default().load_icon(Gtk.STOCK_FILE,16,IconLookupFlags.GENERIC_FALLBACK);
				icon_field = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-field-16.png"));
				icon_method = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-method-16.png"));
				icon_class = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-class-16.png"));
				icon_struct = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-structure-16.png"));
				icon_property = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-property-16.png"));
				icon_signal = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-event-16.png"));
				icon_iface = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-interface-16.png"));
				icon_enum = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-enumeration-16.png"));
				icon_const = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-literal-16.png"));
				icon_namespace = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-namespace-16.png"));	

				_initialized = true;
			} catch (Error err) {
				warning (err.message);
			}
		}

		public static Vala.List<Package> get_available_packages ()
		{
			if (_available_packages == null) {
				initialize_packages_cache ();
			}
			return _available_packages;
		}

		private static void initialize_packages_cache ()
		{
			List<string> vapidirs = new List<string> ();
		        vapidirs.append (Config.VALA_VAPIDIR);
			vapidirs.append ("/usr/local/share/vala/vapi");

			_available_packages = new Vala.ArrayList<Package> ();

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
						_available_packages.add (new Package (filename.substring (0, filename.length - 5)));
					}
					filename = dir.read_name ();
				}
			}
		}
		
		public static Gdk.Pixbuf get_icon_for_type_name (string type_name)
		{
			if (!_initialized) {
				initialize ();
			}
			if (icon_namespace != null && type_name == "Namespace")
				return icon_namespace;
			else if (icon_class != null && (type_name == "Class" || type_name == "CreationMethod" || type_name == "Destructor"))
				return icon_class;
			else if (icon_struct != null && type_name == "Struct")
				return icon_struct;
			else if (icon_iface != null && type_name == "Interface")
				return icon_iface;
			else if (icon_field != null && type_name == "Field")
				return icon_field;
			else if (icon_property != null && type_name == "Property")
				return icon_property;
			else if (icon_method != null && (type_name == "Method" || type_name == "Delegate"))
				return icon_method;
			else if (icon_enum != null && type_name == "Enum")
				return icon_enum;
			else if (icon_const != null && (type_name == "Constant" || type_name == "EnumValue"))
				return icon_const;
			else if (icon_signal != null && type_name == "Signal")
				return icon_signal;

			return icon_generic;
		}

		public static string get_stock_id_for_target_type (Vbf.TargetTypes type)
		{
			switch (type) {
				case TargetTypes.PROGRAM:
					return Gtk.STOCK_EXECUTE;
				case TargetTypes.LIBRARY:
					return Gtk.STOCK_EXECUTE;
				case TargetTypes.DATA:
					return Gtk.STOCK_DIRECTORY;
				case TargetTypes.BUILT_SOURCES:
					return Gtk.STOCK_EXECUTE;
				default:
					return Gtk.STOCK_DIRECTORY;		
			}
		}
	}
}
