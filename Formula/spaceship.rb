class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.9.1.tar.gz"
  sha256 "b093a39aa0454ccc7efe33b7f41ae81e2b85bdcaaf395ee4d2720cf10393e9df"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f437eeeb7f7724e79b8c030c473cf7ff7ce5ceaae6082ab2b0eaaa197996cfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6f8db77339f510944ad82de8925b0fbad97e42bdc121d19e8ed549f82174b9a"
    sha256 cellar: :any_skip_relocation, monterey:       "3c5a365f4248db05a719297f2697c61f7f1e1ea648014ebdd6de1578126685dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f6ae4c0bbeac90d9e59953ba47814480673dcf82152af4976b479797b0f482c"
    sha256 cellar: :any_skip_relocation, catalina:       "5c03fd478b6ec955cf0aabc83b3531e409d5e2697145c2bedb02237037e6b62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c599d63395c38a331eb1e64248953c7b11b95f090bbeecf42f18acf4e931230"
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
