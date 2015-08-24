Vala project skeleton creator with templates

# Introduction #

Vala GenProject is an utility that helps creating project skeletons for Vala programs and libraries

# How to use #

Vala GenProject includes a Gtk+ UI and a command line interface and its usage is pretty simple, just select the wanted template, complete the dialog with the required information like author email and license, and click on the generate button.

### Screeshot ###

You can see Vala GenProject here

![http://vtg.googlecode.com/svn/wiki/doc-images/vala-gen-project.png](http://vtg.googlecode.com/svn/wiki/doc-images/vala-gen-project.png)

# How to create a new project template #

Project templates are defined by 3 file:
  1. template.ini file
  1. template.png file
  1. template.tar.gz

These files can be stored in
  * /usr/share/vtg/templates for system wide templates
  * /home/andrea/.local/share/gen-project/templates for user templates

(you can change these path at compile time)

### Template.ini file ###

This file defines the template and it's a simple keyfile with just one **[Template](Template.md)** section. For example:

```
[Template]
version=1.0
name=Console Application
description=A Vala console application project
details=This template will create and empty vala project with an empty main method
language=vala
build-system=autotools
tags=glib,console
```

| **key** | **description** |
|:--------|:----------------|
| version | Template file version should be always 1.0 |
| name    | It's the template name so it should be short and concise and shouldn't be translated |
| description | A longer name that better describe the template |
| details | An even more detailed note |
| language | The programming language used in this template. Eg. vala, genie |
| build-system | The build system used in this template. Eg. autotools, waf, scons |
| tags    | Template tags. Eg. gnome, glib, console, gtk+ etc |

All the language, build-system and tags fields can be used to present a filtered list of templates in the ui (this is not supported by the current frontend) and here there are some tables that can be used as reference when choosing these values:

| **language** | **description** |
|:-------------|:----------------|
| Vala         | Vala programming language |
| Genie        | Genie  programming language |

| **build system** | description |
|:-----------------|:------------|
| autotools        | autotools with valac support >= 1.11 |
| waf              | waf build system |
| scons            | scons build system |
| cmake            | cmake build system |

An here a list of common tags

| **tags** | **description** |
|:---------|:----------------|
| gnome    | for a gnome application template |
| gtk+     | for a Gtk+ application template |
| console  | for a console application template |
| plugin   | for a plugin template, futher tags can be rhythmbox for a rhythmbox plugin or eog... |

### Template.tar.gz ###

This file contains the actual template files. For example the console.tar.gz contails:

```
-rw-r--r-- andrea/andrea    33 2010-06-06 17:35 AUTHORS.template
-rwxr-xr-x andrea/andrea   164 2010-06-06 17:48 autogen.sh.template
-rw-r--r-- andrea/andrea     0 2010-06-06 17:35 ChangeLog
-rw-r--r-- andrea/andrea   874 2010-06-06 17:44 configure.ac.template
-rw-r--r-- andrea/andrea    39 2010-06-06 17:35 MAINTAINERS.template
-rw-r--r-- andrea/andrea   483 2010-06-06 17:47 Makefile.am.template
-rw-r--r-- andrea/andrea     0 2010-06-06 17:35 NEWS
drwxr-xr-x andrea/andrea     0 2010-06-06 18:47 po/
-rw-r--r-- andrea/andrea    48 2010-06-06 17:35 po/LINGUAS
-rw-r--r-- andrea/andrea     0 2010-06-06 17:35 po/ChangeLog
-rw-r--r-- andrea/andrea    11 2010-06-06 17:35 po/POTFILES.skip
-rw-r--r-- andrea/andrea    91 2010-06-06 17:35 po/POTFILES.in
-rw-r--r-- andrea/andrea     0 2010-06-06 17:35 README
drwxr-xr-x andrea/andrea     0 2010-06-06 23:28 src/
-rw-r--r-- andrea/andrea   354 2010-06-06 23:28 src/main.vala.template
-rw-r--r-- andrea/andrea   338 2010-06-06 17:47 src/Makefile.am.template
```

As you can see there are a lot of files with the template extension, these ones will be read by vala-gen-project and parsed for special tag substitution. After this process the .template extension will be removed from the resulting file.

Here a list of known tags:

| **tag** | **description** |
|:--------|:----------------|
| ${license-header} | the chosen license source header |
| ${license-header-vala} | the chosen license source header formatted as a Vala comment |
| ${license-program-type} | the program type "library" or "program" |
| ${license-name} | the license name |
| ${license-version} | the license version |
| ${license-web-site} | the license web site |
| ${license-publisher} | the license publisher |
| ${author-name} | the project author |
| ${author-email} | the project author email |
| ${project-name} | the project name |
| ${project-description} | the project description |
| ${project-uppercase-make-name} | the project name in uppercase make compatible format |
| ${project-make-name} | the project name in make compatible format |

### Other ###

Vala GenProject use a convenience library to do all its parsing and project generation so you can use it in your project too. Unlucky the documentation is still not written but you can see how is it used from the vala GenProject sources at: http://code.google.com/p/vtg/source/browse/trunk/gen-project/main.vala#114