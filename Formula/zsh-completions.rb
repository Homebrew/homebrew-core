class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.23.0.tar.gz"
  sha256 "47f3beb9484634f0a7226a3d43f16c532fe12ed47f1557e8b8321dbb4865fb58"

  head "https://github.com/zsh-users/zsh-completions.git"

  bottle :unneeded

  def install
    pkgshare.install Dir["src/_*"]
  end

  def caveats
    <<-EOS.undent
    To activate these completions, add the following to your .zshrc:

      fpath=(#{HOMEBREW_PREFIX}/share/zsh-completions $fpath)

    You may also need to force rebuild `zcompdump`:

      rm -f ~/.zcompdump; compinit

    Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
    to load these completions, you may need to run this:

      chmod go-w '#{HOMEBREW_PREFIX}/share'
    EOS
  end

  test do
    (testpath/".zshrc").write <<-EOS.undent
      fpath=(#{HOMEBREW_PREFIX}/share/zsh-completions $fpath)
      autoload -U compinit
      compinit
    EOS
    system "/bin/zsh", "--login", "-i", "-c", "which _ack"
  end
end
