# How to compile and install Vala Toys for GEdit #

## Prerequisites ##

_Last released version:_

```
  * glib at least 2.28.0
  * gtk+ at least 3.0
  * gedit at least 3.0
  * vala 0.12 (0.14 is not supporter yet)
```

## Standard compile instruction for system-wide installation (easy) ##

```
./configure --prefix=/usr
make
sudo make install
```

## Local User installation and other installation tips (not always easy) ##

## Compiling ##
Having installed the required dependecies,
you can compile _Vtg_ with this command if you downloaded the source tarball:

```
./configure --prefix=$HOME/.local
make
```

or with this if you checked out vtg from the svn repository:

```
./autogen.sh --prefix=$HOME/.local
make
```

**Alternative method**

To workaround the [issue 135](http://code.google.com/p/vtg/issues/detail?id=135), caused by the inconsistent generation of the configure script by different version of autotools, I have included in the repository the files required to compile without using autogen.sh.

In this case to compile vtg you should use:
```
aclocal
automake --add-missing
intltoolize --force
./configure --prefix=$HOME/.local
make
```

**TIP**

If you get this error on a 64bit system
```
/usr/bin/ld: ../gsc-0.7.0/gtksourcecompletion/.libs/libgtksourcecompletion-2.0.a(gsc-provider.o): relocation R_X86_64_32S against `.text' can not be used when making a shared object; recompile with -fPIC
../gsc-0.7.0/gtksourcecompletion/.libs/libgtksourcecompletion-2.0.a: could not read symbols: Bad value
collect2: ld returned 1 exit status
```

try to recompile with CFLAGS specified:

```
make CFLAGS="-g -O2 -fPIC"
```


### Installing ###

#### Step 1 ####
To install for the current user, from the root folder of the _Vtg_ distribution, do:

```
make install
```

#### Step 2 ####
Now we have to copy vala-gen-project from the gen-project folder to one included in the executable path (eg. /usr/local/bin)

```
sudo cp gen-project/vala-gen-project /usr/local/bin
```

Or **in alternative** add $HOME/.local/bin in front of your $PATH variable

#### Step 3 ####
Finally, because of this GSetting limit [Bug 649717](http://bugzilla.gnome.org/show_bug.cgi?id=649717), we have to copy the schema file and updated (compile) the schema cache. From the vala toys source folder:

```
sudo cp data/org.gnome.gedit.plugins.vala-toys.gschema.xml  /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas
```