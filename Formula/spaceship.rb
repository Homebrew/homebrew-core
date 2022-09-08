class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.2.6.tar.gz"
  sha256 "c934ae64828be6f62b0500aeab7db7bea8e15bb358ec6dcfdc9fda4a4ff2afa5"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98ab42acec2691aca215f7c3efab37bc2c1300c9ed96c30e6cc2cb03087ef6bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9655ef22b7c9bb400274db563b2e4f79d1afcf7a0b56c1665180d6b62b63fb37"
    sha256 cellar: :any_skip_relocation, monterey:       "631a0cb0abe726fdf6053f52a344b0a47fc9fff345e4b24e398cb56afaaa0e74"
    sha256 cellar: :any_skip_relocation, big_sur:        "1640d98abc41d9781ac3f7d7975aea8d016fec42f126dcbfd2419cbb5587768e"
    sha256 cellar: :any_skip_relocation, catalina:       "e9e823b8ba27e119bce89b86057113048db70bdb1bf210323934a640fca84279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c3638e08ab4e7468cab3dfc8a6f0fa0e6c49a11d733a83cb356e1e266004e98"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end
