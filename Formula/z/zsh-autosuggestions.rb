class ZshAutosuggestions < Formula
  desc "Fish-like fast/unobtrusive autosuggestions for zsh"
  homepage "https://github.com/zsh-users/zsh-autosuggestions"
  url "https://github.com/zsh-users/zsh-autosuggestions/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ccd97fe9d7250b634683c651ef8a2fe3513ea917d1b491e8696a2a352b714f08"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "56550795abab132ef15f7dd1ec2632e0db3a87c3234c0db5ce6d17f03137b7f4"
  end

  uses_from_macos "zsh" => :test

  def install
    pkgshare.install "zsh-autosuggestions.zsh"
  end

  def caveats
    <<~EOS
      To activate the autosuggestions, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match "history",
      shell_output("zsh -c '. #{pkgshare}/zsh-autosuggestions.zsh && echo $ZSH_AUTOSUGGEST_STRATEGY'")
  end
end
