/*
 *  vtgsymbolcompletionhelper.vala - Vala developer toys for GEdit
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
using Gsc;
using Afrodite;

namespace Vtg
{
	internal class SymbolCompletionHelper : GLib.Object
	{
		private Vtg.PluginInstance _plugin_instance;
		private Gedit.View _view;
		private unowned CompletionEngine _completion;
		private SymbolCompletionProvider _provider;
		private Gsc.Completion _manager;
		private SymbolCompletionTrigger _trigger;
		
 		public Vtg.PluginInstance plugin_instance { get { return _plugin_instance; } construct { _plugin_instance = value; } default = null; }
		public Gedit.View view { get { return _view; } construct { _view = value; } default = null; }
		public CompletionEngine completion { get { return _completion; } construct { _completion = value; } default = null; }
		public SymbolCompletionTrigger trigger { get { return _trigger; } }
		
		public SymbolCompletionHelper (Vtg.PluginInstance plugin_instance, Gedit.View view, CompletionEngine completion)
		{
			GLib.Object (plugin_instance: plugin_instance, view: view, completion: completion);
		}

		construct
		{
			if (this._view.is_realized ()) {
				setup_gsc_completion (_view);
			} else {
				this.view.realize.connect (this.on_realized);
			}
		}
		
		private void on_realized (Gtk.Widget sender)
		{
			_view.realize.disconnect (this.on_realized);
			setup_gsc_completion (_view);
		}

		~SymbolCompletionHelper ()
		{
			_manager.unregister_provider (_provider, _trigger);
			_manager.unregister_trigger (_trigger);
			_manager = null;
		}

		public void deactivate ()
		{
		}

		private void setup_gsc_completion (Gedit.View view)
		{
			_manager = new Gsc.Completion (view);
			_manager.remember_info_visibility = true;
			_manager.select_on_show = true;
			_provider = new SymbolCompletionProvider (_plugin_instance, view, _completion);
			_trigger = new SymbolCompletionTrigger (_plugin_instance, _manager, "SymbolComplete");
			_manager.register_trigger (_trigger);
			_manager.register_provider (_provider, _trigger);
			_manager.set_active (true);
		}
		
		public void goto_definition ()
		{
			Afrodite.Symbol? item = _provider.get_current_symbol_item ();
			
			if (item != null && item.has_source_references) {
				try {
					string uri = Filename.to_uri (item.source_references.get(0).file.filename);
					_plugin_instance.activate_uri (uri, item.source_references.get(0).first_line);
				} catch (Error e) {
					GLib.warning ("error %s converting file %s to uri", e.message, item.source_references.get(0).file.filename);
				}
			}
		}
	}
}
