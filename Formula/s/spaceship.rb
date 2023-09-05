class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.14.0.tar.gz"
  sha256 "6b53d7b5f79c6d9d48676c0d0eb3ec724300a195b5f151dfad5f3d1ff41af463"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "026c9650aaaf985062d350560678c95bf2c5e884b79f024cd781416960bac1a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5fb4d1fab76a85bfd4c1abaedfe4107af7ac78f223268cf26e5ebd5738dc25c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "887afc00c9bb20228afef9395a5b43df83e69387fcbf1d3c6140a548cae33290"
    sha256 cellar: :any_skip_relocation, ventura:        "408e676f84e45003126217a436182bd83985f10a171212a3d5be87fc89b19382"
    sha256 cellar: :any_skip_relocation, monterey:       "328e679192661aa1671fa7cc945339dde37ebfbb3bfa0aa122021e697fe8cfa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d5844b56776e04ee0a2912aec207ee7e65660bb882f11257074e91fb7e822e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1fe5a54656abafd30ffd5f48ce7ac8a6de6aa3c4b40ebef1b0a4f45e463149d"
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
