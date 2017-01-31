class ZshAutosuggestions < Formula
  desc "Fish-like fast/unobtrusive autosuggestions for zsh."
  homepage "https://github.com/zsh-users/zsh-autosuggestions"
  url "https://github.com/zsh-users/zsh-autosuggestions/archive/v0.3.3.tar.gz"
  sha256 "3831f0d6e37b2fba59c5a4003b7420ccb5ffc08d8f9e037ac639cff6e7962eb4"

  bottle :unneeded

  def install
    pkgshare.install "zsh-autosuggestions.zsh"
  end

  def caveats
    <<-EOS.undent
    To activate the autosuggestions, add the following at the end of your .zshrc:

      source #{HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    You will also need to force reload of your .zshrc:

      source ~/.zshrc
    EOS
  end

  test do
    assert_match "default",
      shell_output("zsh -c '. #{pkgshare}/zsh-autosuggestions.zsh && echo $ZSH_AUTOSUGGEST_STRATEGY'")
  end
end
