class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/refs/tags/0.35.0.tar.gz"
  sha256 "811bb4213622720872e08d6e0857f1dd7bc12ff7aa2099a170b76301a53f4fbe"
  # The main/default license is the same as Zsh (MIT-Modern-Variant); however,
  # the majority of completions are BSD-3-Clause. The remainder is mostly MIT.
  # A few completions use other licenses and are specifically noted below.
  license all_of: [
    "MIT-Modern-Variant",
    "BSD-3-Clause",
    "MIT",
    "Apache-2.0", # _cf, _hledger
    "ISC", # _rfkill
    "NCSA", # _include-what-you-use
  ]
  head "https://github.com/zsh-users/zsh-completions.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "98d3985c4c7883eceb5136fef89f1e169067fe290eb540efeb5fec4ace5396be"
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
    (testpath/"test.zsh").write <<~SHELL
      fpath=(#{pkgshare})
      autoload -R _afew
      which _afew
    SHELL
    assert_match(/^_afew/, shell_output("zsh test.zsh"))
  end
end
