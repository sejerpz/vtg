/* parser.vala
 *
 * Copyright (C) 2009  Andrea Del Signore
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 * 	Andrea Del Signore <sejerpz@tin.it>
 */

using GLib;
using Vala;

namespace Afrodite
{	
	public class Parser : GLib.Object
	{
		private Gee.List<SourceItem> _sources;
		public Vala.SourceFile source_file;
		public CodeContext context = null;
		
		public Parser (Gee.List<SourceItem> sources)
		{
			_sources = sources;
		}
		
		public void parse ()
		{
			context = new Vala.CodeContext();
			CodeContext.push (context);
			bool has_glib = false;
			foreach (SourceItem source in _sources) {
				if (source.is_glib) {
					has_glib = true;
					break;
				}
			}
			if (!has_glib) {
				if (!Utils.add_package ("glib-2.0", context))
					GLib.error ("failed to add GLib 2.0");
			
				if (!Utils.add_package ("gobject-2.0", context))
					GLib.error ("failed to add GObject 2.0");
			}			
			foreach (SourceItem source in _sources) {
				if (source.content == null) 
					source_file = new Vala.SourceFile (context, source.path, source.is_vapi); // normal source
				else if (source.content != "") {
					source_file = new Vala.SourceFile (context, source.path, source.is_vapi, source.content); // live buffer
				} else {
					warning ("sourcefile %s with empty content not queued", source.path);
				}
				var ns_ref = new UsingDirective (new UnresolvedSymbol (null, "GLib", null));
				context.root.add_using_directive (ns_ref);
				context.add_source_file (source_file);
				source_file.add_using_directive (ns_ref);
			}
						
			context.assert = false;
			context.checking = false;
			context.non_null_experimental = false;
			context.compile_only = true;

			context.profile = Profile.GOBJECT;
			context.add_define ("GOBJECT");
			context.add_define ("VALA_0_7_6_NEW_METHODS");
			
			int glib_major = 2;
			int glib_minor = 12;
			context.target_glib_major = glib_major;
			context.target_glib_minor = glib_minor;
			
			var parser = new Vala.Parser ();
			parser.parse (context);
			
			CodeContext.pop ();
		}		
	}
}
