class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.5.1.tar.gz"
  sha256 "1fa607ae7a14c520581669dd6bfff767ab49ca9ac57b266b72e2361cc0e40e28"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe0833f77357d7a45239144270be4bab4935fff4de5179e938c9837d4415e0a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cb8e23a1ffd3b0ab7874f0b92dbe34fe6049beff7f9b246392279153de524cd"
    sha256 cellar: :any_skip_relocation, monterey:       "d8032914ed609f5d0136ab54f84e06372941b840476b769307849497c07a1b62"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f50b80083b9084db64c52e4c2a91b67978171ae2764333699e4af8797cfc038"
    sha256 cellar: :any_skip_relocation, catalina:       "8e760db1934e4a898300d7ada61266a08f4f40f6a200f4a61e7cece395fdc5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e947c53361966e3d64836eebd335b84ae1e10f731559db03df957141f358444b"
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
