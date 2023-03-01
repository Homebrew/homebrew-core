class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.13.2.tar.gz"
  sha256 "85a8474f2055b16639e5f229f91e1bbeeb8a890b6d5530a66f079e9308985ab2"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "273721b537dffc9df760ad5b83bd7913047712ef71e7b3b3cd364fc4336de4d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dc54c46318fdda40cb08bc9d9aadc3c5c9302fdb2ef43082e01b7cd2e8e8228"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f6b27c191875962cbd65b690890483a65665275e77cc216b06ef7c078b3ad4e"
    sha256 cellar: :any_skip_relocation, ventura:        "a0c3bc173f344295d89148f5d711b6d47acca0bc47dd2e8e98a086c56fa14ca6"
    sha256 cellar: :any_skip_relocation, monterey:       "4a34a5322c612b87e1e185989163e6a4be55fe38ff0f23d6d46eeaa712426558"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea5508adcc8f9a57237670b07b9784b65038c1bf3cd64a63a32cf0a30f10887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ed66f4889f9b7e5aeecce76c2477d34f00aae3a3891698d792c3bf1c981a03f"
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
