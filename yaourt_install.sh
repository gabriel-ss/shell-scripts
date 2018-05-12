#! /bin/bash


BUILDDIR="/tmp/yaourt_build"
PKGLIST="package-query yaourt"



installPackage(){
	PKGNAME=$1
	
	cd $BUILDDIR
	
	# Downloads the latest snapshot of the package...
	curl -o ${PKGNAME}.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/${PKGNAME}.tar.gz
	# ...extracts it's contents...
	tar -xzf ${PKGNAME}.tar.gz
	# ...and changes the ownership of the extracted directory allowing 'nobody' to access it.
	chown nobody:nobody "./$PKGNAME"
	
	cd $PKGNAME
	#Builds the package as nobody and installs it
	sudo -u nobody makepkg
	pacman -U --needed --noconfirm ./*.pkg.tar.xz
}



# Installs curl and tar if they are not already installed
pacman -S --needed --noconfirm yajl curl tar

mkdir $BUILDDIR
for PKG in $PKGLIST
do
	installPackage $PKG
done


rm -rf $BUILDDIR
