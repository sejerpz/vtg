/*
 *  vbfamprojectmanager.vala - Vala Build Framework library
 *  
 *  Copyright (C) 2008 - Andrea Del Signore <sejerpz@tin.it>
 *  
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 */


using GLib;

namespace Vbf.Am
{
	public class ProjectManager : IProjectManager, GLib.Object
	{
		/*
		 * check if the given directory is a base source dir
		 * of an autotool project.
		 */
		public bool probe (string project_file)
		{
			string file = Path.build_filename (project_file, "configure.ac");
			bool res = false;
			
			if (GLib.FileUtils.test (file, FileTest.EXISTS)) {
				file = Path.build_filename (project_file, "Makefile.am");
				if (GLib.FileUtils.test (file, FileTest.EXISTS)) {
					res = true;
				}
			}
			
			return res;
		}

				
		public Project? open (string project_file)
		{
			Project project = new Project(project_file);
			project.backend = this;
			refresh (project);
			
			if (project.name == null)
				return null; //parse failed!
			else
				return project;
		}
		
		public void refresh (Project project)
		{
			try {
				string file = Path.build_filename (project.id, "configure.ac");
				string buffer;
				ulong length;

				if (!FileUtils.get_contents (file, out buffer, out length)) {
					return;
				}
				
				Regex reg = new GLib.Regex ("AC_INIT\\(([^\\,\\)]+)\\)");
				MatchInfo match;
				string name = null;
				string version = null;
				string url = null;
		
				if (reg.match (buffer, RegexMatchFlags.NEWLINE_ANY, out match)) {
					name = match.fetch (1);
				} else {
					reg = new GLib.Regex ("AC_INIT\\(([^\\,\\)]+),([^\\,\\)]+)\\)");
					if (reg.match (buffer, RegexMatchFlags.NEWLINE_ANY, out match)) {
						name = match.fetch (1);
						version = match.fetch (2);
					} else {
						reg = new GLib.Regex ("AC_INIT\\(([^\\,\\)]+),([^\\,\\)]+),([^\\,\\)]+)\\)");
						if (reg.match (buffer, RegexMatchFlags.NEWLINE_ANY, out match)) {
							name = match.fetch (1);
							version = match.fetch (2);
							url = match.fetch (3);
						} else {
							reg = new GLib.Regex ("AC_INIT\\(([^\\,\\)]+),([^\\,\\)]+),([^\\,\\)]+),([^\\,\\)]+)\\)");
							if (reg.match (buffer, RegexMatchFlags.NEWLINE_ANY, out match)) {
								name = match.fetch (1);
								version = match.fetch (2);
								url = match.fetch (3);
							}
						}
					}
				}
			
				project.clear ();
				project.name = normalize_string (name);
				project.version = normalize_string (version);
				project.url = normalize_string (url);
				project.working_dir = project.id;
					
				//Extract pkg-config packages
				reg = new GLib.Regex ("PKG_CHECK_MODULES\\([\\s\\[]*([^\\,\\)\\]]+)[\\s\\]]*\\,(.+?)\\)");
				if (reg.match (buffer, RegexMatchFlags.NEWLINE_CR, out match)) {
					while (match.matches ()) {
						string mod_name =  match.fetch (1);
						string pacs = "";
			
						string line = match.fetch (2);
						Regex mod = new Regex ("^[\\s\\]]*([^\\,\\]]+)[\\s\\]]*,([^\\,]+),([^\\,]+)$");
						MatchInfo pac;
						if (mod.match (line, RegexMatchFlags.NEWLINE_CR, out pac)) {
							pacs = pac.fetch (1);
						} else {
							mod = new Regex ("^[\\s\\]]*([^\\,\\]]+)[\\s\\]]*,([^\\,]+)$");
							if (mod.match (line, RegexMatchFlags.NEWLINE_CR, out pac)) {
								pacs = pac.fetch (1);
							} else {
								pacs = line;
							}
						}
						var module = new Module (project, mod_name);
						project.add_module (module);
						if (pacs != "") {
							string[] pkgs = normalize_string (pacs).split (" ");
							int idx = 0;
							while (pkgs[idx] != null) {
								string pkg = pkgs[idx];
								Package package = new Package (pkg);
								module.add_package (package);
								idx++;
								if (pkgs[idx] == ">=" ||
								    pkgs[idx] == ">" ||
	    							    pkgs[idx] == "=") {
	    							    	package.constraint = pkgs[idx];
	    								idx++;
	    								ConfigNode node;
	    								var val = pkgs[idx];
	    								if (val.has_prefix ("$")) {
	    									node = new UnresolvedConfigNode (pkgs[idx].substring (1, pkgs[idx].length -1));
	    								} else if (val != null){
	    									node = new StringLiteral (pkgs[idx]);
	    								} else {
	    									node = new StringLiteral ("");
	    								}
	    							    	package.version = node;
	    							    	idx++;
	  							}
							}
						}
						match.next ();
					}
				}
			
				parse_variables (project, buffer);
				resolve_variables (project, project.get_variables ());
				resolve_package_variables (project);
			
				//Extract AC_CONFIG_FILES
				reg = new GLib.Regex ("AC_CONFIG_FILES\\(\\[(.*)\\]\\)", RegexCompileFlags.MULTILINE);
				bool res = reg.match (buffer, RegexMatchFlags.NEWLINE_CR, out match);
				if (!res) {
					reg = new GLib.Regex ("AC_OUTPUT\\(\\[(.*)\\]\\)", RegexCompileFlags.MULTILINE);
					res = reg.match (buffer, RegexMatchFlags.NEWLINE_CR, out match);					
				}
				if (res) {
					string tmp = normalize_string (match.fetch (1));
					string[] makefiles = tmp.split(" ");
					foreach (string makefile in makefiles) {
						parse_makefile (project, project.id, makefile);
					}
				}
			
				project.setup_file_monitors ();
			} catch (Error err) {
				critical ("open: %s", err.message);
				return;
			}
		}
		
		private void add_vala_source (Group group, Target target, ConfigNode source)
		{
			string src_name;
			if (source is StringLiteral) {
				src_name = Path.build_filename (group.id, ((StringLiteral) source).data);
				var src = new Source.with_type (target, src_name, FileTypes.VALA_SOURCE);
				target.add_source (src);
			} else if (source is Variable) {
				add_vala_source (group, target, ((Variable) source).get_value ());
			} else if (source is ConfigNodeList) {
				foreach (ConfigNode item in ((ConfigNodeList) source).get_values ()) {
					if (item is StringLiteral) {
						src_name = Path.build_filename (group.id, ((StringLiteral) item).data);
						var src = new Source.with_type (target, src_name, FileTypes.VALA_SOURCE);
						target.add_source (src);
					} else if (item is Variable) {
						add_vala_source (group, target, ((Variable) item).get_value ());
					} else if (item is ConfigNodeList){
						add_vala_source (group, target, item);
					}
				}
			} else {
				warning ("add_vala_source: unsupported source type %s", Type.from_instance (source).name ());
			}
		}
		
		private void add_vala_sources (Group group, Target target)
		{
			string source_primary_name = "%s_SOURCES".printf (convert_to_primary_name (target.id));
			
			GLib.debug ("finding sources for target: %s", source_primary_name);
			
			foreach (Variable variable in group.get_variables ()) {
				if (variable.name == target.id || variable.name == source_primary_name) {
					var val = variable.get_value ();
					add_vala_source (group, target, val);
					break;
				}
			}
		}
		
		private void add_target (Group group, TargetTypes type, string target_name)
		{
			Target target;
			target = new Target (group, type, target_name);
			group.add_target (target);
			add_vala_sources (group, target);
		}
		
		private void add_targets (Group group, ConfigNode node, TargetTypes type)
		{
			if (node is StringLiteral) {
				add_target (group, type, ((StringLiteral) node).data);
			} else {
				foreach (ConfigNode item in ((ConfigNodeList) node).values) {
					if (item is StringLiteral) {
						add_target (group, type, ((StringLiteral) item).data);
					} else if (item is ConfigNodeList) {
						add_targets (group, item, type);
					}
				}
			}
		}
		
		private void add_data_files (Group group, Target target, ConfigNode file)
		{
			string name;
			if (file is StringLiteral) {
				name = Path.build_filename (group.id, ((StringLiteral) file).data);
				var f = new File.with_type (target, name, FileTypes.DATA);
				target.add_file (f);
			} else if (file is Variable) {
				add_data_files (group, target, ((Variable) file).get_value ());
			} else if (file is ConfigNodeList) {
				foreach (ConfigNode item in ((ConfigNodeList) file).get_values ()) {
					if (item is StringLiteral) {
						name = Path.build_filename (group.id, ((StringLiteral) item).data);
						var f = new File.with_type (target, name, FileTypes.DATA);
						target.add_file (f);
					} else if (item is Variable) {
						add_data_files (group, target, ((Variable) item).get_value ());
					} else if (item is ConfigNodeList){
						add_data_files (group, target, item);
					}
				}
			} else {
				warning ("add_vala_source: unsupported source type");
			}
		}
		
		private void parse_targets (Group group)
		{
			foreach (Variable variable in group.get_variables ())	{
				if (variable.name.has_suffix ("_PROGRAMS")) {
					add_targets (group, variable.get_value (), TargetTypes.PROGRAM);
				} else if (variable.name.has_suffix ("_LTLIBRARIES") || 
					   variable.name.has_suffix ("_LIBRARIES")) {
					add_targets (group, variable.get_value (), TargetTypes.LIBRARY);
				} else if (variable.name.has_suffix ("_DATA")) {
					var target = new Target (group, TargetTypes.DATA, "data");
					add_data_files (group, target, variable.get_value ());
					group.add_target (target);
				} else if (variable.name == "BUILT_SOURCES") {
					add_targets (group, variable.get_value (), TargetTypes.BUILT_SOURCES);
				}
			}
		}
		
		private void parse_variables (Project project, string buffer, Group? group = null) throws Error
		{
			string[] lines = buffer.split ("\n");
			string tmp = null;
			
			foreach (string line in lines) {
				if (tmp == null) {
					tmp = normalize_string (line);
				} else {
					tmp += " " + normalize_string (line);
				}
				
				if (tmp.has_suffix ("\\")) {
					tmp = tmp.substring (0, tmp.length - 1);
					continue; //line continuation grab the next line
				}
				
				if (tmp.has_prefix ("#") || tmp == "") {
					tmp = null;
					continue;
				}
				
				bool append = false;
				string[] toks = tmp.split ("=", 2);
				
				
				if (toks[1] == null) {
					toks = tmp.split (":", 2);
				}
				
				if (toks[1] == null) {
					tmp = null;
					continue; //unrecognized pattern
				}
				
				//check if is an append to var
				if (toks[0].has_suffix ("+")) {
					append = true;
					toks[0] = toks[0].substring (0, toks[0].length - 1);
				}
				string[] lhs = toks[0].split (" ");
				string[] rhs = toks[1].split (" ");
				
				foreach (string lh in lhs) {
					if (lh == null || lh == "")
						continue;
					
					string name = lh.strip ();
					
					var variable = new Variable(name, project);
					ConfigNode data;
				
					if (rhs[1] == null) {
						string val = rhs[0].strip ();
			
						if (val.has_prefix ("$")) {
							val = val.substring (1, val.length - 1);
							val = val.replace ("(", "").replace (")", "");
							data = new UnresolvedConfigNode (val);
						} else if (val != null){
							data = new StringLiteral (val);
						} else {
							data = new StringLiteral ("");
						}						
					} else {
						ConfigNodeList items = new ConfigNodeList ();
				
						foreach (string rh in rhs) {
							if (rh != null && rh.strip () != "") {
								ConfigNode node;
								string val = rh.strip ();
				
								if (val.has_prefix ("$")) {
									val = val.substring (1, val.length - 1);
									val = val.replace ("(", "").replace (")", "");
									node = new UnresolvedConfigNode (val);
								} else if (val != null){
									node = new StringLiteral (val);
								} else {
									critical ("%s is null", rh);
									node = new StringLiteral ("");
								}
							
								items.add_value (node);
							}
						}
						data = items;
					}
					variable.data = data;
					
					if (group != null) {
						group.add_variable (variable);
					} else {
						project.add_variable (variable);
					}
				}
				
				/*
				//this regex matches:
				//(spaces)(variable_name):(list variable names or version numbers)
				//(spaces)(variable_name)=(list variable names or version numbers)
				//(spaces)(variable_name)+=(list variable names or version numbers)
				Regex reg_var = new GLib.Regex ("^\s*([A-Za-z_$$\(]+[ A-Za-z_0-9\.$$\)\-]*)(=)([A-Za-z_0-9]*[ \.A-Za-z_0-9$$\(\)/\-:=]*)", RegexCompileFlags.OPTIMIZE);
				Regex reg_rule = new GLib.Regex ("^\s*([A-Za-z_$$\(]+[ A-Za-z_0-9\.$$\)\-]*)(:)([A-Za-z_0-9]*[ \.A-Za-z_0-9$$\(\)/\-:=]*)", RegexCompileFlags.OPTIMIZE);

				MatchInfo match;			
				tmp = normalize_string (tmp);
				tmp = tmp.replace ("= ", "="); //hack: the regular expression has a bug
				tmp = tmp.replace (" =", "=");
				
				bool res = reg_var.match (tmp, 0, out match);
				if (!res)
					res = reg_rule.match (tmp, 0, out match);
				if (res) {
					debug ("found %s, values %s", match.fetch (0), match.fetch (3));
					
					string rule_name = normalize_string (match.fetch(1));
					string[] names = rule_name.split (" ");
					string values = normalize_string (match.fetch(3));
					string[] tmps = values.split (" ");
					debug ("FOUND VARIABLE: %s %s", rule_name, values);
					
					foreach (string name in names) {
						var variable = new Variable(name, project);
						ConfigNode data;
					
						if (tmps.length == 1) {
							string val = normalize_string (tmps[0]);
				
							if (val.has_prefix ("$")) {
								val = val.substring (1, val.length - 1);
								val = val.replace ("(", "").replace (")", "");
								data = new UnresolvedConfigNode (val);
							} else if (val != null){
								data = new StringLiteral (val);
							} else {
								data = new StringLiteral ("");
							}						
						} else {
							ConfigNodeList items = new ConfigNodeList ();
					
							foreach (string tmp in tmps) {
								if (tmp != null && tmp.chomp () != "") {
									ConfigNode node;
									string val = normalize_string (tmp);
					
									if (val.has_prefix ("$")) {
										val = val.substring (1, val.length - 1);
										val = val.replace ("(", "").replace (")", "");
										node = new UnresolvedConfigNode (val);
									} else if (val != null){
										node = new StringLiteral (val);
									} else {
										critical ("%s is null", tmp);
										node = new StringLiteral ("");
									}
								
									items.add_value (node);
								}
							}
							data = items;
						}
						variable.data = data;
						if (variable.name == "BUILT_SOURCES") {
							debug ("BS: VALUES %s", variable.data.to_string ());
						}
						if (group != null) {
							group.add_variable (variable);
						} else {
							project.add_variable (variable);
						}
					}
				}
				*/
				tmp = null; //restart from a new line
			}		
		}
		
		private Variable? resolve_variable (string variable_name, Gee.List<Variable> variables)
		{
			Variable variable = null;
			foreach (Variable item in variables) {
				if (variable_name == item.name) {
					variable = item;
					break;
				}
			}
			
			return variable;
		}
		
		private void resolve_package_variables (Project project)
		{
			//resolve package version variables
			var variables = project.get_variables ();
			
			foreach (Module module in project.get_modules ()) {
				foreach (Package package in module.get_packages ()) {
					if (package.version is UnresolvedConfigNode) {
						var name = ((UnresolvedConfigNode) package.version).name;
						var target_variable = resolve_variable (name, variables);
						if (target_variable != null) {
							package.version = target_variable.data;
						}
					}
				}
			}
		}
		private void resolve_variables (Project project, Gee.List<Variable> variables)
		{
			Variable target_variable;
			string name;
			
			//resolve variables
			foreach (Variable variable in variables) {
				if (variable.data is UnresolvedConfigNode) {
					name = ((UnresolvedConfigNode) variable.data).name;
					target_variable = resolve_variable (name, variables);
					if (target_variable == null)
						target_variable = resolve_variable (name, project.get_variables ());
						
					if (target_variable != null) {
						variable.data = target_variable;
						variable.parent = target_variable;
						target_variable.add_child (variable);
					}
				} else if (variable.data is ConfigNodeList) {
					ConfigNodeList datas = ((ConfigNodeList)variable.data);
					Gee.List<ConfigNodePair> resolved_nodes = new Gee.ArrayList<ConfigNodePair> ();
					
					foreach (ConfigNode data in datas.get_values ()) {
						if (data is UnresolvedConfigNode) {
							name = ((UnresolvedConfigNode) data).name;
							target_variable = resolve_variable (name, variables);
							if (target_variable == null)
								target_variable = resolve_variable (name, project.get_variables ());

							if (target_variable != null) {
								if (target_variable.data != null) {
									var child = new Variable (name, target_variable);
									child.data = target_variable;
									target_variable.add_child (child);
									resolved_nodes.add (new ConfigNodePair (data, child));
								} else {
									resolved_nodes.add (new ConfigNodePair (data, null));
								}
							}
						}
					}
					
					//modify the references
					foreach (ConfigNodePair resolved_node in resolved_nodes) {
						datas.replace_config_node (resolved_node.source, resolved_node.destination);
					}
				}
			}
		}
		
		private string process_include_directives (string makefile, string buffer) throws Error
		{
			string res = buffer;
			string[] lines = buffer.split ("\n");
			foreach (string line in lines) {
				if (line == "")
					continue;
				line = normalize_string (line);
				string[] tmps = line.split (" ", 2);
								
				if (tmps[0] == "include") {
					string filename = normalize_string (tmps[1]);
					string include_filename = makefile.replace ("Makefile.am", filename);
					string included_file;
					if (FileUtils.get_contents (include_filename, out included_file)) {
						res = res.replace ("include %s".printf(filename), included_file);
					}
				}
			}
			return res;
		}
		
		private void parse_makefile (Project project, string project_file, string makefile) throws Error
		{
			if (!makefile.has_suffix ("Makefile"))
				return;
				
			string buffer;
			string file = Path.build_filename (project_file, makefile) + ".am";
			
			if (FileUtils.get_contents (file, out buffer)) {
				var group = new Group (project, file.replace ("Makefile.am", ""));
				project.add_group (group);
				buffer = process_include_directives (file, buffer);
				parse_variables (project, buffer, group);
				resolve_variables (project, group.get_variables ());
				parse_targets (group);
				parse_group_extended_info (group, buffer);
			}
		}
		
		private void parse_group_extended_info (Group group, string buffer)
		{
			string[] lines = buffer.split ("\n");
			Target? target = null;
			
			foreach (string line in lines) {
				line = normalize_string (line);
				if (line == "")
				{
					if (target != null) {
						target = null;
					}
					continue; //skip this line
				}
				//try extract the the rule target name
				if (target == null) {
					string[] rule_parts = line.split (":", 2);
					if (rule_parts.length == 2) {
						string[] trgs = rule_parts[0].split (" ");
						//TODO: add support for multitarget rules if required
						foreach (string trg in trgs) {
							target = group.get_target_for_id (trg);
							if (target != null) {
								break;
							}
						}
					}
				}

				string[] tmps = line.split (" ");
				int count = tmps.length;
			
				for(int idx=0; idx < count; idx++) {
					if (tmps[idx] == "--vapidir" && (idx + 1) < count) {
						var tmp = tmps[idx+1];
						if (tmp.has_prefix (".")) {
							tmp = Path.build_filename (group.project.id, group.name, tmp);
						}
						if (target != null) {
							target.add_include_dir (tmp);
						} else {
							group.add_include_dir (tmp);
						}
						idx++;
					} else if (tmps[idx] == "--pkg" && (idx + 1) < count) {
						var tmp = tmps[idx+1];
						if (target != null) {
							target.add_package (new Package (tmp));
						} else {
							group.add_package (new Package (tmp));
						}
						idx++;
					} else if (tmps[idx] == "--library") {
						var tmp = tmps[idx+1];
						if (target != null) {
							target.add_built_library (tmp);
						} else {
							group.add_built_library (tmp);
						}
						idx++;
					}
				}
			}
		}
		
		private string? normalize_string (string? data)
		{
			if (data == null) {
				return null;
			}
			string res = data.replace ("\n", " ");
			res = res.replace ("\t", " ");
			string old = null;
			while (old != res) {
				old = res;
				res = res.replace ("  ", " ");
			}
			res = res.strip ();
			
			if (res.has_prefix ("[")) {
				res = res.substring (1, res.length - 1);
			}
			if (res.has_suffix ("]")) {
				res = res.substring (0, res.length - 1);
			}
			return res;
		}
		
		private string convert_to_primary_name (string data)
		{
			return data.replace (".", "_").replace ("-", "_");
		}
	}
}
