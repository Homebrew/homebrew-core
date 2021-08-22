class ZshViMode < Formula
  desc "Better and friendly vi(vim) mode plugin for ZSH"
  homepage "https://github.com/jeffreytse/zsh-vi-mode"
  url "https://github.com/jeffreytse/zsh-vi-mode/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "d16814693099dcc6f47afe3e5575af539a7aee1071f3f532c233800918722398"
  license "MIT"
  head "https://github.com/jeffreytse/zsh-vi-mode.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75cb847e1c112353962727000722ad1bb21184ab954a9a6931caeb8cd26401c4"
  end

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
