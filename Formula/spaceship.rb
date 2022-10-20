class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.6.1.tar.gz"
  sha256 "dc0238b02bbb510f5c21b26d37cbb28f3e6647bc15c56bcd3ab838b431439cf3"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8067385865d6c89f0ae875e2f6d0aa6391d15da503ef8c9ab5f1272f5df717"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6ee624385ce1475d5d9e98413cf0439f269f466d88ec5dc31713ab3e59c7a3d"
    sha256 cellar: :any_skip_relocation, monterey:       "b897c232528c9c5f2ad247e2157db888af51060d247335b435679338dec939f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a6fafa29d3b1b4f24df42f22607d501ef5ce5fdda40532ada312ef48b6e95c4"
    sha256 cellar: :any_skip_relocation, catalina:       "72e14c50a7d4992dc01180eea0451ffa310146098ee55dc5ddddacd3e30effba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "549864022f54235267304a2183da50df9302fbcf94e7169ee39a61bc8ccfbee1"
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
