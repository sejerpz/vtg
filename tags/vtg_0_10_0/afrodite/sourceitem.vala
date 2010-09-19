/* sourceitem.vala
 *
 * Copyright (C) 2010  Andrea Del Signore
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
	public class SourceItem
	{
		public string path;
		public string content;

		public bool is_glib = false;
		public CodeContext context = null;

		public bool is_vapi 
		{
			get {
				return path != null && path.has_suffix (".vapi");
			}
		}
		
		public SourceItem copy ()
		{
			var item = new SourceItem();
			
			item.path = path;
			item.content = content;
			item.is_glib = is_glib;
			return item;
		}
	}
}

