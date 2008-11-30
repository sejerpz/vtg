/* gtksourcecompletion-1.0.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Gsc", lower_case_cprefix = "gsc_")]
namespace Gsc {
	[CCode (cheader_filename = "gtksourcecompletion/gsc-documentwords-provider.h")]
	public class DocumentwordsProvider : GLib.Object, Gsc.Provider {
		public Gsc.DocumentwordsProviderSortType get_sort_type ();
		[CCode (has_construct_function = false)]
		public DocumentwordsProvider (Gtk.TextView view);
		public void set_sort_type (Gsc.DocumentwordsProviderSortType sort_type);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public class Info : Gtk.Window, Gtk.Buildable, Atk.Implementor {
		public void move_to_cursor (Gtk.TextView view);
		[CCode (has_construct_function = false)]
		public Info ();
		public void set_adjust_height (bool adjust, int max_height);
		public void set_adjust_width (bool adjust, int max_width);
		public void set_info_type (Gsc.InfoType type);
		public void set_markup (string markup);
		public virtual signal void info_type_changed (int p0);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-manager.h")]
	public class Manager : GLib.Object {
		public void activate ();
		public void deactivate ();
		public void finish_completion ();
		public weak Gsc.Trigger get_active_trigger ();
		public void get_current_event_options (out Gsc.ManagerEventOptions options);
		public static weak Gsc.Manager get_from_view (Gtk.TextView view);
		public weak Gsc.Provider get_provider (string provider_name);
		public weak Gsc.Trigger get_trigger (string trigger_name);
		public weak Gtk.TextView get_view ();
		public bool is_visible ();
		[CCode (has_construct_function = false)]
		public Manager (Gtk.TextView view);
		public bool register_provider (Gsc.Provider provider, string trigger_name);
		public void register_trigger (Gsc.Trigger trigger);
		public void set_current_info (string info);
		public void trigger_event (string trigger_name, void* event_data);
		public void trigger_event_with_opts (string trigger_name, Gsc.ManagerEventOptions options, void* event_data);
		public bool unregister_provider (Gsc.Provider provider, string trigger_name);
		public void unregister_trigger (Gsc.Trigger trigger);
		public void update_event_options (Gsc.ManagerEventOptions options);
		[NoAccessorMethod]
		public string info_keys { get; set; }
		[NoAccessorMethod]
		public string next_page_keys { get; set; }
		[NoAccessorMethod]
		public string previous_page_keys { get; set; }
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-popup.h")]
	public class Popup : Gtk.Window, Gtk.Buildable, Atk.Implementor {
		public void add_data (Gsc.Proposal data);
		public bool bottom_bar_get_visible ();
		public void bottom_bar_set_visible (bool visible);
		public void clear ();
		public weak string get_filter_text ();
		public Gsc.PopupFilterType get_filter_type ();
		public weak Gtk.Widget get_filter_widget ();
		public weak string get_key (Gsc.KeysType type);
		public int get_num_active_pages ();
		public bool get_selected_proposal (out weak Gsc.Proposal proposal);
		public bool has_proposals ();
		public bool manage_key (Gdk.EventKey event);
		[CCode (type = "GtkWidget*", has_construct_function = false)]
		public Popup ();
		public void page_next ();
		public void page_previous ();
		public bool select_first ();
		public bool select_last ();
		public bool select_next (int rows);
		public bool select_previous (int rows);
		public void set_current_info (string info);
		public void set_filter_text (string text);
		public void set_filter_type (Gsc.PopupFilterType filter_type);
		public void set_key (Gsc.KeysType type, string keys);
		public static void show_or_update (Gtk.Widget widget);
		public void toggle_proposal_info ();
		public virtual signal void display_info (void* p0);
		public virtual signal void proposal_selected (void* proposal);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-proposal.h")]
	public class Proposal : GLib.Object {
		public weak Gdk.Pixbuf get_icon ();
		public virtual weak string get_info ();
		public weak string get_label ();
		public weak string get_page_name ();
		[CCode (has_construct_function = false)]
		public Proposal (string label, string info, Gdk.Pixbuf icon);
		public void set_page_name (string page_name);
		[NoAccessorMethod]
		public void* icon { get; set; }
		[NoAccessorMethod]
		public string info { get; set; }
		[NoAccessorMethod]
		public string label { get; set; }
		[HasEmitter]
		public virtual signal bool apply (void* view);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public class ProviderFile : GLib.Object, Gsc.Provider {
		[CCode (has_construct_function = false)]
		public ProviderFile (Gtk.TextView view);
		public void set_file (string file);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-tree.h")]
	public class Tree : Gtk.ScrolledWindow, Gtk.Buildable, Atk.Implementor {
		public void add_data (Gsc.Proposal data);
		public void clear ();
		public void filter (string filter);
		public int get_num_proposals ();
		public bool get_selected_proposal (out weak Gsc.Proposal proposal);
		[CCode (type = "GtkWidget*", has_construct_function = false)]
		public Tree ();
		public bool select_first ();
		public bool select_last ();
		public bool select_next (int rows);
		public bool select_previous (int rows);
		public virtual signal void proposal_selected (void* proposal);
		public virtual signal void selection_changed (void* proposal);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-trigger-autowords.h")]
	public class TriggerAutowords : GLib.Object, Gsc.Trigger {
		[CCode (has_construct_function = false)]
		public TriggerAutowords (Gsc.Manager completion);
		public void set_delay (uint delay);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-trigger-customkey.h")]
	public class TriggerCustomkey : GLib.Object, Gsc.Trigger {
		[CCode (has_construct_function = false)]
		public TriggerCustomkey (Gsc.Manager completion, string trigger_name, string keys);
		public void set_keys (string keys);
		public void set_opts (Gsc.ManagerEventOptions options);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-provider.h")]
	public interface Provider {
		public abstract void finish ();
		public abstract weak string get_name ();
		public abstract GLib.List<Gsc.Proposal> get_proposals (Gsc.Trigger trigger);
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-trigger.h")]
	public interface Trigger {
		public abstract bool activate ();
		public abstract bool deactivate ();
		public abstract weak string get_name ();
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public struct ManagerEventOptions {
		public Gsc.PopupPositionType position_type;
		public Gsc.PopupFilterType filter_type;
		public weak string filter_text;
		public bool autoselect;
		public bool show_bottom_bar;
	}
	[CCode (cprefix = "GSC_DOCUMENTWORDS_PROVIDER_SORT_", has_type_id = "0", cheader_filename = "gtksourcecompletion/gsc-documentwords-provider.h")]
	public enum DocumentwordsProviderSortType {
		NONE,
		BY_LENGTH
	}
	[CCode (cprefix = "GSC_INFO_VIEW_", has_type_id = "0", cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public enum InfoType {
		SORT,
		EXTENDED
	}
	[CCode (cprefix = "KEYS_", has_type_id = "0", cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public enum KeysType {
		INFO,
		PAGE_NEXT,
		PAGE_PREV,
		LAST
	}
	[CCode (cprefix = "GSC_POPUP_FILTER_", has_type_id = "0", cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public enum PopupFilterType {
		NONE,
		TREE,
		TREE_HIDDEN
	}
	[CCode (cprefix = "GSC_POPUP_POSITION_", has_type_id = "0", cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public enum PopupPositionType {
		CURSOR,
		CENTER_SCREEN,
		CENTER_PARENT
	}
	[CCode (cheader_filename = "gtksourcecompletion/gsc-popup.h")]
	public const string DEFAULT_PAGE;
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public const string DOCUMENTWORDS_PROVIDER_NAME;
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public const string PROPOSAL_DEFAULT_PAGE;
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public const int PROPOSAL_DEFAULT_PRIORITY;
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public const string PROVIDER_FILE_NAME;
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public const string TRIGGER_AUTOWORDS_NAME;
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public const string USER_REQUEST_TRIGGER_NAME;
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static bool char_is_separator (unichar ch);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static weak string clear_word (string word);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static bool compare_keys (uint key, uint mods, Gdk.EventKey event);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static weak string compute_line_indentation (Gtk.TextView view, Gtk.TextIter cur);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static void get_cursor_pos (Gtk.TextView text_view, int x, int y);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static weak string get_last_word (Gtk.TextView text_view);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static weak string get_last_word_and_iter (Gtk.TextView text_view, Gtk.TextIter start_word, Gtk.TextIter end_word);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static weak string get_last_word_cleaned (Gtk.TextView text_view);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static weak string get_text_with_indent (string content, string indent);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static void get_window_position_center_parent (Gtk.Window window, Gtk.Widget parent, int x, int y);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static void get_window_position_center_screen (Gtk.Window window, int x, int y);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static bool get_window_position_in_cursor (Gtk.Window window, Gtk.TextView view, int x, int y);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static weak string gsv_get_text (Gtk.TextView text_view);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static void insert_text_with_indent (Gtk.TextView view, string text);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static bool is_valid_word (string current_word, string completion_word);
	[CCode (cheader_filename = "gtksourcecompletion/gsc-utils.h")]
	public static void replace_actual_word (Gtk.TextView text_view, string text);
}
