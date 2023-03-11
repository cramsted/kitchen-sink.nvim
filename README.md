# kitchen-sink.nvim

Ever find yourself struggling to get your kitted out neovim configuration on a computer without internet access? Or maybe a work machine that is behind a proxy server that breaks all of the github URLs that your package manager relies on? Me too! Introducing `kitchen-sink.nvim`, a script that packs up everything and turns it into a portable installer for your neovim config!

**Note:** Consider this script a template instead of a general solution. Dev environments and tools vary widely enough that it would be insanity to write a one-size-fits-all solution. It is strongly encouraged that you fork this repo and customize it to your own neovim config.

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
./kitchen-sink.sh -u
```
