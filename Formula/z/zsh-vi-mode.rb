class ZshViMode < Formula
  desc "Better and friendly vi(vim) mode plugin for ZSH"
  homepage "https://github.com/jeffreytse/zsh-vi-mode"
  url "https://github.com/jeffreytse/zsh-vi-mode/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "03e1b5f0eef89afa834416bd2751584093b929506e11867fbabf9a7f9e57452a"
  license "MIT"
  head "https://github.com/jeffreytse/zsh-vi-mode.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac68701f582b67a709e3a7c767418c7e819bd19fb4fd6811ce0a6991a7ff6bd6"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "zsh-vi-mode.zsh"
    pkgshare.install "zsh-vi-mode.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate the zsh vi mode, add the following line to your .zshrc:
        source #{opt_pkgshare}/zsh-vi-mode.plugin.zsh
    EOS
  end

  test do
    assert_match "zsh-vi-mode",
      shell_output("zsh -c '. #{pkgshare}/zsh-vi-mode.plugin.zsh && zvm_version'")
  end
end
