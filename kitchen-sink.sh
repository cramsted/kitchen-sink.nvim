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
nvimbuildalias="alias nvim='$scriptdir/local/nvim/bin/nvim'"
dockerenv=".docker.env"

Help()
{
   # Display Help
   echo "A Neovim offline installation creator, for those times you need to bring everything and the kitchen sink."
   echo
   echo "Syntax: kitchen-sink.sh [-h|p|u]"
   echo "options:"
   echo "h     [help] print this help text"
   echo "p     [package] pack custom neovim config and create tar.gz file with everything needed for an offline installer in this directory"
   echo "t     [test] create an untarred installer that can easily be tested inside a docker container."
   echo "             It also generates a .env file with the username, uid and gui of the current user that docker-compose uses to build and run containers"
   echo "             that share the same user credentials and home directory as the current user." 
   echo "u     [unpackage] unpack contents of the current directory into a useable form"
   echo "c     [clean] clean up the test installer"
   echo
}

error()
{
   clean
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
  # wget -P $tmpdir https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.tar.gz || error
  git clone https://github.com/neovim/neovim $tmpdir/nvim

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
     clean
  else
     touch $dockerenv
     echo MY_UID="$(id -u)" >> $dockerenv
     echo MY_GID="$(id -g)" >> $dockerenv
     echo USER="$USER" >> $dockerenv
  fi
}

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


  # echo "Untarring neovim..."
  # echo ""
  # tar xvzf "$scriptdir/$nvimfile"

  echo "Building neovim..."
  echo ""
  cd nvim || error
  git checkout stable || error
  make CMAKE_BUILD_TYPE=Release || error

  isInFile=$(cat ~/.bashrc | grep -c "alias nvim")
  if [ $isInFile -lt 1 ]; then
    echo $nvimalias >> ~/.bashrc
  fi

  ######################################## 
  # Add custom setup steps here
  ######################################## 
}

clean() {
 rm -rf $tmpdir
}

while getopts ":hptuc" option; do
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
      c) # clean test installer
         clean
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
