class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.4.1.tar.gz"
  sha256 "c544fbd6745e6e9e9700fb29e51f26426638691ce3e2cdca2b2adbb3a5b9d220"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab96741f81834122b5e047c6613a33b72d0736669410eaf0a0d9c665dcfa6a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12597e35e63f91f958972c048a381e484401e18fdd2ccbfe469a53380e4bba6e"
    sha256 cellar: :any_skip_relocation, monterey:       "48bf0fbcf0965a42cc0121b4b605dbf09c60649da15bed272ace997dd88c5d99"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c3f51db58f7ab8d93b55446efc43cdbadbe6def10dec7d5bde09ee88160c0dc"
    sha256 cellar: :any_skip_relocation, catalina:       "6b002aa2cbe91154a08c3abbcedd5d3dc1a320b3ac9b6fa99684da5b1bf6da6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6431a687906077bea26122b30e593a26aff7f356d6c4e7a087753b3c4ee27da"
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
