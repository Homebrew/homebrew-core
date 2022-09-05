class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.2.1.tar.gz"
  sha256 "a6cdad0f8b340823acb731d1b63b690d0bc44c31b4bb860ed87fc1fa589e8874"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5384f8075e349091da1b7d21e32e90a7cb71d4c4b391c436619badc7e6ea3154"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dddeb5264a9f36d12d2313d1984621d8b2411d8b2d22fd732f015164887ab332"
    sha256 cellar: :any_skip_relocation, monterey:       "71787b25a9a430fd2c972ff7972779ed6948885ad993ef3f885b10b9e4005f73"
    sha256 cellar: :any_skip_relocation, big_sur:        "493357766099d139e4863e14eec2497a3cdf09e5eddfe58ec8c578e851376a18"
    sha256 cellar: :any_skip_relocation, catalina:       "b5d6ec54aba18eeb684745eac0143c8bbfb17fb6ed7b46ed3c1d69f76f90302f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce8d0c63eaf1ab2619629b65d6fbe0467f892fc6d119239f96a48dd89ca2f21"
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
