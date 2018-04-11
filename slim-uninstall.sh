#!/bin/bash

if [ ! -d ./build/ ] || [ ! -r  build/install_manifest.txt ]; then
    cat <<EOF
    We need the ./build/install_manifest .
               That is:
        You will have to (re)make slim 
           and install slim
               before 
           you can remove slim.
     
       Please see the INSTALL file.
EOF
    exit 0
fi


for F in $(cat build/install_manifest.txt) ;
do echo "removing $F" ;
   if [ -w $F ] ; then
       rm -fv $F ;
   elif [ ! -a $F ]; then
       echo "$F is not installed"
       
   else echo "$F is not for you to remove" ;
   fi ;
done
# -u root is enough to miss _this_ script on renames 
test $(pgrep -u root -a  slim) && echo "Warning Slim is still running"
# leave this for the user
#/etc/init.d/slim stop || true
