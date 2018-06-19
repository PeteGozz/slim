#!/bin/bash


# this simply (crudely)
# backup /etc/X11/default-display-manager
# some distros have an automated process for this
grep /usr/local/bin/slim /etc/X11/default-display-manager > /dev/null
if [ "$?" != "0" ]; then
    cp -p /etc/X11/default-display-manager /etc/X11/default-display-manager-$(date +%s)
    if [ "$?" != "0" ]; then
	echo -e "Unable to write a backup file\naborting $(basename 0)"
	exit 1
    else
	echo -e "/usr/local/bin/slim" > /etc/X11/default-display-manager
    fi
else
    echo -e "/usr/local/bin/slim is set as default display manager"
fi

if [ ! -x  /etc/init.d/slim.sysv ]; then
    chmod +x /etc/init.d/slim.sysv
fi

for S in slim slim.init ; do
    if [ -e /etc/init.d/$S ];
    then
	echo -e "Note:\t Disabling existing /etc/init.d/$S"
	/etc/init.d/$S stop
	update-rc.d -f $S remove
	chmod -x /etc/init.d/$S
	mv  /etc/init.d/$S  /etc/init.d/${S}.disabled
    else
	echo -e "OK:\t /etc/init.d/$S was not found."
    fi
done


if [ -x update-rc.d ]; then
    initok=0    
    update-rc.d defaults slim.sysv || initok=1 \
	echo "check system init script is activated"
    
fi

ls -lah /etc/init.d/slim*
service slim.sysv stop
service slim.sysv start

exit $initok

