#Vala Toys for gEdit Documentation

# Introduction #

The scope of Vtg is to support the programmer at best during the development of a Vala application.

To do it Vtg gives to the developer a list of tied integrated tools to use like _bracket or symbol completion_ and enhance the gEdit editor with some function like _quick file or method picker_.

Also it tries to minimize the use of mouse during the development.

To be clear: at the moment _vala toys_ it's **not yet** a finished product.

This page documents what Vtg _already_ can do and these will be all the features included in version 0.1. What remains to do is a lot of refactoring and code cleanups a lot of bug fixing and minor architectural enhancements.

## Project Manager ##

Vtg supports autotools project with the help of the gnome build framework (aka libgbf) library, the same actually used by the Anjuta IDE.

It doesn't expose to the user of the libgbf's functionalities, so you still have to edit Makefiles.am or configure.ac scripts by hand. This is intentional and wouldn't change unless libgbf will support better the specific bits of Vala in the autotool workflow.

### Working with projects ###

You can open a project or create a new one with the menu item _File -> Open project..._ or _File -> New project..._.

![http://vtg.googlecode.com/svn/wiki/doc-images/open-project.png](http://vtg.googlecode.com/svn/wiki/doc-images/open-project.png)

If you choose to create a new project a project creation dialog like this one will be shown:

![http://vtg.googlecode.com/svn/wiki/doc-images/gen-project.png](http://vtg.googlecode.com/svn/wiki/doc-images/gen-project.png)

In this window you can chose the project license, the project author and type among the other options.

After that you can see the project files on the right panel

![http://vtg.googlecode.com/svn/wiki/doc-images/project-manager.png](http://vtg.googlecode.com/svn/wiki/doc-images/project-manager.png)

You can also open more than one project at once and select the 'currently working' project with the combobox visible on the upper border of the project manager pane.

![http://vtg.googlecode.com/svn/wiki/doc-images/project-combo.png](http://vtg.googlecode.com/svn/wiki/doc-images/project-combo.png)

Double clicking on a source file will open that file in a new gEdit tab or will change the active tab uf the file is already opened.

Right click on a _group_ node will bring a popup menu where you can choose to open the corresponding Makefile.am file.

![http://vtg.googlecode.com/svn/wiki/doc-images/open-makefile.png](http://vtg.googlecode.com/svn/wiki/doc-images/open-makefile.png)

Instead right click on a _module_ node will bring a popup menu where you can choose to add a new library to the project or to open the configure.ac script

![http://vtg.googlecode.com/svn/wiki/doc-images/module-popup.png](http://vtg.googlecode.com/svn/wiki/doc-images/module-popup.png)

### Building and executing a project ###

In the _Build_ menu you have the commands for:

  * _Build project_: build the project executing the make command on the project root folder
  * _Clean project_: clean the project executing the 'make clean' command on the project root folder
  * _Clean Project and Vala stamp files_: this is peculiar on how vala currently uses autotools thus this menu will clean the project as the previous one, also it will remove all the `*`.stamp file presents in the vala folder
  * _Configure Project_: run the current project configure script
  * _Compile File_: compile a _standalone_ file, a file that do not belong to any current opened project, executing the vala compiler directly
  * _Next Error_ / _Previous Error_: will jump to the source location of the next / previous error
  * _Execute_: will execute the first builded program of the project (at the moment)
  * _Stop process_: will stop (kill) the last executed program

It's possible to see the build log in the gEdit bottom pane:

![http://vtg.googlecode.com/svn/wiki/doc-images/bottom-pane.png](http://vtg.googlecode.com/svn/wiki/doc-images/bottom-pane.png)

Moreover Vtg tries to interpret the Vala compiler warning and error messages and to present them in the _Build results_ page:

![http://vtg.googlecode.com/svn/wiki/doc-images/build-results.png](http://vtg.googlecode.com/svn/wiki/doc-images/build-results.png)

It's worth to notice that when executing a program its standard input, output and error will be connected to the _Output_ page so it can be possible to interact with the target program.

### Tools Menu ###

(to be released)

In version 0.3.0 Vtg as gained the possibility to prepare the changelog entry right before checking in or after editing each file.

In the _Tools_ menu' there are two items:

  * _Add current file to ChangeLog_: this will add the current filename to the top changelog entry. A new entry will be created if date, author or email aren't the same.
  * _Prepare ChangeLog_: this function works only if the current project is under some supported (currently svn, git, bzr) source code management tool. It prepares a changelog entry based on the status of each file as reported by the scm status command.

### Quick jump to a project source ###

Binded to the _Documents -> Go To Document..._ menu item there is a simple but useful functionality where you can jump to any project Vala source file.

![http://vtg.googlecode.com/svn/wiki/doc-images/document-jump.png](http://vtg.googlecode.com/svn/wiki/doc-images/document-jump.png)

In the search / filter box it's possibile to write the name of the file using the '`*`' and '?' wildcard as one can normally do in the shell.

Pressing _enter_ will filter the file list visible at the bottom of the entry.

## The Editor ##

When the active document is a Vala source code file two modules will help the develpment

  * Bracket completion module
  * Symbol completion module

### Bracket completion ###

With bracket completion on open a perenthesis will generate a matching close one or you can include a selection within " and more.

_Note_: using Vtg with other gEdit bracket completion plugins will result in an unpredicatble and funny behaviour.

### Symbol completion ###

Symbol completion will try to suggest possible completion items like available methods, signal etc... during the source code writing.

It's strongly tied to the _Project Manager_ module so it can complete the curret item basing its information on the referenced project libraries and files, but can be used alone and it will try to infer the referenced libraries from the _'using clauses'_ of the current source file.

![http://vtg.googlecode.com/svn/wiki/doc-images/completion-popup.png](http://vtg.googlecode.com/svn/wiki/doc-images/completion-popup.png)

It also provides a calltip popup where method signatures are presented to the user.

![http://vtg.googlecode.com/svn/wiki/doc-images/calltip-popup.png](http://vtg.googlecode.com/svn/wiki/doc-images/calltip-popup.png)

### Quick jump to a method ###

With the help of the symbol completion engine a function similar to the _Quick jump to a project source_ but with the current source file method list is provided and binded to the menu' _Search -> Go To Method..._

![http://vtg.googlecode.com/svn/wiki/doc-images/method-jump.png](http://vtg.googlecode.com/svn/wiki/doc-images/method-jump.png)

As for the 'source file' one it's possibile to use '`*`' and '?' as wildcard chars.

## Vala toys configuration ##

### Configuration window ###

When the _configure_ button is clicked in the gEdit plugin configuration window a simple dialog like this one will be shown:

![http://vtg.googlecode.com/svn/wiki/doc-images/config-dialog.png](http://vtg.googlecode.com/svn/wiki/doc-images/config-dialog.png)

In this dialog is you can selectivly activate or deactivate the Vtg modules like _symbol completion_ or _bracket completion_

### Changing the default menu' keybindings ###

_Vtg_ menu' are usually bindend with some keyboard shortcuts that improve greatly the speed and the comfort when using these function.

However keyboard shortcut are usually subject to personal preference, so they can be customized individually.

_Vtg_ uses the standard Gtk+ way to customize menu' keyboard shortcut, so you can configure them with these simple steps:

  1. Enable the menu' customization function with the corresponding check in the GNOME _Appearance Preference_ dialog (on my Debian system is under _System -> Preferences_)
  1. Open gEdit select the menu' that you want to change
  1. Press the new keys combination on the keyboard with menu' item selected
  1. That's all :)

![http://vtg.googlecode.com/svn/wiki/doc-images/gnome-appearence.png](http://vtg.googlecode.com/svn/wiki/doc-images/gnome-appearence.png)