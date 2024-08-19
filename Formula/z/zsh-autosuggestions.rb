class ZshAutosuggestions < Formula
  desc "Fish-like fast/unobtrusive autosuggestions for zsh"
  homepage "https://github.com/zsh-users/zsh-autosuggestions"
  url "https://github.com/zsh-users/zsh-autosuggestions/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ccd97fe9d7250b634683c651ef8a2fe3513ea917d1b491e8696a2a352b714f08"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41af0bbd2d46b3e09d821e1c4702c2e224ce214d436fc9a09ca7e6fec32ebfa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41af0bbd2d46b3e09d821e1c4702c2e224ce214d436fc9a09ca7e6fec32ebfa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41af0bbd2d46b3e09d821e1c4702c2e224ce214d436fc9a09ca7e6fec32ebfa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b431cf90fc39ec89e8f3b67aad634732ea7c4691812d2169e39a89deb6246c9"
    sha256 cellar: :any_skip_relocation, ventura:        "5b431cf90fc39ec89e8f3b67aad634732ea7c4691812d2169e39a89deb6246c9"
    sha256 cellar: :any_skip_relocation, monterey:       "41af0bbd2d46b3e09d821e1c4702c2e224ce214d436fc9a09ca7e6fec32ebfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41af0bbd2d46b3e09d821e1c4702c2e224ce214d436fc9a09ca7e6fec32ebfa6"
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
