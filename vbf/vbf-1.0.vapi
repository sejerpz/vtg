/* vbf-1.0.vapi generated by valac, do not modify. */

[CCode (cprefix = "Vbf", lower_case_cprefix = "vbf_")]
namespace Vbf {
	[CCode (cprefix = "VbfAm", lower_case_cprefix = "vbf_am_")]
	namespace Am {
		[CCode (cheader_filename = "vbf.h")]
		public class ProjectManager : Vbf.IProjectManager, GLib.Object {
			public ProjectManager ();
		}
	}
	[CCode (cheader_filename = "vbf.h")]
	public abstract class ConfigNode : GLib.Object {
		public weak Vbf.ConfigNode parent;
		public ConfigNode ();
		public abstract string to_string ();
	}
	[CCode (cheader_filename = "vbf.h")]
	public class ConfigNodeList : Vbf.ConfigNode {
		protected Vala.List<Vbf.ConfigNode> values;
		public ConfigNodeList ();
		public void add_value (Vbf.ConfigNode val);
		public Vala.List<Vbf.ConfigNode> get_values ();
		public void replace_config_node (Vbf.ConfigNode source, Vbf.ConfigNode target);
		public override string to_string ();
	}
	[CCode (cheader_filename = "vbf.h")]
	public class ConfigNodePair : GLib.Object {
		public Vbf.ConfigNode? destination;
		public Vbf.ConfigNode source;
		public ConfigNodePair (Vbf.ConfigNode source, Vbf.ConfigNode? destination);
	}
	[CCode (cheader_filename = "vbf.h")]
	public class File : GLib.Object {
		public string filename;
		public string name;
		public weak Vbf.Target target;
		public Vbf.FileTypes type;
		public string uri;
		public File (Vbf.Target target, string filename);
		public File.with_type (Vbf.Target target, string filename, Vbf.FileTypes type);
	}
	[CCode (cheader_filename = "vbf.h")]
	public class Group : GLib.Object {
		public string id;
		public string name;
		public weak Vbf.Project project;
		public Group (Vbf.Project project, string id);
		public void add_target (Vbf.Target target);
		public bool contains_target (string id);
		public Vala.List<string> get_built_libraries ();
		public Vala.List<string> get_include_dirs ();
		public Vala.List<Vbf.Package> get_packages ();
		public Vala.List<Vbf.Group> get_subgroups ();
		public Vbf.Target? get_target_for_id (string id);
		public Vala.List<Vbf.Target> get_targets ();
		public Vala.List<Vbf.Variable> get_variables ();
		public bool has_sources_of_type (Vbf.FileTypes type);
	}
	[CCode (cheader_filename = "vbf.h")]
	public class Module : GLib.Object {
		public string id;
		public string name;
		public weak Vbf.Project project;
		public Module (Vbf.Project project, string id);
		public Vala.List<Vbf.Package> get_packages ();
	}
	[CCode (cheader_filename = "vbf.h")]
	public class Package : GLib.Object {
		public string constraint;
		public string id;
		public string name;
		public Vbf.ConfigNode version;
		public Package (string id);
	}
	[CCode (cheader_filename = "vbf.h")]
	public class Project : Vbf.ConfigNode {
		public string id;
		public string name;
		public string url;
		public string version;
		public string working_dir;
		public Project (string id);
		public void add_group (Vbf.Group group);
		public string get_all_source_files ();
		public Vbf.Group? get_group (string id);
		public Vala.List<Vbf.Group> get_groups ();
		public Vala.List<Vbf.Module> get_modules ();
		public Vala.List<Vbf.Variable> get_variables ();
		public override string to_string ();
		public void update ();
		public signal void updated ();
	}
	[CCode (cheader_filename = "vbf.h")]
	public class Source : Vbf.File {
		public Source (Vbf.Target target, string filename);
		public Source.with_type (Vbf.Target target, string filename, Vbf.FileTypes type);
	}
	[CCode (cheader_filename = "vbf.h")]
	public class StringLiteral : Vbf.ConfigNode {
		public string data;
		public StringLiteral (string data);
		public override string to_string ();
	}
	[CCode (cheader_filename = "vbf.h")]
	public class Target : GLib.Object {
		public weak Vbf.Group group;
		public string id;
		public string name;
		public bool no_install;
		public Vbf.TargetTypes type;
		public Target (Vbf.Group group, Vbf.TargetTypes type, string id);
		public void add_source (Vbf.Source source);
		public Vala.List<string> get_built_libraries ();
		public Vala.List<Vbf.File> get_files ();
		public Vala.List<string> get_include_dirs ();
		public Vala.List<Vbf.Package> get_packages ();
		public Vbf.Source? get_source (string filename);
		public Vala.List<Vbf.Source> get_sources ();
		public bool has_file_of_type (Vbf.FileTypes type);
		public bool has_sources_of_type (Vbf.FileTypes type);
		public void remove_source (Vbf.Source source);
	}
	[CCode (cheader_filename = "vbf.h")]
	public class UnresolvedConfigNode : Vbf.ConfigNode {
		public string name;
		public UnresolvedConfigNode (string name);
		public override string to_string ();
	}
	[CCode (cheader_filename = "vbf.h")]
	public class Variable : Vbf.ConfigNode {
		public Vbf.ConfigNode? data;
		public string name;
		public Variable (string name, Vbf.ConfigNode parent);
		public void add_child (Vbf.Variable variable);
		public Vala.List<Vbf.Variable> get_childs ();
		public Vbf.ConfigNode get_value ();
		public override string to_string ();
	}
	[CCode (cheader_filename = "vbf.h")]
	public interface IProjectManager : GLib.Object {
		public abstract Vbf.Project? open (string project_file);
		public abstract bool probe (string project_file);
		public abstract void refresh (Vbf.Project project);
	}
	[CCode (cprefix = "VBF_FILE_TYPES_", cheader_filename = "vbf.h")]
	public enum FileTypes {
		UNKNOWN,
		DATA,
		VALA_SOURCE,
		OTHER_SOURCE
	}
	[CCode (cprefix = "VBF_TARGET_TYPES_", cheader_filename = "vbf.h")]
	public enum TargetTypes {
		PROGRAM,
		LIBRARY,
		DATA,
		BUILT_SOURCES
	}
}
