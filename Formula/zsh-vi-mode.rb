class ZshViMode < Formula
  desc "Better and friendly vi(vim) mode plugin for ZSH"
  homepage "https://github.com/jeffreytse/zsh-vi-mode"
  url "https://github.com/jeffreytse/zsh-vi-mode/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e6a5c56fd4b594035916057d3def799eeffcaadd2e5eda26299d724ad692693d"
  license "MIT"
  head "https://github.com/jeffreytse/zsh-vi-mode.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b4099bf0e0a3915013d1b3494d2b84a89525408940a8fcb5f4f88b2e580654b"
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
