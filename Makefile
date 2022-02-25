brew:
	echo "Installing homebrew"
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

stow:
	brew install stow

.PHONY: bash
bash:
	stow $(STOWFLAGS) --dotfiles bash

.PHONY: posix
posix:
	stow $(STOWFLAGS) --dotfiles posix

.PHONY: node
node:
	stow $(STOWFLAGS) --dotfiles node
