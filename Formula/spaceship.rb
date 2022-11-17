class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.10.1.tar.gz"
  sha256 "6c55a2ff66df95425c5fe7cb93a85c52b5b2959f1e246984580b0b291e02089a"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc9bd5c5f8b093ad6da8b02786140beb5cb787779505a0612b95ccd526f6a1db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c46d97844abdf3d12c846998af399ef7cc65d50862c57d44ed08e6fbaa8c55a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c3a09e6da9a5c18d0043752246336da01409c2dcc6feb60cfefab87c3bb3ecc"
    sha256 cellar: :any_skip_relocation, ventura:        "d6611b833f9aa5d452c5d6a572ff2c8416df5f8629ecfb7511fdffcf07ab52bb"
    sha256 cellar: :any_skip_relocation, monterey:       "fae09e61ebfacde1faed1e37bb7492df1657ab42103d31535a26ee5a815231e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "07072e4349852499ddb5a1a09e4a58ad888982626a6585f69b0cc3da6de5997d"
    sha256 cellar: :any_skip_relocation, catalina:       "c0447a20740bc376f9bfd523bb416b5ed7568e2dbe28d58d1c256b4666e0b9c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "398dbb6574306fdc47e3a1eed71e2cb017997ee4e9cd30640acbf6269993c41b"
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
