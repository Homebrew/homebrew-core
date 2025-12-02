class ZshSystemClipboard < Formula
  desc "System clipboard key bindings for Zsh Line Editor with vi mode"
  homepage "https://github.com/kutsan/zsh-system-clipboard"
  url "https://github.com/kutsan/zsh-system-clipboard/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ff048067f018578c380b026952445d3f625160b70475b48827749fb4abb2c886"
  license "GPL-3.0-only"
  head "https://github.com/kutsan/zsh-system-clipboard.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0020905311350f9aa13a1a35b0632667fe6d4e3bcbbb69110add37eb2ce83b16"
  end

  uses_from_macos "zsh" => [:build, :test]

  on_linux do
    depends_on "xclip" => :test
  end

  def install
    pkgshare.install "zsh-system-clipboard.zsh"
  end

  def caveats
    <<~EOS
      To activate the system clipboard integration, add the following to your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-system-clipboard/zsh-system-clipboard.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    # zsh-system-clipboard.zsh fails on Linux if $DISPLAY is unset.
    # Its value is not further relevant for the test however.
    ENV["DISPLAY"] = "mock" if OS.linux?
    system("zsh -c 'set -e; . #{pkgshare}/zsh-system-clipboard.zsh'")
  end
end
