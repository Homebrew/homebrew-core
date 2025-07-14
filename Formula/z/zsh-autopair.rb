class ZshAutopair < Formula
  desc "Auto-close and delete matching delimiters in zsh"
  homepage "https://github.com/hlissner/zsh-autopair"
  url "https://github.com/hlissner/zsh-autopair/archive/refs/tags/v1.0.tar.gz"
  sha256 "4b6f4d20d89ea08fd239089ad4133cff5ebdb71f07f589d5e41d0814d4cf4165"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c9208ef9b9a923475ace7d3c397458eded12a4d8bb3961276d4196cc10329a0d"
  end

  uses_from_macos "zsh" => :test

  def install
    pkgshare.install "autopair.zsh"
  end

  def caveats
    <<~EOS
      To activate autopair, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-autopair/autopair.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    zsh_command = "source #{pkgshare}/autopair.zsh && echo $AUTOPAIR_PAIRS"
    assert_match "\" } ' ) ] `", shell_output("zsh -c '#{zsh_command}'")
  end
end
