class ZshGitPrompt < Formula
  desc "Informative git prompt for zsh"
  homepage "https://github.com/olivierverdier/zsh-git-prompt"
  url "https://github.com/olivierverdier/zsh-git-prompt/archive/v0.5.tar.gz"
  sha256 "87e5a908369f402e975426ffd61a8800f1c04c0a293f1d4015a6fb1f4408e77d"

  bottle :unneeded

  def install
    prefix.install Dir["*.{sh,py}"]
  end

  def caveats; <<-EOS.undent
    First, make sure zsh-git-prompt is loaded from your .zshrc:
      source "#{opt_prefix}/zshrc.sh"

    Then include $(git_super_status) in your PROMPT or RPROMPT, e.g.:
      PROMPT='%B%m%~%b$(git_super_status) %# '
    EOS
  end

  test do
    system "git", "init"
    zsh_command = ". #{opt_prefix}/zshrc.sh && git_super_status"
    assert_match "master", shell_output("zsh -c '#{zsh_command}'")
  end
end
