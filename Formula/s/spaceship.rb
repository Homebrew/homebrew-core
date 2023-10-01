class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.14.1.tar.gz"
  sha256 "47c9a2bc1e5dd5a20f66da67d10fa577f2c13808fc4a6fb7b44583bc880b360d"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "673902d259e667ecc37c31ebd7ced50055292debec926b34b741f332d8323ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee64bf600f7555c7ebfd58b0dbd7ae0713cf8138cc223d58f597a04f9ea05554"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91a4d658941e19b4af5b695a4a6ac6703afde822153c900372dd56b6f833f898"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33224e664fe8fe56ec758fbc6a9debe31bbae3db26df40b21e6a7f6ac10c52ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "44e888dc09d36e94a2300a929f974a51fe930827720b792fdf2eb51748ec891d"
    sha256 cellar: :any_skip_relocation, ventura:        "0b3682c21ec8fc71505f1c5c9997d8eeea122da7a22b3a678e0dde33a4aaad8f"
    sha256 cellar: :any_skip_relocation, monterey:       "cffe87a1ba23fe030f54440adacd1675599897f2e30badfb9650b604428a953b"
    sha256 cellar: :any_skip_relocation, big_sur:        "798045359bca11e447872eee045b7db5cbce8bd20f6699b3223072204c9021f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3996b44524ffe33581a15e381ea8e3ac3af8237fee7a874b3a199c405e7671ed"
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
