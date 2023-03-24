class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.34.0.tar.gz"
  sha256 "21b6c194b15ae3992f4c2340ab249aa326a9874d46e3130bb3f292142c217fe2"
  license "MIT-Modern-Variant"
  head "https://github.com/zsh-users/zsh-completions.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "513586906b397bfcd70897487fe13b8104188ecd7de04c39da9dfbacbc78ecc6"
  end

  uses_from_macos "zsh" => :test

  def install
    inreplace "src/_ghc", "/usr/local", HOMEBREW_PREFIX
    zsh_completion.install Dir["src/_*"]
  end

  def caveats
    <<~EOS
      To activate these completions, add the following to your .zshrc:

        if type brew &>/dev/null; then
          FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

          autoload -Uz compinit
          compinit
        fi

      You may also need to force rebuild `zcompdump`:

        rm -f ~/.zcompdump; compinit

      Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
      to load these completions, you may need to run this:

        chmod -R go-w '#{HOMEBREW_PREFIX}/share/zsh/site-functions'
    EOS
  end

  test do
    (testpath/"test.zsh").write <<~EOS
      fpath=(#{zsh_completion} $fpath)
      autoload _tox
      which _tox
    EOS
    assert_match(/^_tox/, shell_output("zsh test.zsh"))
  end
end
