#!/bin/bash

testFlag=false
packFlag=false
unpackFlag=false

tmpdir="/tmp/kitchen-sink"
config="$HOME/.config/nvim"
local="$HOME/.local/share/nvim"
nvimfile="nvim-linux64.tar.gz"
scriptdir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
scriptname=$( basename -- "$0"; )
scriptpath="$scriptdir/$scriptname"
installer_name="nvim-installer"
nvimalias="alias nvim='$scriptdir/nvim-linux64/bin/nvim'"

Help()
{
   # Display Help
   echo "A Neovim offline installation creator, for those times you need to bring everything and the kitchen sink."
   echo
   echo "Syntax: kitchen-sink.sh [-h|p|u]"
   echo "options:"
   echo "h     [help] print this help text"
   echo "p     [package] pack custom neovim config and create tar.gz file with everything needed for an offline installer"
   echo "t     [test package] run the pack comand"
   echo "u     [unpackage] unpack contents of the current directory into a useable form"
   echo
}

error()
{
    rm -rf $tmpdir
    exit 1
}

# TODO: include the libraries that newer versions of neovim require so that this can work on older systems
pack() {
  echo "Packing Neovim config...."
  echo ""
  mkdir -pv $tmpdir/{config,local} || error

  rsync -ravHP $config/* $tmpdir/config/ || error
  rsync -ravHP $local/* $tmpdir/local/ || error

  echo "----- Downloading most recent version of neovim"
  echo ""
  wget -P $tmpdir https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.tar.gz || error

  echo "----- Packing the installation script..."
  echo ""
  cp "$scriptpath" $tmpdir/ || error

  ######################################## 
  # Add custom files here
  ######################################## 

  if [  "$testFlag" = false ]; then
     echo "----- Creating the installer tar.gz..."
     echo ""
     tar -C $tmpdir/.. -cvzf $installer_name-$( date '+%Y%m%d%H%M%S' ).tar.gz kitchen-sink || error
     rm -rf $tmpdir
  fi
}

# TODO: fix symlinks in .local so that they match the target OS
unpack() {
  # save the old conig, just in case
  echo "Saving old configuration..."
  echo ""
  mv $config $config.bak
  mv $local $local.bak
  
  echo "Creating symlinks to config..."
  echo ""
  ln -s $scriptdir/config $config
  ln -s $scriptdir/local $local

  echo "Untarring neovim..."
  echo ""
  tar xvzf "$scriptdir/$nvimfile"

  isInFile=$(cat ~/.bashrc | grep -c "alias nvim")
  if [ $isInFile -lt 1 ]; then
    echo $nvimalias >> ~/.bashrc
  fi

  ######################################## 
  # Add custom setup steps here
  ######################################## 
}

while getopts ":hptu" option; do
   case $option in
      p) # create package
         packFlag=true
         ;;
      t) # create test package
         testFlag=true
         packFlag=true
         ;;
      u) # unpack package
         unpackFlag=true
         ;;
      h) # display Help
         Help
         exit;;
      \?) # Invalid option
         echo "Error: Invalid option"
         Help
         exit;;
      *)
         Help
         exit;;
   esac
done

if [ "$packFlag" = true ]; then
   pack
elif [ "$unpackFlag" = true ]; then
  unpack 
fi
