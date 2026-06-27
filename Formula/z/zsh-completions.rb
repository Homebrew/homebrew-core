class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/refs/tags/0.36.0.tar.gz"
  sha256 "5aa68be2999a7be2eb56de8e4acff8f3bba4a66b9acbb233752536857408fb2e"
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

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b049deb74035408154c97b57d9834510d55503c64b172b8a89937b7e6118cca5"
  end

  uses_from_macos "zsh" => :test

  def install
    inreplace "src/_ghc", "/usr/local", HOMEBREW_PREFIX
    inreplace "src/_gio", "/usr/local/share", HOMEBREW_PREFIX/"share"
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
