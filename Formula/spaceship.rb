class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.6.1.tar.gz"
  sha256 "dc0238b02bbb510f5c21b26d37cbb28f3e6647bc15c56bcd3ab838b431439cf3"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb2f87d82d788dfa4505fa466f5569c95dccd68d9565ddc421c7b8665c080505"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "385bf73cdfcc69eaf83a4123ffd689330537c0ad64752837f154546e3979f235"
    sha256 cellar: :any_skip_relocation, monterey:       "33300e7208e18568d21210b9d9153618ba187586916cd5efd652f7ff5f7e8dad"
    sha256 cellar: :any_skip_relocation, big_sur:        "b912426162ee4dd4416b63220079dc10f3aecc67efd455d67976cdf1afbe7f1e"
    sha256 cellar: :any_skip_relocation, catalina:       "801f2d618c9561fb14abd9b23c7b18225570185c50af8f23b6b91adee29cbe48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f6d80631d5055e5b3dc8bc00637a6b2f034fd2dc4b6e09d4e69924cbbfc746"
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
