class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.33.0.tar.gz"
  sha256 "39452d383d0718aa2c830edba1aa32f0ee1e40002ef6932d88699a888bd58c29"
  license "MIT-Modern-Variant"
  revision 1
  head "https://github.com/zsh-users/zsh-completions.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eab228532a15b1c8eddfd38f46306cf723e6f331d38c8874d0305d6fe888ab70"
  end

  def install
    inreplace "src/_ghc", "/usr/local", HOMEBREW_PREFIX
    pkgshare.install Dir["src/_*"]
  end

  def caveats
    <<~EOS
      To activate these completions, add the following to your .zshrc:

        if type brew &>/dev/null; then
          FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

          autoload -Uz compinit
          compinit
        fi

      You may also need to force rebuild `zcompdump`:

        rm -f ~/.zcompdump; compinit

      Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
      to load these completions, you may need to run this:

        chmod -R go-w '#{HOMEBREW_PREFIX}/share/zsh'
    EOS
  end

  test do
    (testpath/"test.zsh").write <<~EOS
      fpath=(#{pkgshare} $fpath)
      autoload _ack
      which _ack
    EOS
    assert_match(/^_ack/, shell_output("/bin/zsh test.zsh"))
  end
end
