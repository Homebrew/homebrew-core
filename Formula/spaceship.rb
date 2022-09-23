class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.5.0.tar.gz"
  sha256 "80541a628f63e0317ab88a08f0d860dfeaa294026389b54b7b0b5f704d180165"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04eae4f2e374970be5ed3eb4a3d148f8ba4555564c96cd5bd229c0ff93207ac3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51ab8061dd30dc958f0da4b946b1a95658c16408ffeb295f2aca426b227a46e6"
    sha256 cellar: :any_skip_relocation, monterey:       "c69522823561f38b71958e96e56b9a6eb11f71233bf409daac16fb24b08c7113"
    sha256 cellar: :any_skip_relocation, big_sur:        "618bd82f6b12e3807ab5203a455e5512ec52c7e085424e05ef37ea2cd6d75263"
    sha256 cellar: :any_skip_relocation, catalina:       "a40f90d29fd3157be348923ae92e62bc6f818408e7f7af6156362843352c01f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b4289fbe0959beaf7bc7bee73326c20a5eef18ae0822100d2bb418c059c0cd"
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
