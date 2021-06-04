class ZshAutosuggestions < Formula
  desc "Fish-like fast/unobtrusive autosuggestions for zsh"
  homepage "https://github.com/zsh-users/zsh-autosuggestions"
  url "https://github.com/zsh-users/zsh-autosuggestions/archive/v0.6.4.tar.gz"
  sha256 "0b6e251ced5fd7b5b78ea01f798ecc1b46169743a717567f0ec0a21198a372e8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e204984ca8abc4d6ca97b0b66acfd0136c3bfac10aba59f55b6f3cc3b189934e"
  end

  def install
    pkgshare.install "zsh-autosuggestions.zsh"
  end

  def caveats
    <<~EOS
      To activate the autosuggestions, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      You will also need to force reload of your .zshrc:

        source ~/.zshrc
    EOS
  end

  test do
    assert_match "history",
      shell_output("zsh -c '. #{pkgshare}/zsh-autosuggestions.zsh && echo $ZSH_AUTOSUGGEST_STRATEGY'")
  end
end
