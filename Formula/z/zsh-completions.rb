class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.35.0.tar.gz"
  sha256 "811bb4213622720872e08d6e0857f1dd7bc12ff7aa2099a170b76301a53f4fbe"
  license "MIT-Modern-Variant"
  head "https://github.com/zsh-users/zsh-completions.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a9005c599c91337f5d8689ae0f725f2d204f123dcd0aef68ee4279ba27eaf94"
  end

  uses_from_macos "zsh" => :test

  def install
    inreplace "src/_ghc", "/usr/local", HOMEBREW_PREFIX
    # We install this into `pkgshare` to avoid conflicts
    # with completions installed by other formulae. See:
    #   https://github.com/Homebrew/homebrew-core/pull/126586
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
      to load these completions, you may need to run these commands:

        chmod go-w '#{HOMEBREW_PREFIX}/share'
        chmod -R go-w '#{HOMEBREW_PREFIX}/share/zsh'
    EOS
  end

  test do
    (testpath/"test.zsh").write <<~EOS
      fpath=(#{pkgshare} $fpath)
      autoload _ack
      which _ack
    EOS
    assert_match(/^_ack/, shell_output("zsh test.zsh"))
  end
end
