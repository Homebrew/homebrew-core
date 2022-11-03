class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.8.0.tar.gz"
  sha256 "ce720effbfd22ed57f1ca82d40434df93e99d089cd65e87a3abb399869166166"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5061a2a88b0222c5764a2ab811b02529aba2aabc13ca8582f5c5d08856e1fae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c837631845aa0173b778a18690ffb64357ed930aa9c9bf8dd925a36e6762f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d65253e47a1a90994fc1df10b3c5833de2bd620e2901130eddc776771c01982"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d2eccb6abe0e8486c67c73616bd20326a4b050799c1c4e183cc1970a2c9d5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "39f35b6df723fc745d6c5b9df9467a7ee0b251e73b83057a5d479dc6145d4c09"
    sha256 cellar: :any_skip_relocation, catalina:       "52fd6c8e67588812e0c2051b2296eafd7a54d5f0282c195d85018747b1b5533f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20bb68dbd23f57f56eae275dcf2ac29aed002979f7860d6ae8fb36d1132f0746"
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
