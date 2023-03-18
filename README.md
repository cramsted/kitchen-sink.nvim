# kitchen-sink.nvim

Getting a custom neovim config running on a computer without a internet access sucks. That's why I made `kitchen-sink.nvim`: the offline custom neovim installer creator.

**Note:** Consider this repo a template instead of a general solution. Dev environments and tools vary widely enough that it would be insanity to write a one-size-fits-all solution. It is strongly encouraged that you fork this repo and customize it to your own needs.

# Requirements

## Build computer

* source neovim config that works for the current user
  * **Note:** neovim is not actually required. The installer will download the latest version of neovim and it will be included in the installer.
* bash
* rsync
* wget
* tar
* Optional (see [Testing](#Testing):
  * docker
  * docker-compose

## Target computer

* Unix environment
* tar

# Usage

## Packing

Package everything into a `nvim-installer-<dateime>.tar.gz` that is saved in the local directory.

```bash
./kitchen-sink.sh -p
```

## Installation

Copy the `nvim-installer-<dateime>.tar.gz` to the offline computer and run the following to install it:

```bash
tar xvzf nvim-installer-<dateime>.tar.gz
cd kitchen-sink
# the same script that is used to create the installer is included in the installer,
# and is also used to unpack the installer
./kitchen-sink.sh -u
```

# Testing

Nothing is worse than making changes to your neovim config only to find that it throws errors after you have gone through the hassle of copying it over to an offline server. To help find these problems before you go all that trouble, an example `Dockerfile` and `docker-compose.yml` file are provided to allow for emulation of the installation target's environment.

## How to test

```bash
./kitchen-sink.sh -t # create a untarred version of the installer that the docker container can mount
docker-compose build
docker-compose up -d
docker exec -it u20.04 /bin/bash

# now that you're inside the docker container, run some tests
nvim # make sure you don't have any startup errors

# you can rerun kitchen-sink.sh -t to update your installer as you fix bugs in your source neovim config
# when you are done, run the following:
exit # leave container
docker-compose down # shutdown the container, otherwise it will just sleep in the background for forever
./kitchen-sink.sh -c # maunually clean up the test version of the installer
```
