/*
 *  vtgprojectmanagerview.vala - Vala developer toys for GEdit
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
using Gedit;
using Gdk;
using Gtk;
using Vbf;
using Vsc;
using Vala;

namespace Vtg
{
	private enum Columns
	{
		NAME = 0,
		ICON,
		SYMBOL,
		COLUMNS_COUNT
	}
	
	internal class SourceOutlinerView : GLib.Object
	{
		private unowned Vtg.PluginInstance _plugin_instance = null;
		private Gtk.TreeView _src_view;
		private Gtk.TreeModelSort _sorted;
		private Gtk.CheckButton _check_show_private_symbols;
		private TreeStore _model = null;
		private Gee.List<Vsc.SymbolItem>? _last_symbols = null;

		private Gdk.Pixbuf _icon_generic;
		private Gdk.Pixbuf _icon_field;
		private Gdk.Pixbuf _icon_method;
		private Gdk.Pixbuf _icon_class;
		private Gdk.Pixbuf _icon_struct;
		private Gdk.Pixbuf _icon_property;
		private Gdk.Pixbuf _icon_signal;
		private Gdk.Pixbuf _icon_iface;
		private Gdk.Pixbuf _icon_const;
		private Gdk.Pixbuf _icon_enum;
		private Gdk.Pixbuf _icon_namespace;
		
		private Gtk.Menu _popup_symbols;
		private uint _popup_symbols_ui_id;
		private string _popup_symbols_ui_def = """
                                        <ui>
                                        <popup name='SourceOutlinerPopupGoto'>
                                            <menuitem action='source-outliner-goto'/>
                                        </popup>
                                        </ui>""";

		const ActionEntry[] _action_entries = {
			{"source-outliner-goto", Gtk.STOCK_OPEN, N_("Goto definition..."), null, N_("Goto symbol definition"), on_source_outliner_goto}
		};

		private ActionGroup _actions;
		private VBox _side_panel;
		
		public signal void goto_source (int line, int start_column, int end_column);
		
		public Vtg.PluginInstance plugin_instance { construct { _plugin_instance = value; } }

		public SourceOutlinerView (Vtg.PluginInstance plugin_instance)
		{
			this.plugin_instance = plugin_instance;	
		}
		
		~SourceOutlinerView ()
		{
			// this method is never called? a leak?
			deactivate ();

		}
		
		public void deactivate ()
		{
			var manager = _plugin_instance.window.get_ui_manager ();
			manager.remove_action_group (_actions);
			var panel = _plugin_instance.window.get_side_panel ();
			panel.remove_item (_side_panel);
			_last_symbols = null;
		}

		construct
		{
			var panel = _plugin_instance.window.get_side_panel ();
			_side_panel = new Gtk.VBox (false, 8);
			_src_view = new Gtk.TreeView ();
			
			var column = new TreeViewColumn ();
			
			CellRenderer renderer = new CellRendererPixbuf ();
 			column.pack_start (renderer, false);
			column.add_attribute (renderer, "pixbuf", Columns.ICON);
			
			renderer = new CellRendererText ();
			column.pack_start (renderer, true);
			column.add_attribute (renderer, "text", Columns.NAME);
			
			_src_view.append_column (column);
			_src_view.set_headers_visible (false);
			_src_view.row_activated += this.on_source_outliner_view_row_activated;
			_src_view.button_press_event += this.on_source_outliner_view_button_press;
			var scroll = new Gtk.ScrolledWindow (null, null);
			scroll.add (_src_view);
			_side_panel.pack_start (scroll, true, true, 4); // add scroll + treview
			
			_check_show_private_symbols = new Gtk.CheckButton.with_label (_("Show also private symbols"));
			_check_show_private_symbols.active = true;
			_check_show_private_symbols.toggled.connect (this.on_show_private_symbol_toggled);
			_side_panel.pack_start (_check_show_private_symbols, false, true, 8);
			
			_side_panel.show_all ();
			panel.add_item (_side_panel, _("Source"), null);
			panel.activate_item (_side_panel);

			_actions = new ActionGroup ("SourceOutlinerActionGroup");
			_actions.set_translation_domain (Config.GETTEXT_PACKAGE);
			_actions.add_actions (_action_entries, this);
			var manager = _plugin_instance.window.get_ui_manager ();
			manager.insert_action_group (_actions, -1);
			try {
				_popup_symbols_ui_id = manager.add_ui_from_string (_popup_symbols_ui_def, -1);
				_popup_symbols = (Gtk.Menu) manager.get_widget ("/SourceOutlinerPopupGoto");
				assert (_popup_symbols != null);
			} catch (Error err) {
				GLib.warning ("Error %s", err.message);
			}
			
			/* initializing the model */
			_model = new Gtk.TreeStore (Columns.COLUMNS_COUNT, typeof(string), typeof(Gdk.Pixbuf), typeof(GLib.Object));
			
			_sorted = new Gtk.TreeModelSort.with_model (_model);
			_sorted.set_sort_column_id (0, SortType.ASCENDING);
			_sorted.set_sort_func (0, this.sort_model);			
			_src_view.set_model (_sorted);
			
			this._icon_generic = IconTheme.get_default().load_icon(Gtk.STOCK_FILE,16,IconLookupFlags.GENERIC_FALLBACK);
			this._icon_field = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-field-16.png"));
			this._icon_method = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-method-16.png"));
			this._icon_class = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-class-16.png"));
			this._icon_struct = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-structure-16.png"));
			this._icon_property = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-property-16.png"));
			this._icon_signal = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-event-16.png"));
			this._icon_iface = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-interface-16.png"));
			this._icon_enum = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-enumeration-16.png"));
			this._icon_const = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-literal-16.png"));
			this._icon_namespace = new Gdk.Pixbuf.from_file (Utils.get_image_path ("element-namespace-16.png"));		
		}
		
		public void clear_view ()
		{
			_model.clear ();
		}

		public void update_view (Gee.List<Vsc.SymbolItem>? symbols = null)
		{
			_src_view.set_model (null);
			clear_view ();
			if (symbols == null) {
				symbols = _last_symbols;
			}
			rebuild_model (symbols);
			_last_symbols = symbols;
			_src_view.set_model (_sorted);
			_src_view.expand_all ();
		}

		private void goto_line (SymbolItem symbol)
		{
			if (symbol.file != null) {
				int line = symbol.first_line;
				int start_col = symbol.first_column;
				int end_col = symbol.last_column;
				this.goto_source (line, start_col, end_col);
			}
		}
		
		private void on_show_private_symbol_toggled (Widget sender)
		{
			update_view ();
		}

		private void on_source_outliner_view_row_activated (Widget sender, TreePath path, TreeViewColumn column)
		{
			var tw = (TreeView) sender;
			TreeModelSort model = (TreeModelSort) tw.get_model ();
			TreeIter iter;
			
			if (model.get_iter (out iter, path)) {
				SymbolItem symbol;
				model.get (iter, Columns.SYMBOL, out symbol);
				goto_line (symbol);
			}
		}
		
		private void on_source_outliner_goto (Gtk.Action action)
		{
			TreeIter iter;
			TreeModel model;
			if (_src_view.get_selection ().get_selected (out model, out iter))
			{
				SymbolItem symbol;
				model.get (iter, Columns.SYMBOL, out symbol);
				goto_line (symbol);
			}
		}
		
		private bool on_source_outliner_view_button_press (Gtk.Widget sender, Gdk.EventButton event)
		{
			if (event.button == 3) {
				weak TreeModel model;

				var rows =  _src_view.get_selection ().get_selected_rows (out model);
				if (rows.length () == 1) {
					TreeIter iter;
					GLib.Object obj;
					weak TreePath path = rows.nth_data (0);
					model.get_iter (out iter, path);
					model.get (iter, Columns.SYMBOL, out obj);
					if (obj is SymbolItem) {
						_popup_symbols.popup (null, null, null, event.button, event.time);
					}
				}
			}
			return false;
		}
		
		private void rebuild_model (Gee.List<SymbolItem>? symbols, TreeIter? parentIter = null)
		{
			if (symbols == null)
				return;
			
			foreach (SymbolItem symbol in symbols) {
				TreeIter iter;
				
				if (_check_show_private_symbols.active
				    || (!_check_show_private_symbols.active && symbol.access != Vala.SymbolAccessibility.PRIVATE)) {
					_model.append (out iter, parentIter);
					_model.set (iter, 
						Columns.ICON, get_icon_from_symbol_type (symbol.type_name), 
						Columns.NAME, symbol.description, 
						Columns.SYMBOL, symbol);

					if (symbol.children != null) {
						rebuild_model (symbol.children, iter);
					}
				}
			}
		}
		
		private Pixbuf get_icon_from_symbol_type (string symbol)
		{
			if (_icon_namespace != null && symbol == "ValaNamespace")
				return _icon_namespace;
			else if (_icon_class != null && symbol == "ValaClass")
				return _icon_class;
			else if (_icon_struct != null && symbol == "ValaStruct")
				return _icon_struct;
			else if (_icon_iface != null && symbol == "ValaInterface")
				return _icon_iface;
			else if (_icon_field != null && symbol == "ValaField")
				return _icon_field;
			else if (_icon_property != null && symbol == "ValaProperty")
				return _icon_property;
			else if (_icon_method != null && symbol == "ValaMethod")
				return _icon_method;
			else if (_icon_enum != null && symbol == "ValaEnum")
				return _icon_enum;
			else if (_icon_const != null && symbol == "ValaConstant")
				return _icon_const;
			else if (_icon_signal != null && symbol == "ValaSignal")
				return _icon_signal;
				
			return _icon_generic;
		}

		private int sort_model (TreeModel model, TreeIter a, TreeIter b)
		{
			SymbolItem vala;
			SymbolItem valb;
			
			model.get (a, Columns.SYMBOL, out vala);
			model.get (b, Columns.SYMBOL, out valb);
			
			// why I get vala or valb with null???
			if (vala == null && valb == null)
				return 0;
			else if (vala == null && valb != null)
				return 1;
			else if (vala != null && valb == null)
				return -1;
			
			if (vala.type_name != valb.type_name) {
				if (vala.type_name == "ValaConstant") {
					return -1;
				} else if (valb.type_name == "ValaConstant") {
					return 1;
				} else if (vala.type_name == "ValaEnum") {
					return -1;
				} else if (valb.type_name == "ValaEnum") {
					return 1;										
				} else if (vala.type_name == "ValaField") {
					return -1;
				} else if (valb.type_name == "ValaField") {
					return 1;
				} else if (vala.type_name == "ValaProperty") {
					return -1;
				} else if (valb.type_name == "ValaProperty") {
					return 1;
				} else if (vala.type_name == "ValaSignal") {
					return -1;
				} else if (valb.type_name == "ValaSignal") {
					return 1;
				} else if (vala.type_name == "ValaCreationMethod" 
					|| vala.type_name == "ValaConstructor") {
					return -1;
				} else if (valb.type_name == "ValaCreationMethod"  
					|| vala.type_name == "ValaConstructor") {
					return 1;
				} else if (vala.type_name == "ValaMethod") {
					return -1;
				} else if (valb.type_name == "ValaMethod") {
					return 1;
				} else if (vala.type_name == "ValaErrorDomain") {
					return -1;
				} else if (valb.type_name == "ValaErrorDomain") {
					return 1;					
				} else if (vala.type_name == "ValaNamespace") {
					return -1;
				} else if (valb.type_name == "ValaNamespace") {
					return 1;
				} else if (vala.type_name == "ValaStruct") {
					return -1;
				} else if (valb.type_name == "ValaStruct") {
					return 1;					
				} else if (vala.type_name == "ValaClass") {
					return -1;
				} else if (valb.type_name == "ValaClass") {
					return 1;
				} else if (vala.type_name == "ValaInterface") {
					return -1;
				} else if (valb.type_name == "ValaInterface") {
					return 1;
				}
			}
			
			return GLib.strcmp (vala.name, valb.name);
		}
	}
}
