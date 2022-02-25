# dotfiles

User-specific application configuration.

## Install

```sh
$ git clone git@github.com:jaredhanson/dotfiles.git ~/.dotfiles
```

## Usage

#### Setting up a new macOS system


Because these dotfiles are stored on GitHub, they first need to be cloned to the
local system.  But in order to do this, the local system needs access to GitHub.

This can be done by [generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
for the new system.

```
$ ssh-keygen -t ed25519 -C "jaredhanson@macbook-pro-2021.local"
```

```sh
$ cd ~/.dotfiles/brew
$ make install

$ cd ~/.dotfiles/stow
$ make install
```
