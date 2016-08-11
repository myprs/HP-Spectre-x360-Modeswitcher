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
BINDIR="/usr/bin/"
MANUALSCRIPT="$BINDIR/hp-spectre-x360-switchmode"

pushd . >/dev/null 

cd "$PACKDIR"

function cleanup () {

	popd >/dev/null

}

# create /etc Structures
echo "DEBUG: create /etc structures"

mkdir -p "$CONFDIR/script.d"
chown -R root:root "$CONFDIR" 
chmod -R u=rwx,g=rx,o=rx "$CONFDIR"

# copy scripts to scriptdir
echo "DEBUG: copy scripts to scriptdir"

cp -r "$SRCDIR$CONFDIR/"* "$CONFDIR/."
chown root:root "$CONFDIR/script.d/"*  
chmod u=rwx,g=rw,o=rw "$CONFDIR/script.d/"*  

# moved creation of softlinks to the scripts into package scripts

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


# install script to directly call the actual script by hand
echo "DEBUG: install call binary"
cp -r "$SRCDIR$MANUALSCRIPT" $BINDIR/$MANUALSCRIPT
chown -R root:root $MANUALSCRIPT
chmod -R u=rwx,g=rx,o=rx $MANUALSCRIPT



# run  mode switching script on specific key presses
echo "DEBUG: install key hooks"

echo "DEBUG: cleanup"
cleanup


