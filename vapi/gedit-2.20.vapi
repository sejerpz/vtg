/* gedit-2.20.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Gedit", lower_case_cprefix = "gedit_")]
namespace Gedit {
	[CCode (cprefix = "GEDIT_CONVERT_ERROR_AUTO_DETECTION_", has_type_id = "0", cheader_filename = "gedit/gedit-convert.h")]
	public enum ConvertError {
		FAILED
	}
	[CCode (cprefix = "GEDIT_", has_type_id = "0", cheader_filename = "gedit/gedit-debug.h")]
	public enum DebugSection {
		NO_DEBUG,
		DEBUG_VIEW,
		DEBUG_SEARCH,
		DEBUG_PRINT,
		DEBUG_PREFS,
		DEBUG_PLUGINS,
		DEBUG_TAB,
		DEBUG_DOCUMENT,
		DEBUG_COMMANDS,
		DEBUG_APP,
		DEBUG_SESSION,
		DEBUG_UTILS,
		DEBUG_METADATA,
		DEBUG_WINDOW,
		DEBUG_LOADER,
		DEBUG_SAVER
	}
	[CCode (cprefix = "GEDIT_DOCUMENT_SAVE_", has_type_id = "0", cheader_filename = "gedit/gedit-document.h")]
	public enum DocumentSaveFlags {
		IGNORE_MTIME,
		IGNORE_BACKUP,
		PRESERVE_BACKUP
	}
	[CCode (cprefix = "GEDIT_LOCKDOWN_", has_type_id = "0", cheader_filename = "gedit/gedit-app.h")]
	public enum LockdownMask {
		COMMAND_LINE,
		PRINTING,
		PRINT_SETUP,
		SAVE_TO_DISK,
		ALL
	}
	[CCode (cprefix = "GEDIT_SEARCH_", has_type_id = "0", cheader_filename = "gedit/gedit-document.h")]
	public enum SearchFlags {
		DONT_SET_FLAGS,
		ENTIRE_WORD,
		CASE_SENSITIVE
	}
	[CCode (cprefix = "GEDIT_TAB_", has_type_id = "0", cheader_filename = "gedit/gedit-tab.h")]
	public enum TabState {
		STATE_NORMAL,
		STATE_LOADING,
		STATE_REVERTING,
		STATE_SAVING,
		STATE_PRINTING,
		STATE_PRINT_PREVIEWING,
		STATE_SHOWING_PRINT_PREVIEW,
		STATE_GENERIC_NOT_EDITABLE,
		STATE_LOADING_ERROR,
		STATE_REVERTING_ERROR,
		STATE_SAVING_ERROR,
		STATE_GENERIC_ERROR,
		STATE_CLOSING,
		STATE_EXTERNALLY_MODIFIED_NOTIFICATION,
		NUM_OF_STATES
	}
	[CCode (cprefix = "GEDIT_TOOLBAR_", has_type_id = "0", cheader_filename = "gedit/gedit-prefs-manager.h")]
	public enum ToolbarSetting {
		SYSTEM,
		ICONS,
		ICONS_AND_TEXT,
		ICONS_BOTH_HORIZ
	}
	[CCode (cprefix = "GEDIT_WINDOW_STATE_", has_type_id = "0", cheader_filename = "gedit/gedit-window.h")]
	public enum WindowState {
		NORMAL,
		SAVING,
		PRINTING,
		LOADING,
		ERROR,
		SAVING_SESSION
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-app.h")]
	public class App : GLib.Object {
		public weak Gedit.Window create_window (Gdk.Screen screen);
		public weak Gedit.Window get_active_window ();
		public static weak Gedit.App get_default ();
		public weak GLib.List<Gedit.Document> get_documents ();
		public Gedit.LockdownMask get_lockdown ();
		public weak GLib.List<Gedit.View> get_views ();
		public weak GLib.List<Gedit.Window> get_windows ();
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-document.h")]
	public class Document : Gtk.SourceBuffer {
		public static GLib.Quark error_quark ();
		public bool get_can_search_again ();
		public bool get_deleted ();
		public bool get_enable_search_highlighting ();
		public weak Gedit.Encoding get_encoding ();
		public weak Gtk.SourceLanguage get_language ();
		public weak string get_mime_type ();
		public bool get_readonly ();
		public weak string get_search_text (uint flags);
		public weak string get_short_name_for_display ();
		public weak string get_uri ();
		public weak string get_uri_for_display ();
		public bool goto_line (int line);
		public bool insert_file (Gtk.TextIter iter, string uri, Gedit.Encoding encoding);
		public bool is_local ();
		public bool is_untitled ();
		public bool is_untouched ();
		public void load (string uri, Gedit.Encoding encoding, int line_pos, bool create);
		public bool load_cancel ();
		public Document ();
		public int replace_all (string find, string replace, uint flags);
		public void save (Gedit.DocumentSaveFlags flags);
		public void save_as (string uri, Gedit.Encoding encoding, Gedit.DocumentSaveFlags flags);
		public bool search_backward (Gtk.TextIter start, Gtk.TextIter end, Gtk.TextIter match_start, Gtk.TextIter match_end);
		public bool search_forward (Gtk.TextIter start, Gtk.TextIter end, Gtk.TextIter match_start, Gtk.TextIter match_end);
		public void set_enable_search_highlighting (bool enable);
		public void set_language (Gtk.SourceLanguage lang);
		public void set_search_text (string text, uint flags);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-encodings.h")]
	public class Encoding : GLib.Object {
		public weak Gedit.Encoding copy ();
		public weak string get_charset ();
		public static weak Gedit.Encoding get_current ();
		public static weak Gedit.Encoding get_from_charset (string charset);
		public static weak Gedit.Encoding get_from_index (int index);
		public weak string get_name ();
		public static weak Gedit.Encoding get_utf8 ();
		public weak string to_string ();
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-encodings-option-menu.h")]
	public class EncodingsOptionMenu : GLib.Object {
		public weak Gedit.Encoding get_selected_encoding ();
		[CCode (type = "GtkWidget*")]
		public EncodingsOptionMenu (bool save_mode);
		public void set_selected_encoding (Gedit.Encoding encoding);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-file-chooser-dialog.h")]
	public class FileChooserDialog : Gtk.FileChooserDialog {
		public weak Gedit.Encoding get_encoding ();
		[CCode (type = "GtkWidget*")]
		public FileChooserDialog (string title, Gtk.FileChooserAction action, Gedit.Encoding encoding, ...);
		public void set_encoding (Gedit.Encoding encoding);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-message-area.h")]
	public class MessageArea : Gtk.HBox {
		public void add_action_widget (Gtk.Widget child, int response_id);
		public weak Gtk.Widget add_button (string button_text, int response_id);
		public void add_buttons (...);
		public weak Gtk.Widget add_stock_button_with_text (string text, string stock_id, int response_id);
		[CCode (type = "GtkWidget*")]
		public MessageArea ();
		[CCode (type = "GtkWidget*")]
		public MessageArea.with_buttons (...);
		public void response (int response_id);
		public void set_contents (Gtk.Widget contents);
		public void set_default_response (int response_id);
		public void set_response_sensitive (int response_id, bool setting);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-notebook.h")]
	public class Notebook : Gtk.Notebook {
		public void add_tab (Gedit.Tab tab, int position, bool jump_to);
		public bool get_close_buttons_sensitive ();
		public bool get_tab_drag_and_drop_enabled ();
		public void move_tab (Gedit.Notebook dest, Gedit.Tab tab, int dest_position);
		[CCode (type = "GtkWidget*")]
		public Notebook ();
		public void remove_all_tabs ();
		public void remove_tab (Gedit.Tab tab);
		public void reorder_tab (Gedit.Tab tab, int dest_position);
		public void set_always_show_tabs (bool show_tabs);
		public void set_close_buttons_sensitive (bool sensitive);
		public void set_tab_drag_and_drop_enabled (bool enable);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-panel.h")]
	public class Panel : Gtk.VBox {
		public bool activate_item (Gtk.Widget item);
		public void add_item (Gtk.Widget item, string name, Gtk.Widget? image);
		public void add_item_with_stock_icon (Gtk.Widget item, string name, string stock_id);
		public int get_n_items ();
		public Gtk.Orientation get_orientation ();
		public bool item_is_active (Gtk.Widget item);
		[CCode (type = "GtkWidget*")]
		public Panel (Gtk.Orientation orientation);
		public bool remove_item (Gtk.Widget item);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-plugin.h")]
	public class Plugin : GLib.Object {
		public virtual void activate (Gedit.Window window);
		public virtual weak Gtk.Widget? create_configure_dialog ();
		public virtual void deactivate (Gedit.Window window);
		public virtual bool is_configurable ();
		public virtual void update_ui (Gedit.Window window);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-progress-message-area.h")]
	public class ProgressMessageArea : Gedit.MessageArea {
		[CCode (type = "GtkWidget*")]
		public ProgressMessageArea (string stock_id, string markup, bool has_cancel);
		public void pulse ();
		public void set_fraction (double fraction);
		public void set_markup (string markup);
		public void set_stock_image (string stock_id);
		public void set_text (string text);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-statusbar.h")]
	public class Statusbar : Gtk.Statusbar {
		public void clear_overwrite ();
		public void flash_message (uint context_id, string format);
		[CCode (type = "GtkWidget*")]
		public Statusbar ();
		public void set_cursor_position (int line, int col);
		public void set_overwrite (bool overwrite);
		public void set_window_state (Gedit.WindowState state, int num_of_errors);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-tab.h")]
	public class Tab : Gtk.VBox {
		public weak Gtk.VBox vbox;
		public bool get_auto_save_enabled ();
		public int get_auto_save_interval ();
		public weak Gedit.Document get_document ();
		public static weak Gedit.Tab get_from_document (Gedit.Document doc);
		public Gedit.TabState get_state ();
		public weak Gedit.View get_view ();
		public void set_auto_save_enabled (bool enable);
		public void set_auto_save_interval (int interval);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-view.h")]
	public class View : Gtk.SourceView {
		public void copy_clipboard ();
		public void cut_clipboard ();
		public void delete_selection ();
		[CCode (type = "GtkWidget*")]
		public View (Gedit.Document doc);
		public void paste_clipboard ();
		public void scroll_to_cursor ();
		public void select_all ();
		public void set_font (bool def, string font_name);
	}
	[CCode (param_spec_function = "g_param_spec_object", cheader_filename = "gedit/gedit-window.h")]
	public class Window : Gtk.Window {
		public void close_all_tabs ();
		public void close_tab (Gedit.Tab tab);
		public void close_tabs (GLib.List<Gedit.Tab> tabs);
		public weak Gedit.Tab create_tab (bool jump_to);
		public weak Gedit.Tab create_tab_from_uri (string uri, Gedit.Encoding encoding, int line_pos, bool create, bool jump_to);
		public weak Gedit.Document get_active_document ();
		public weak Gedit.Tab get_active_tab ();
		public weak Gedit.View get_active_view ();
		public weak Gedit.Panel get_bottom_panel ();
		public weak GLib.List<Gedit.Document> get_documents ();
		public weak Gtk.WindowGroup get_group ();
		public weak Gedit.Panel get_side_panel ();
		public Gedit.WindowState get_state ();
		public weak Gtk.Widget get_statusbar ();
		public weak Gedit.Tab get_tab_from_uri (string uri);
		public weak Gtk.UIManager get_ui_manager ();
		public weak GLib.List<Gedit.Document> get_unsaved_documents ();
		public weak GLib.List<Gedit.View> get_views ();
		public void set_active_tab (Gedit.Tab tab);
	}
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const string BASE_KEY;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_AUTO_INDENT;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_AUTO_SAVE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_AUTO_SAVE_INTERVAL;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_BOTTOM_PANEL_VISIBLE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_BRACKET_MATCHING;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_CREATE_BACKUP_COPY;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_DISPLAY_LINE_NUMBERS;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_DISPLAY_RIGHT_MARGIN;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_HIGHLIGHT_CURRENT_LINE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_INSERT_SPACES;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_MAX_RECENTS;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_PRINT_HEADER;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_PRINT_LINE_NUMBERS;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_PRINT_SYNTAX;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const string GPM_DEFAULT_PRINT_WRAP_MODE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_RESTORE_CURSOR_POSITION;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_RIGHT_MARGIN_POSITION;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_SEARCH_HIGHLIGHTING_ENABLE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_SIDE_PANE_VISIBLE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const string GPM_DEFAULT_SMART_HOME_END;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const string GPM_DEFAULT_SOURCE_STYLE_SCHEME;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_STATUSBAR_VISIBLE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_SYNTAX_HL_ENABLE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_TABS_SIZE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const string GPM_DEFAULT_TOOLBAR_BUTTONS_STYLE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_TOOLBAR_SHOW_TOOLTIPS;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_TOOLBAR_VISIBLE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_UNDO_ACTIONS_LIMIT;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const int GPM_DEFAULT_USE_DEFAULT_FONT;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const string GPM_DEFAULT_WRAP_MODE;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const string GPM_LOCKDOWN_DIR;
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public const string GPM_SYSTEM_FONT;
	[CCode (cheader_filename = "gedit/gedit-convert.h")]
	public static GLib.Quark convert_error_quark ();
	[CCode (cheader_filename = "gedit/gedit-convert.h")]
	public static weak string convert_from_utf8 (string content, ulong len, Gedit.Encoding encoding, ulong new_len) throws GLib.Error;
	[CCode (cheader_filename = "gedit/gedit-convert.h")]
	public static weak string convert_to_utf8 (string content, ulong len, out weak Gedit.Encoding encoding, ulong new_len) throws GLib.Error;
	[CCode (cheader_filename = "gedit/gedit-debug.h")]
	public static void debug (Gedit.DebugSection section, string file, int line, string function);
	[CCode (cheader_filename = "gedit/gedit-debug.h")]
	public static void debug_init ();
	[CCode (cheader_filename = "gedit/gedit-debug.h")]
	public static void debug_message (Gedit.DebugSection section, string file, int line, string function, string format, ...);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak Gtk.Widget dialog_add_button (Gtk.Dialog dialog, string text, string stock_id, int response_id);
	[CCode (cname = "g_utf8_caselessnmatch", cheader_filename = "gedit/gedit-utils.h")]
	public static bool g_utf8_caselessnmatch (string s1, string s2, long n1, long n2);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string gdk_color_to_string (Gdk.Color color);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak Gtk.Widget gtk_button_new_with_stock_icon (string label, string stock_id);
	[CCode (cheader_filename = "gedit/gedit-help.h")]
	public static bool help_display (string file_name, string link_id);
	[CCode (cheader_filename = "gedit/gedit-metadata-manager.h")]
	public static weak string metadata_manager_get (string uri, string key);
	[CCode (cheader_filename = "gedit/gedit-metadata-manager.h")]
	public static void metadata_manager_set (string uri, string key, string value);
	[CCode (cheader_filename = "gedit/gedit-metadata-manager.h")]
	public static void metadata_manager_shutdown ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_active_file_filter_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_app_init ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_app_shutdown ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_auto_indent_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_auto_save_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_auto_save_interval_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_bottom_panel_active_page_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_bottom_panel_size_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_bottom_panel_visible_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_bracket_matching_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_create_backup_copy_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_display_line_numbers_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_display_right_margin_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_editor_font_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_enable_search_highlighting_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_enable_syntax_highlighting_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_active_file_filter ();
	[CCode (cheader_filename = "gedit-2.20.h")]
	public static weak GLib.SList<Gedit.Encoding> prefs_manager_get_auto_detected_encodings ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_auto_indent ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_auto_save ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_auto_save_interval ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_backup_extension ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_bottom_panel_active_page ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_bottom_panel_size ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_bottom_panel_visible ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_bracket_matching ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_create_backup_copy ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_default_bottom_panel_size ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_default_print_font_body ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_default_print_font_header ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_default_print_font_numbers ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_default_side_panel_size ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_get_default_window_size (int width, int height);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_display_line_numbers ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_display_right_margin ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_editor_font ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_enable_search_highlighting ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_enable_syntax_highlighting ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_highlight_current_line ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_insert_spaces ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static Gedit.LockdownMask prefs_manager_get_lockdown ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_max_recents ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_print_font_body ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_print_font_header ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_print_font_numbers ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_print_header ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_print_line_numbers ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_print_syntax_hl ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static Gtk.WrapMode prefs_manager_get_print_wrap_mode ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_restore_cursor_position ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_right_margin_position ();
	[CCode (cheader_filename = "gedit-2.20.h")]
	public static weak GLib.SList<Gedit.Encoding> prefs_manager_get_shown_in_menu_encodings ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_side_pane_visible ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_side_panel_active_page ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_side_panel_size ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static Gtk.SourceSmartHomeEndType prefs_manager_get_smart_home_end ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_source_style_scheme ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_statusbar_visible ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static weak string prefs_manager_get_system_font ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_tabs_size ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static Gedit.ToolbarSetting prefs_manager_get_toolbar_buttons_style ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_toolbar_visible ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_undo_actions_limit ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_get_use_default_font ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_get_window_size (int width, int height);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static int prefs_manager_get_window_state ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static Gtk.WrapMode prefs_manager_get_wrap_mode ();
	[CCode (cheader_filename = "gedit-2.20.h")]
	public static weak GLib.SList<string> prefs_manager_get_writable_vfs_schemes ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_highlight_current_line_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_init ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_insert_spaces_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_print_font_body_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_print_font_header_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_print_font_numbers_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_print_header_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_print_line_numbers_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_print_syntax_hl_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_print_wrap_mode_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_right_margin_position_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_active_file_filter (int id);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_auto_indent (bool ai);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_auto_save (bool as);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_auto_save_interval (int asi);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_bottom_panel_active_page (int id);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_bottom_panel_size (int ps);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_bottom_panel_visible (bool tv);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_bracket_matching (bool bm);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_create_backup_copy (bool cbc);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_display_line_numbers (bool dln);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_display_right_margin (bool drm);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_editor_font (string font);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_enable_search_highlighting (bool esh);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_enable_syntax_highlighting (bool esh);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_highlight_current_line (bool hl);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_insert_spaces (bool ai);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_print_font_body (string font);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_print_font_header (string font);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_print_font_numbers (string font);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_print_header (bool ph);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_print_line_numbers (int pln);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_print_syntax_hl (bool ps);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_print_wrap_mode (Gtk.WrapMode pwm);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_right_margin_position (int rmp);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_shown_in_menu_encodings (GLib.SList<Gedit.Encoding> encs);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_side_pane_visible (bool tv);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_side_panel_active_page (int id);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_side_panel_size (int ps);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_smart_home_end (Gtk.SourceSmartHomeEndType smart_he);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_source_style_scheme (string scheme);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_statusbar_visible (bool sv);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_tabs_size (int ts);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_toolbar_buttons_style (Gedit.ToolbarSetting tbs);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_toolbar_visible (bool tv);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_undo_actions_limit (int ual);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_use_default_font (bool udf);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_window_size (int width, int height);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_window_state (int ws);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_set_wrap_mode (Gtk.WrapMode wp);
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_shown_in_menu_encodings_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static void prefs_manager_shutdown ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_side_pane_visible_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_side_panel_active_page_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_side_panel_size_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_smart_home_end_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_source_style_scheme_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_statusbar_visible_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_tabs_size_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_toolbar_buttons_style_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_toolbar_visible_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_undo_actions_limit_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_use_default_font_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_window_size_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_window_state_can_set ();
	[CCode (cheader_filename = "gedit/gedit-prefs-manager.h")]
	public static bool prefs_manager_wrap_mode_can_set ();
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static void utils_activate_url (Gtk.AboutDialog about, string url, void* data);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_drop_get_uris (Gtk.SelectionData selection_data);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_escape_search_text (string text);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_escape_underscores (string text, long length);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_format_uri_for_display (string uri);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static void utils_get_current_viewport (Gdk.Screen screen, int x, int y);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static uint utils_get_current_workspace (Gdk.Screen screen);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static bool utils_get_glade_widgets (string filename, string root_node, out weak Gtk.Widget error_widget, string widget_name);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_get_stdin ();
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static uint utils_get_window_workspace (Gtk.Window gtkwindow);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static bool utils_is_valid_uri (string uri);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_make_canonical_uri_from_shell_arg (string str);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_make_valid_utf8 (string name);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static void utils_menu_position_under_tree_view (Gtk.Menu menu, int x, int y, bool push_in);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static void utils_menu_position_under_widget (Gtk.Menu menu, int x, int y, bool push_in);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_replace_home_dir_with_tilde (string uri);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static void utils_set_atk_name_description (Gtk.Widget widget, string name, string description);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static void utils_set_atk_relation (Gtk.Widget obj1, Gtk.Widget obj2, Atk.RelationType rel_type);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_str_middle_truncate (string str, uint truncate_length);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_unescape_search_text (string text);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static bool utils_uri_exists (string text_uri);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static weak string utils_uri_get_dirname (string uri);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static bool utils_uri_has_file_scheme (string uri);
	[CCode (cheader_filename = "gedit/gedit-utils.h")]
	public static bool utils_uri_has_writable_scheme (string uri);
	[CCode (cheader_filename = "gedit/gedit-debug.h")]
	public static void warning (string format, ...);
}
