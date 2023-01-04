class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.13.0.tar.gz"
  sha256 "3a9d670180cf20f1608dcb8127517ab9a0ab6dc8de6c45949b78bd16e08cdd84"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c0f5b07b436cd41b23b15b4f0ec04d885e894e753d8a1d191fc2b4fe979a7c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ca4c1e52c3db71b2b5e81060e74129f349b104ab23ceaa38fc322b90a531c2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa296ac119eed1f38ae4c3f5cf8b13d9f42a3f788dfa6f462bc59cf88ed4fa24"
    sha256 cellar: :any_skip_relocation, ventura:        "b690e3691ca7ddd73f4bb38bfaabc9816f03e6f9d72a35dfa58b8b78c0ff532f"
    sha256 cellar: :any_skip_relocation, monterey:       "c96cc95c5148e0c06fa0c684637352f620d18c62ea9fbb6544558a1777682cd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "312ce990fe64b883b76ab97d34ab9df2e9d91bdeb401122d5d07d36ce2c356a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89abe002707dad877b7d49a0873d4f4c618a34bec2a56b75786e69bd5cfde78c"
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
