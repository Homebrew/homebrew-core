class ZshGitPrompt < Formula
  desc "Informative git prompt for zsh"
  homepage "https://github.com/olivierverdier/zsh-git-prompt"
  url "https://github.com/olivierverdier/zsh-git-prompt/archive/refs/tags/v0.5.tar.gz"
  sha256 "87e5a908369f402e975426ffd61a8800f1c04c0a293f1d4015a6fb1f4408e77d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4fa3836434d56704bd03f88f3e45557cac6e12cb6e17cc251635ecdcbc431eb"
  end

  def install
    prefix.install Dir["*.{sh,py}"]
  end

  def caveats
    <<~EOS
      Make sure zsh-git-prompt is loaded from your .zshrc:
        source "#{opt_prefix}/zshrc.sh"
    EOS
  end

  test do
    system "git", "init"
    zsh_command = ". #{opt_prefix}/zshrc.sh && git_super_status"
    assert_match "master", shell_output("zsh -c '#{zsh_command}'")
  end
end
