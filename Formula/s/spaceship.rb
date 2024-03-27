class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.15.1.tar.gz"
  sha256 "2fd6299bf6de1709a482caee1c89e64f180c995abf6f4d22f9f6a9d5d404700c"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00b775798b893e93a1cb3d983b277d36be6f39dca5d6a73a0796088c33f369d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f10b6411ca2ae127e1c5c4a9d862deaf8c9f0ba6b7829be406fe5eacc448e443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8132bd11f2cd24da54ef6b79bb995e9257ccbd39171bc4ef2fb8fc7b16e25ace"
    sha256 cellar: :any_skip_relocation, sonoma:         "09976a7476e318f35dd8a9e3149417f77430f50bf5950c82eaad067622fe7df2"
    sha256 cellar: :any_skip_relocation, ventura:        "b52c62597b3167bcd9cbb07def8135f34c51eddd127bd241c78bc5d4cd0c1df0"
    sha256 cellar: :any_skip_relocation, monterey:       "0db8c0a40a0992b783189fe562e0cbdbb83c6083a71f23570764d06e6575e2d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b93687c04640dcdd39c60277265b9916b2f98c5e9688f3eecb8e3fefe47584"
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
