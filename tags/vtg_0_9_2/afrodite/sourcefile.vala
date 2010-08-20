/* sourcefile.vala
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
	public class SourceFile
	{
		public Vala.List<DataType> using_directives { get; set; }
		public Vala.List<Symbol> symbols { get; set; }
		
		public string filename {
			get; set;
		}
		
		public SourceFile (string filename)
		{
			this.filename = filename;
		}
		
		public DataType add_using_directive (string name)
		{
			var u = lookup_using_directive (name);
			if (u == null) {
				if (using_directives == null) {
					using_directives = new ArrayList<DataType> ();
				}
				u = new DataType (name, "UsingDirective");
				using_directives.add (u);
			}
			return u;
		}
		
		public DataType? lookup_using_directive (string name)
		{
			if (using_directives != null) {
				foreach (DataType u in using_directives) {
					if (u.type_name == name) {
						return u;
					}
				}
			}
			
			return null;
		}
		
		public void remove_using_directive (string name)
		{
			var u = lookup_using_directive (name);
			if (u != null) {
				using_directives.remove (u);
				if (using_directives.size == 0)
					using_directives = null;
			}
		}
		
		public bool has_using_directives
		{
			get {
				return using_directives != null;
			}
		}
		
		public void add_symbol (Symbol symbol)
		{
			if (symbols == null) {
				symbols = new ArrayList<Symbol> ();
			}
			symbols.add (symbol);
		}
		
		public void remove_symbol (Symbol symbol)
		{
			symbols.remove (symbol);
			if (symbols.size == 0)
				symbols = null;
		}
		
		public bool has_symbols
		{
			get {
				return symbols != null;
			}
		}
	}
}
