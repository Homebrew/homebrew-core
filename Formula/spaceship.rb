class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.3.2.tar.gz"
  sha256 "0739d3f06787bdd65bfe6456f7af1a6e4ec477b4caddad43fb9b3adf49c9ccd0"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eb49f4f7f10c6ddb3811b757979791562e8c387a706d6837faba9a4a951602c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58151f9c8979fff1eb2efec422dbcca236ea986b78ef7ef6376d311577c3d518"
    sha256 cellar: :any_skip_relocation, monterey:       "7bd9aaf4251a425a44a29c82f7aaa76d3c66c20f52e8efe7c9d84caa5a347125"
    sha256 cellar: :any_skip_relocation, big_sur:        "0157e9d431a9af498d2ee954239c9b3d3dbc9e0ec40de913332985f3d496d23b"
    sha256 cellar: :any_skip_relocation, catalina:       "14f081d7091eae38379e2174ba48747ba07fe35af2a5eab29cd6e66429ba6621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3016bdb00a915c6aeb0681f438943c3e35979996b61f353eba146a65dd8035f8"
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
