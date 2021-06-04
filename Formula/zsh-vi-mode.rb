class ZshViMode < Formula
  desc "Better and friendly vi(vim) mode plugin for ZSH"
  homepage "https://github.com/jeffreytse/zsh-vi-mode"
  url "https://github.com/jeffreytse/zsh-vi-mode/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "4ee239d1b4645fa61173ccfdd5d0f9f91279607d47a1ca6edd58c84c2cd0fd5c"
  license "MIT"
  head "https://github.com/jeffreytse/zsh-vi-mode.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9c566d9654f1dd04cb64515b937ac18ca47c0ceb2b30587ea93e371f4e977a8"
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
