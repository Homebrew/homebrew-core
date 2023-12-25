class ZshGitPrompt < Formula
  desc "Informative git prompt for zsh"
  homepage "https://github.com/zsh-git-prompt/zsh-git-prompt/"
  url "https://github.com/zsh-git-prompt/zsh-git-prompt/archive/refs/tags/v0.6.tar.gz"
  sha256 "b28a8249797b92b25e3c3156dc99153548a5b0877d2e6aa20be15caa719dcea2"
  license "MIT"
  head "https://github.com/zsh-git-prompt/zsh-git-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4fa3836434d56704bd03f88f3e45557cac6e12cb6e17cc251635ecdcbc431eb"
  end

  uses_from_macos "zsh"

  def install
    prefix.install Dir["*.sh"]
    (prefix/"shell").install Dir["shell/*.sh"]
    (prefix/"utils").install Dir["utils/*.sh"]
    (prefix/"python").install Dir["python/*.py"]
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

    # return code 255, apparently due syntax err in v0.6 zshrc.sh.
    # This may exit cleanly in the future.
    assert_match shell_output("git branch").chomp, shell_output("zsh -c '#{zsh_command}'", 255)
  end
end
