---------------------------
-- INSTALL file for SLiM --
---------------------------

Prerequisites:
--------------

   - cmake (version 3.10.2)
   - A C++ Compiler (g++)
   - PkgConfig (pkg-config (0.29-4)) 
   - fontconfig (2.11.0-6.7)
   - libfreetype (libfreetype6-dev)
   - libxft-dev (2.3.2-1+b2)
   - libxmu
   - libpng (libpng-dev) 
   - zlib ("1.2.8")
   - libjpeg (libjpeg9-dev)
   - X.org or XFree86
   
   Optionally may also require:

   - libpam0g  (required really) 
   - libck-connector0
   - libdbus-1-3


    (These should be auto-detected cached  and reported 
	at _initial_ cmake time.)

External Applications
----------------------

For Operations::

    - At least one Window Manager or Desktop Environment to _login_ to.
      +  _F1_ Allows choice between installed environments.
    -  "console" Requires an  Xterm
    -  _F11_  as screenshot
       + Requires "import" e.g as found in the imagemagick suite.
       + Alt: slim has also well tested with "scrot"


The Build Process
-----------------

Here is the short version::

  mkdir build ;
  cd ./build ;
  cmake ../  -DUSE_PAM=yes ;

Step by step

1. Create a clean space to build the software::

    $ mkdir build

*Optionally* edit the CMakefile.txt
to adjust libraries and paths to your Operating System (if needed).
For example:  CMAKE_INSTALL_PREFIX "/usr/local"

2. Work from the clean dir::

     $ cd build

3. Configure your final make files::

     $ cmake ../

*Notes*:

The above minimal instruction would be a reasonable first test only.
You will need some functionality.

Configure Options
-----------------

This next incantation should get you a full build.
With ConsoleKit and Desktop Bus support::

    $ cmake ../ -DUSE_PAM=yes -DUSE_CONSOLEKIT=yes

To Disallow ConsoleKit  *(N.B. and by extension dbus)*
and NOT build shared libraries::

    $ cmake ../ -DUSE_PAM=yes -DUSE_CONSOLEKIT=no -DBUILD_SHARED_LIBS=no

This is the stage you _may_ want to tweak the new make files.
Or more probably not so::

     $ make
     $ ls

Configure Stage notes
.....................

- Cmake caches assertively.
- It quite safe to remove the ./build/ level cache files.
  Re-runs do rebuild them.
  This approach extends to the clean build directory itself.
- On a project of this modest size the compile time is short.
  The debug time possibly less so ?

Simple test
-----------

 Test the freshly made executable::

     $ ./slim -v


Installation
------------

The GNU Makefile produced by cmake has some interesting targets.
Also Consider current CMake settings:  CMAKE_INSTALL_PREFIX "/usr/local"
** $ sudo make install/local  **  (may be reassuring.)

The classic::

     $ sudo make install

Test the new system theme *from a running X session*::

     $ slim -p /usr/local/share/slim/themes/default


Other
-----
Some notes hints and paths from the wilds::

     $ make clean
     $ cmake --help
     $ make local/install

(all run from the build directory)

Remove the "build" directory tree (only) to start over.

Path Manifest
-------------

Here is a listing of typical installed paths
as output by an "updating" run of "make install"
Notice *only rebuilt* files are re-installed ::

    Install the project...
    /usr/bin/cmake -P cmake_install.cmake
    -- Install configuration: ""
    -- Up-to-date: /usr/local/bin/slim
    -- Up-to-date: /usr/local/bin/slimlock
    -- Up-to-date: /usr/local/lib/libslim.so.1.3.6
    -- Up-to-date: /usr/local/lib/libslim.so
    -- Up-to-date: /usr/local/share/man/man1/slim.1
    -- Up-to-date: /usr/local/share/man/man1/slimlock.1
    -- Up-to-date: /etc/slim.conf
    -- Up-to-date: /lib/systemd/system/slim.service
    -- Installing: /usr/local/share/slim/themes/default/slim.theme
    -- Installing: /usr/local/share/slim/themes/default/panel.png
    -- Installing: /usr/local/share/slim/themes/default/background.jpg


Linked Libraries
................

 This is a typical linkage string passed to the compiler
 for the final slim (elf) executable.
 (With ConsoleKit and dbus.)

::

    -lfontconfig -lpam -ldbus-1 -lck-connector -lm -lrt
    -lcrypt -lX11 -lXft -lXrender -lXrandr -lXmu -lfreetype
    -ljpeg -lpng -lz libslim.so.1.3.6 -ljpeg -lpng -lz


$ ldd slim
$ objdump ./slim

$ file slim

 may approximate::

     ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV),
     dynamically linked, interpreter /lib/ld-linux.so.2,
     for GNU/Linux 2.6.32,
     BuildID[sha1]=b44698a3baf559d0a79e517221c0ad6cea2b5504, not stripped


Convenience Installable Archiver
---------------------------------
From the build directory

$ fakeroot cpack --config CPackConfig.cmake
