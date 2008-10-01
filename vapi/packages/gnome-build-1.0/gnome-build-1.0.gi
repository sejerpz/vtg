<?xml version="1.0"?>
<api version="1.0">
	<namespace name="Gbf">
		<struct name="GbfBackend">
			<method name="get_backends" symbol="gbf_backend_get_backends">
				<return-type type="GSList*"/>
			</method>
			<method name="init" symbol="gbf_backend_init">
				<return-type type="void"/>
			</method>
			<method name="new_project" symbol="gbf_backend_new_project">
				<return-type type="GbfProject*"/>
				<parameters>
					<parameter name="id" type="char*"/>
				</parameters>
			</method>
			<field name="id" type="char*"/>
			<field name="name" type="char*"/>
			<field name="description" type="char*"/>
		</struct>
		<struct name="GbfProject">
			<method name="add_group" symbol="gbf_project_add_group">
				<return-type type="gchar*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="parent_id" type="gchar*"/>
					<parameter name="name" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="add_source" symbol="gbf_project_add_source">
				<return-type type="gchar*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="target_id" type="gchar*"/>
					<parameter name="uri" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="add_target" symbol="gbf_project_add_target">
				<return-type type="gchar*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="group_id" type="gchar*"/>
					<parameter name="name" type="gchar*"/>
					<parameter name="type" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="configure" symbol="gbf_project_configure">
				<return-type type="GtkWidget*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="configure_group" symbol="gbf_project_configure_group">
				<return-type type="GtkWidget*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="configure_new_group" symbol="gbf_project_configure_new_group">
				<return-type type="GtkWidget*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="configure_new_source" symbol="gbf_project_configure_new_source">
				<return-type type="GtkWidget*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="configure_new_target" symbol="gbf_project_configure_new_target">
				<return-type type="GtkWidget*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="configure_source" symbol="gbf_project_configure_source">
				<return-type type="GtkWidget*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="configure_target" symbol="gbf_project_configure_target">
				<return-type type="GtkWidget*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="error_quark" symbol="gbf_project_error_quark">
				<return-type type="GQuark"/>
			</method>
			<method name="get_all_groups" symbol="gbf_project_get_all_groups">
				<return-type type="GList*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_all_sources" symbol="gbf_project_get_all_sources">
				<return-type type="GList*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_all_targets" symbol="gbf_project_get_all_targets">
				<return-type type="GList*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_capabilities" symbol="gbf_project_get_capabilities">
				<return-type type="GbfProjectCapabilities"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_config_modules" symbol="gbf_project_get_config_modules">
				<return-type type="GList*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_config_packages" symbol="gbf_project_get_config_packages">
				<return-type type="GList*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="module" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_group" symbol="gbf_project_get_group">
				<return-type type="GbfProjectGroup*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_source" symbol="gbf_project_get_source">
				<return-type type="GbfProjectTargetSource*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_target" symbol="gbf_project_get_target">
				<return-type type="GbfProjectTarget*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="get_types" symbol="gbf_project_get_types">
				<return-type type="gchar**"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
				</parameters>
			</method>
			<method name="load" symbol="gbf_project_load">
				<return-type type="void"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="path" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="mimetype_for_type" symbol="gbf_project_mimetype_for_type">
				<return-type type="gchar*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="type" type="gchar*"/>
				</parameters>
			</method>
			<method name="name_for_type" symbol="gbf_project_name_for_type">
				<return-type type="gchar*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="type" type="gchar*"/>
				</parameters>
			</method>
			<method name="probe" symbol="gbf_project_probe">
				<return-type type="gboolean"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="path" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="refresh" symbol="gbf_project_refresh">
				<return-type type="void"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="remove_group" symbol="gbf_project_remove_group">
				<return-type type="void"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="remove_source" symbol="gbf_project_remove_source">
				<return-type type="void"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="remove_target" symbol="gbf_project_remove_target">
				<return-type type="void"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="id" type="gchar*"/>
					<parameter name="error" type="GError**"/>
				</parameters>
			</method>
			<method name="util_add_source" symbol="gbf_project_util_add_source">
				<return-type type="gchar*"/>
				<parameters>
					<parameter name="model" type="GbfProjectModel*"/>
					<parameter name="parent" type="GtkWindow*"/>
					<parameter name="default_target" type="gchar*"/>
					<parameter name="default_group" type="gchar*"/>
					<parameter name="default_uri_to_add" type="gchar*"/>
				</parameters>
			</method>
			<method name="util_add_source_multi" symbol="gbf_project_util_add_source_multi">
				<return-type type="GList*"/>
				<parameters>
					<parameter name="model" type="GbfProjectModel*"/>
					<parameter name="parent" type="GtkWindow*"/>
					<parameter name="default_target" type="gchar*"/>
					<parameter name="default_group" type="gchar*"/>
					<parameter name="uris_to_add" type="GList*"/>
				</parameters>
			</method>
			<method name="util_new_group" symbol="gbf_project_util_new_group">
				<return-type type="gchar*"/>
				<parameters>
					<parameter name="model" type="GbfProjectModel*"/>
					<parameter name="parent" type="GtkWindow*"/>
					<parameter name="default_group" type="gchar*"/>
					<parameter name="default_group_name_to_add" type="gchar*"/>
				</parameters>
			</method>
			<method name="util_new_target" symbol="gbf_project_util_new_target">
				<return-type type="gchar*"/>
				<parameters>
					<parameter name="model" type="GbfProjectModel*"/>
					<parameter name="parent" type="GtkWindow*"/>
					<parameter name="default_group" type="gchar*"/>
					<parameter name="default_target_name_to_add" type="gchar*"/>
				</parameters>
			</method>
			<field name="parent" type="GObject"/>
		</struct>
		<struct name="GbfProjectClass">
			<field name="parent_class" type="GObjectClass"/>
			<field name="project_updated" type="GCallback"/>
			<field name="load" type="GCallback"/>
			<field name="probe" type="GCallback"/>
			<field name="refresh" type="GCallback"/>
			<field name="get_capabilities" type="GCallback"/>
			<field name="add_group" type="GCallback"/>
			<field name="remove_group" type="GCallback"/>
			<field name="get_group" type="GCallback"/>
			<field name="get_all_groups" type="GCallback"/>
			<field name="configure_group" type="GCallback"/>
			<field name="configure_new_group" type="GCallback"/>
			<field name="add_target" type="GCallback"/>
			<field name="remove_target" type="GCallback"/>
			<field name="get_target" type="GCallback"/>
			<field name="get_all_targets" type="GCallback"/>
			<field name="configure_target" type="GCallback"/>
			<field name="configure_new_target" type="GCallback"/>
			<field name="add_source" type="GCallback"/>
			<field name="remove_source" type="GCallback"/>
			<field name="get_source" type="GCallback"/>
			<field name="get_all_sources" type="GCallback"/>
			<field name="configure_source" type="GCallback"/>
			<field name="configure_new_source" type="GCallback"/>
			<field name="configure" type="GCallback"/>
			<field name="get_config_modules" type="GCallback"/>
			<field name="get_config_packages" type="GCallback"/>
			<field name="name_for_type" type="GCallback"/>
			<field name="mimetype_for_type" type="GCallback"/>
			<field name="get_types" type="GCallback"/>
		</struct>
		<struct name="GbfProjectGroup">
			<method name="copy" symbol="gbf_project_group_copy">
				<return-type type="GbfProjectGroup*"/>
				<parameters>
					<parameter name="group" type="GbfProjectGroup*"/>
				</parameters>
			</method>
			<method name="free" symbol="gbf_project_group_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="group" type="GbfProjectGroup*"/>
				</parameters>
			</method>
			<field name="id" type="gchar*"/>
			<field name="parent_id" type="gchar*"/>
			<field name="name" type="gchar*"/>
			<field name="groups" type="GList*"/>
			<field name="targets" type="GList*"/>
		</struct>
		<struct name="GbfProjectModel">
			<method name="find_id" symbol="gbf_project_model_find_id">
				<return-type type="gboolean"/>
				<parameters>
					<parameter name="model" type="GbfProjectModel*"/>
					<parameter name="iter" type="GtkTreeIter*"/>
					<parameter name="type" type="GbfTreeNodeType"/>
					<parameter name="id" type="gchar*"/>
				</parameters>
			</method>
			<method name="get_project" symbol="gbf_project_model_get_project">
				<return-type type="GbfProject*"/>
				<parameters>
					<parameter name="model" type="GbfProjectModel*"/>
				</parameters>
			</method>
			<method name="get_project_root" symbol="gbf_project_model_get_project_root">
				<return-type type="GtkTreePath*"/>
				<parameters>
					<parameter name="model" type="GbfProjectModel*"/>
				</parameters>
			</method>
			<method name="new" symbol="gbf_project_model_new">
				<return-type type="GbfProjectModel*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
				</parameters>
			</method>
			<method name="set_project" symbol="gbf_project_model_set_project">
				<return-type type="void"/>
				<parameters>
					<parameter name="model" type="GbfProjectModel*"/>
					<parameter name="project" type="GbfProject*"/>
				</parameters>
			</method>
			<field name="parent" type="GtkTreeStore"/>
			<field name="priv" type="GbfProjectModelPrivate*"/>
		</struct>
		<struct name="GbfProjectModelClass">
			<field name="parent_class" type="GtkTreeStoreClass"/>
		</struct>
		<struct name="GbfProjectTarget">
			<method name="copy" symbol="gbf_project_target_copy">
				<return-type type="GbfProjectTarget*"/>
				<parameters>
					<parameter name="target" type="GbfProjectTarget*"/>
				</parameters>
			</method>
			<method name="free" symbol="gbf_project_target_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="target" type="GbfProjectTarget*"/>
				</parameters>
			</method>
			<field name="id" type="gchar*"/>
			<field name="group_id" type="gchar*"/>
			<field name="name" type="gchar*"/>
			<field name="type" type="gchar*"/>
			<field name="sources" type="GList*"/>
		</struct>
		<struct name="GbfProjectTargetSource">
			<method name="copy" symbol="gbf_project_target_source_copy">
				<return-type type="GbfProjectTargetSource*"/>
				<parameters>
					<parameter name="source" type="GbfProjectTargetSource*"/>
				</parameters>
			</method>
			<method name="free" symbol="gbf_project_target_source_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="source" type="GbfProjectTargetSource*"/>
				</parameters>
			</method>
			<field name="id" type="gchar*"/>
			<field name="target_id" type="gchar*"/>
			<field name="source_uri" type="gchar*"/>
		</struct>
		<struct name="GbfProjectView">
			<method name="find_selected" symbol="gbf_project_view_find_selected">
				<return-type type="GbfTreeData*"/>
				<parameters>
					<parameter name="view" type="GbfProjectView*"/>
					<parameter name="type" type="GbfTreeNodeType"/>
				</parameters>
			</method>
			<method name="new" symbol="gbf_project_view_new">
				<return-type type="GtkWidget*"/>
			</method>
			<field name="parent" type="GtkTreeView"/>
			<field name="priv" type="GbfProjectViewPrivate*"/>
		</struct>
		<struct name="GbfProjectViewClass">
			<field name="parent_class" type="GtkTreeViewClass"/>
			<field name="uri_activated" type="GCallback"/>
			<field name="target_selected" type="GCallback"/>
			<field name="group_selected" type="GCallback"/>
		</struct>
		<struct name="GbfTreeData">
			<method name="copy" symbol="gbf_tree_data_copy">
				<return-type type="GbfTreeData*"/>
				<parameters>
					<parameter name="data" type="GbfTreeData*"/>
				</parameters>
			</method>
			<method name="free" symbol="gbf_tree_data_free">
				<return-type type="void"/>
				<parameters>
					<parameter name="data" type="GbfTreeData*"/>
				</parameters>
			</method>
			<method name="new_group" symbol="gbf_tree_data_new_group">
				<return-type type="GbfTreeData*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="group" type="GbfProjectGroup*"/>
				</parameters>
			</method>
			<method name="new_source" symbol="gbf_tree_data_new_source">
				<return-type type="GbfTreeData*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="source" type="GbfProjectTargetSource*"/>
				</parameters>
			</method>
			<method name="new_string" symbol="gbf_tree_data_new_string">
				<return-type type="GbfTreeData*"/>
				<parameters>
					<parameter name="string" type="gchar*"/>
				</parameters>
			</method>
			<method name="new_target" symbol="gbf_tree_data_new_target">
				<return-type type="GbfTreeData*"/>
				<parameters>
					<parameter name="project" type="GbfProject*"/>
					<parameter name="target" type="GbfProjectTarget*"/>
				</parameters>
			</method>
			<field name="type" type="GbfTreeNodeType"/>
			<field name="name" type="gchar*"/>
			<field name="id" type="gchar*"/>
			<field name="uri" type="gchar*"/>
			<field name="is_shortcut" type="gboolean"/>
			<field name="mime_type" type="gchar*"/>
		</struct>
		<enum name="GbfTreeNodeType">
			<member name="GBF_TREE_NODE_STRING" value="0"/>
			<member name="GBF_TREE_NODE_GROUP" value="1"/>
			<member name="GBF_TREE_NODE_TARGET" value="2"/>
			<member name="GBF_TREE_NODE_TARGET_SOURCE" value="3"/>
		</enum>
		<constant name="GBF_BUILD_ID_DEFAULT" type="char*" value="DEFAULT"/>
	</namespace>
</api>
