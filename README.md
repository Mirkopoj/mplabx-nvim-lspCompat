# mplabx-nvim-lspCompat

A nvim plugin that will automatically create a compile_flags.txt file for clang compatibility with XCx headers.

Currently it only supports XC8 and XC16 toolchains. I'll be adding XC32 support eventually.

## Instalation

This plugin depend on xml2lua.
I couldn't get Packer rocks flag to work, so my current hacky solution was to compile luarocks for lua 5.1.

```
git clone https://github.com/luarocks/luarocks.git
cd luarocks
./configure --lua-version=5.1 --versioned-rocks-dir
make build
sudo make install
cd
sudo luarocks install xml2lua
```

Then just add this plugin to your package manager

Packer 
```lua
use 'Mirkopoj/mplabx-nvim-lspCompat'
```

Vim-Plug
```lua
Plug 'Mirkopoj/mplabx-nvim-lspCompat'
```

## Usage

Just add this line to your nvim config and whenever you open a Mplabx project from nvim it will recognize it and create the file automaticaly, if it hasn't allready.
```lua
require("mplabx-nvim-lspcompat")
```
