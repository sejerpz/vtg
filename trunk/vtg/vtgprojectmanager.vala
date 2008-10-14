/*
 *  vtgprojectmanager.vala - Vala developer toys for GEdit
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

namespace Vtg.ProjectManager
{
	public class PluginHelper : GLib.Object
	{
		/* UI Code */
		private string _ui_def = """<ui>
                                            <menubar name="MenuBar">
                                                <menu name="FileMenu" action="File">
                                                    <placeholder name="FileOps_2">
                                                        <menuitem name="ProjectOpen" action="ProjectOpen"/>
                                                    </placeholder>
                                                </menu>
                                            </menubar>
                                            <menubar name="MenuBar">
                                                <menu name="BuildMenu" action="ProjectBuildMenuAction">
                                                    <placeholder name="BuildMenuOps_1">
                                                        <menuitem name="ProjectBuild" action="ProjectBuild"/>
                                                    </placeholder>
                                                </menu>
                                            </menubar>
                                        </ui>""";
		private uint _ui_id;

//                                                    <placeholder name="EditOps_3">
//                                                        <menuitem name="ProjectBuild" action="ProjectBuild"/>
//                                                    </placeholder>
		const ActionEntry[] _action_entries = {
			{"ProjectOpen", null, N_("Op_en Project..."), "<control><alt>O", N_("Open an existing project"), on_project_open},
			{"ProjectSave", null, N_("S_ave Project..."), "<control><alt>S", N_("Save the current project"), on_project_save},
			{"ProjectBuildMenuAction", null, N_("Build"), null, N_("Build menu"), null},
			{"ProjectBuild", Gtk.STOCK_EXECUTE, N_("_Build Project"), "<control><shift>B", N_("Build the current project using 'make'"), on_project_build}
		};


		/* END UI */
		private Gee.List<Project> _projects = new Gee.ArrayList<Project> ();

		private Vtg.Plugin _plugin;
		private ProjectManager.View _prj_view = null;
		private ProjectManager.Builder _prj_builder = null;

 		public Vtg.Plugin plugin { get { return _plugin; } construct { _plugin = value; } default = null; }

		//public signal void project_loaded (Project project);

		public PluginHelper (Vtg.Plugin plugin)
		{
			this.plugin = plugin;
		}

		construct	
		{
			initialize_ui ();
			_prj_builder = new ProjectManager.Builder (_plugin);
		}

		private void initialize_ui ()
		{
			var prj_agrp = new ActionGroup ("ProjectManagerActionGroup");
			prj_agrp.add_actions (_action_entries, this);
			var manager = plugin.gedit_window.get_ui_manager ();
			manager.insert_action_group (prj_agrp, -1);
			try {
				_ui_id = manager.add_ui_from_string (_ui_def, -1);
			} catch (Error err) {
				GLib.warning ("Error %s", err.message);
			}
		}

		public void deactivate ()
		{
			GLib.debug ("prjm deactvate");			
			GLib.debug ("prjm deactvated");
		}

		private void on_project_open (Gtk.Action action)
		{
			GLib.debug ("Action %s activated", action.name);
			var dialog = new Gtk.FileChooserDialog (_("Open Project"),
				      _plugin.gedit_window,
				      Gtk.FileChooserAction.SELECT_FOLDER,
				      Gtk.STOCK_CANCEL, ResponseType.CANCEL,
				      Gtk.STOCK_OPEN, ResponseType.ACCEPT,
				      null);

			if (dialog.run () == ResponseType.ACCEPT) {
				var foldername = dialog.get_filename ();
				open_project (foldername);				
			}
			dialog.destroy ();
		}
			    

		private void on_project_save (Gtk.Action action)
		{
			GLib.debug ("Action %s activated", action.name);
		}

		private void on_project_build (Gtk.Action action)
		{
			GLib.debug ("Action %s activated", action.name);
			if (this.get_project_manager_view.current_project != null) {
				var project = this.get_project_manager_view.current_project;
				GLib.debug ("building project %s", project.name);
				_prj_builder.build (project);
			}
		}

		private void open_project (string name)
		{
			try {
				var project = new Project ();
				if (project.open (name)) {
					_projects.add (project);
					//HACK: why the signal isn't working?!?!
					//this.project_loaded (project);
					_plugin.on_project_loaded (this, project);
					this.get_project_manager_view.add_project (project);
				}
			} catch (Error err) {
				GLib.warning ("Error %s", err.message);
			}
		}

		private View get_project_manager_view
		{
			get {
				if (_prj_view == null) {
					_prj_view = new ProjectManager.View (this._plugin);
				}

				return _prj_view;
			}
		}
	}
}
