class ZshGitPrompt < Formula
  desc "Informative git prompt for zsh"
  homepage "https://github.com/zsh-git-prompt/zsh-git-prompt"
  url "https://github.com/zsh-git-prompt/zsh-git-prompt/archive/refs/tags/v0.6.tar.gz"
  sha256 "b28a8249797b92b25e3c3156dc99153548a5b0877d2e6aa20be15caa719dcea2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4fa3836434d56704bd03f88f3e45557cac6e12cb6e17cc251635ecdcbc431eb"
  end

  uses_from_macos "zsh"

  def install
    prefix.install Dir["*.sh"] # for now, only zsh.sh
    prefix.install "shell"
    prefix.install "python"
    # could also install "haskell" folder? but why
    # prefix.install "haskell"
  end

  def caveats
    <<~EOS
      Make sure zsh-git-prompt is loaded from your .zshrc:
        source "#{opt_prefix}/zshrc.sh"
    EOS
  end

  test do
    system "git", "init", "--initial-branch=main"
    # commit something, so we have a "clean" state
    touch "testfile"
    system "git", "add", "."
    system "git", "commit", "-m", "testcommit"
    system "git", "status"
    # `cd .` triggers directory change, so git vars are updated
    zsh_command = ". #{opt_prefix}/zshrc.sh && cd . && git_super_status"
    assert_match "main", shell_output("zsh -c '#{zsh_command}'")
  end
end
