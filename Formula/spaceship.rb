class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.11.1.tar.gz"
  sha256 "19d9ed21f4b44fe4d1ca7808519a2c61e4eddef58564bea67b0e0a76c5aef177"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5891a28673681ca3f1655042fb8ec24f77f295815159466d3fb153ff92ff3ebb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ac943ef5eaa99591e8be98edf194bfab30239dd076c807fd94c56e8141854cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5b6a355cc38b383975aeaafc349fb83503fe25a9b2f80be96d1abbf5f0a2bb7"
    sha256 cellar: :any_skip_relocation, ventura:        "912ceec9974d1956b64845bde66ebf8a741283c4adc98109ba9de895a022a27a"
    sha256 cellar: :any_skip_relocation, monterey:       "2634ea7fd084db7686c35062f98f95be433f67e12a66be77f83722dd3579156c"
    sha256 cellar: :any_skip_relocation, big_sur:        "52925ec06e65405cbd93054cdd6b6a3f208b559977147d145fed5e5ea40185c8"
    sha256 cellar: :any_skip_relocation, catalina:       "b1666961076b140c6045164421ea8a2b3af13914eabea20f890e759cad80c854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d2fffa0b787ea8935f343c494a38b3c9599745bffa8b17503d079e50013a9fa"
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
