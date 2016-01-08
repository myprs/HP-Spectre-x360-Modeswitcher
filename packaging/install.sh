#!/bin/bash

#
# This script is used to run under the supervision of checkinstall


# location of the installation sources
DEVDIR="/root/Develop/hp-spectre-modeswitcher"
PACKDIR="$DEVDIR/packaging"
SRCDIR="$DEVDIR/source"

# location of the instalation target directories
ETCDIR="/etc"
CONFDIR="$ETCDIR/hp-spectre-x360"
DEFAULTDIR="$ETCDIR/default"

INSTALLDIR="/usr/lib/hp-spectre-x360"

pushd . >/dev/null 

cd "$PACKDIR"

function cleanup () {

	popd >/dev/null

}

# create /etc Structures
echo "DEBUG: create /etc structures"

mkdir -p "$CONFDIR/script.d"
mkdir -p "$CONFDIR/laptop-mode"
mkdir -p "$CONFDIR/tablet-mode"
chown -R root:root "$CONFDIR" 
chmod -R u=rwx,g=rx,o=rx "$CONFDIR"

# copy scripts to scriptdir
echo "DEBUG: copy scripts to scriptdir"

cp -r "$SRCDIR$CONFDIR/"* "$CONFDIR/."
chown root:root "$CONFDIR/script.d/"*  
chmod u=rwx,g=rw,o=rw "$CONFDIR/script.d/"*  

# make softlinks to the scripts delivered
echo "DEBUG: make softlinks for laptop mode"
pushd . >/dev/null 

cd "$CONFDIR"/laptop-mode
ln -s ../script.d/template.sh 00-template 
ln -s ../script.d/flipscreen.sh 01-flipscreen 
ln -s ../script.d/touchpad.sh 01-touchpad 

echo "DEBUG: make softlinks for tablet mode"
cd "$CONFDIR"/tablet-mode
ln -s ../script.d/template.sh 00-template 
ln -s ../script.d/flipscreen.sh 01-flipscreen 
ln -s ../script.d/touchpad.sh 01-touchpad 


popd  >/dev/null 

# copy sample default conf
echo "DEBUG: copy sample default conf"
cp "$SRCDIR$DEFAULTDIR/hp-spectre-x360" "$DEFAULTDIR/hp-spectre-x360"
chown root:root "$DEFAULTDIR/hp-spectre-x360"  
chmod u=rwx,g=rw,o=rw "$DEFAULTDIR/hp-spectre-x360"  


# copy bootup script (registers keys)
echo "DEBUG: copy botup sctipts"

# make bootup script run at all runlevels
echo "DEBUG: make boot script run at all runlevels"

# install mode switching script 
echo "DEBUG: install mode switching scripts"
mkdir "$INSTALLDIR"
cp -r "$SRCDIR$INSTALLDIR/"* $INSTALLDIR/.
chown -R root:root $INSTALLDIR
chmod -R u=rwx,g=rx,o=rx $INSTALLDIR


# run  mode switching script on specific key presses
echo "DEBUG: install key hooks"

echo "DEBUG: cleanup"
cleanup


