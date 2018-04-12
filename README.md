--------------------------
-- README file for SLiM --
--------------------------

Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

INTRODUCTION
------------

    SLiM (Simple Login Manager)
    Is a graphical login manager for X11.

    It aims to be simple, fast and *independent* from the various
    desktop environments.

    SLiM was based on latest stable release of Login.app by Per Lidén.

Features:
..........

       - External themes and configuration
       - PNG support with alpha transparency for panel
       - PNG / JPEG support for backgrounds
       - XFT / freetype support
       - Double or single (GDM-style) inputbox support
       

INSTALLATION
------------

see the [INSTALL file](./INSTALL.md "How to install slim from source")

USAGE
-----

To launch slim, execute the slim binary,
followed by the -d option to run as a daemon.
You will probably need to allow your systems init system to auto launch
at boot.
sysV and systemd files are included and installed.
The sysV file should also be close for rc.d (*BSD) systems.

    - Enter _username_ and _password_ to login.

*Your personal  ~/.xinitrc file is executed by default*,
so be sure to have a working
.xinitrc file in your home.
(see the config file)
If you have trouble starting your desktop environment:
There is an [example ~/.xinitrc](./xinitrc.sample "example user xinitrc") 
included with the source code.
It is possible that has what you need.
	
Special "usernames"
(commands configurable in the config file)::

      - console: start console login
      - exit: exit SLiM (drop to tty)
      - halt: halt the system
      - reboot: reboot the system
  	  - Pressing the _F1_ keys 
	    steps through available X session / Window Managers
	  - Pressing the _F11_ key 
	    executes a *user-specified command*.
    
The default is to take a screenshot if the 'scrot'
program is available.
(This is configurable in the /etc/slim.conf file)


CONFIGURATION
-------------

/usr/etc/slim.conf is the main configuration file.
Options are explained in the file itself

THEMES
------

See [THEMES](./THEMES.md)

COPYRIGHT
---------

::

     SLiM is copyright (c) 2004-06 by Simone Rota, Johannes Winkelmann,
     Nobuhiro Iwamatsu and is available under the GNU General Public
     License.
     See the COPYING file for the complete license.

     Image handling code adapted and extended from xplanet 1.0.1,
     copyright (c) 2002-04 by Hari Nair

     Login.app is copyright (c) 1997, 1998 by Per Liden and is
     licensed through the GNU General Public License.


     # md and rst compliant formatting.  2017 blame:PeteGozz

