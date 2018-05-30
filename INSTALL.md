---------------------------
-- INSTALL file for SLiM --
---------------------------

Prerequisites:
--------------

   - cmake (version 3.10.2)
   - A C++ Compiler (g++)
   - PkgConfig   (pkg-config (0.29-4)) 
   - fontconfig  (2.11.0-6.7)
   - libpam0g    (libpam0g-dev)
   - libfreetype (libfreetype6-dev)
   - libxft-dev  (2.3.2-1+b2)
   - libxmu      (libxmu6 2:1.1.2-2)
   - libpng      (libpng-dev) and compression with: 
   - zlib        (zlib1g-dev "1.2.8") 
   - libjpeg     (libjpeg9-dev)
   - X.org or XFree86
   
   Optionally may also require:

   - libck-connector0
   - libdbus-1-3


    (These latter two should be auto-detected cached and reported 
	at _initial_ cmake time.)

Hint:
-----

On a deb based system (Devuan ascii) approximate this to get started and 
drag in most of the depends::

     sudo apt-get install cmake pkg-config fontconfig libpam0g libpam0g-dev\
     libfreetype6-dev libxft-dev libpng-dev libjpeg9-dev libxmu-dev\
	 libxrandr-dev x11proto-randr-dev build-essential


External Applications
----------------------

For Operations::

    - At least one Window Manager and or Desktop Environment to _login_ to.
      --  _F1_ Allows choice between installed environments.
	  openbox enlightenment mate and gnome type desktops test OK
	  KDE *should* be OK but not tested by this writer ...
      
    - "console" Requires an Xterm or equivalent
	
    - _F11_  configured as screenshot:
      -- Requires "import" e.g as found in the imagemagick suite.
      -- Alternatively: slim has been tested with "scrot"


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
You will need some login functionality.
It does serve as a minimal test of the build requirement's though.


Configure Options
-----------------
Here is a _useful minimal tested_ configuration with cmake:
This enables PAM for login / session authorisation. 
Nothing much else other than themes. 

Default Build
.............

These two should be equivalent if PAM 
is available on the build system.     ::


    $ cmake ../ -DUSE_PAM=yes
    $ cmake ..	

(Yes you may set -DUSE_PAM=no)

A successful build prints look a lot like this::

    $ cmake ../ -DUSE_PAM=yes
		FontConfig Found
		OK: PAM functions included
        OK: Slimlock Possible
        Note: slimlock screen locker is NOT enabled
        OK ConsoleKit disabled
    -- Enable shared library building
		OK slimlock not to be built
    -- Configuring done
    -- Generating done
	-- Build files have been written to: /some/place/at-yours/slim/build

Hint
....

Treat "NOTFOUND" errors as a missing dependency (at least at first).
e.g.::

      CMake Error: The following variables are used in this project, 
      but they are set to NOTFOUND
	  


More Complex Builds
...................

This next incantation should get you a fulsome build.
With slimlock ConsoleKit and Desktop Bus support::

    $ cmake ../ -DUSE_PAM=yes -DBUILD_SLIMLOCK=yes  -DUSE_CONSOLEKIT=yes

To Disallow ConsoleKit  *(N.B. and by extension DBUS)*
and NOT build shared libraries::

    $ cmake ../ -DUSE_PAM=yes -DUSE_CONSOLEKIT=no -DBUILD_SHARED_LIBS=no

This is the stage you _may_ want to tweak the new make files.
Or more probably not so::

     $ make
     $ ls


     
Configure Stage notes
.....................

- Cmake caches assertively.
- It is safe to remove the ./build/ level cache files.
  Re-runs do rebuild them.
  This approach extends to the clean build directory itself.
- On a project of this modest size the compile time is short.
  The debug time possibly less so ?

Simple test
-----------

Test the freshly made executable::

     $ ./slim -v
     slim version 1.3.9
     
Testing Themes
--------------

To test a fresh built slim. 
From a logged in X session::

    - first install *xnest* - Nested X server
    - just the package *xnest* suffices.
   
Then from the top level of the slim source tree::
   
    $ ./build/slim -p ./themes/default
    $ ./build/slim -p ./themes/xamplar
   
   
 This allows testing of most functionality.
 Including the four account field commands.
 *exit reboot halt console*.

------------
Installation
------------

The GNU Makefile produced by cmake has some interesting targets.
Also Consider current CMake settings:  CMAKE_INSTALL_PREFIX "/usr/local"
** $ sudo make install/local  **  (may be reassuring or useful.)

The classic::

    $ sudo make install

Test a new, installed,  _system_ theme *from a running X session*::

     $ slim -p /usr/local/share/slim/themes/default




Other
-----
Either a system wide xsession default needs to be established and or 
a .xinitrc is required per user.

There is an example .xinitrc in this source code.



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
 (With ConsoleKit and DBUS.)

::

    -lfontconfig -lpam -ldbus-1 -lck-connector -lm -lrt
    -lcrypt -lX11 -lXft -lXrender -lXrandr -lXmu -lfreetype
    -ljpeg -lpng -lz libslim.so.1.3.6 -ljpeg -lpng -lz


    $ ldd slim
    $ objdump [options] ./slim

    $ file slim

 May more or less approximate::

     ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV),
     dynamically linked, interpreter /lib/ld-linux.so.2,
     for GNU/Linux 2.6.32,
     BuildID[sha1]=b44698a3baf559d0a79e517221c0ad6cea2b5504, not stripped


Convenience Installable Archiver
---------------------------------

Cmake has an archive maker thingy...
From the build directory::

    $ fakeroot cpack --config CPackConfig.cmake

eof.
