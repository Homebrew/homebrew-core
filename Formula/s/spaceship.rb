class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.4.tar.gz"
  sha256 "f1fba8fe5e94a4333af99c5d7bb95ef22de0afc88ca8b659d081212875a68b48"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72500fb65bc61b6b1ef74a7a43e3b21b717ea12b899106c4d8b62f224dd560f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72500fb65bc61b6b1ef74a7a43e3b21b717ea12b899106c4d8b62f224dd560f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41cea624acd28ae3a6cc1ea830559d7c758069f8c6a3e6e56b6f44669dbe7d99"
    sha256 cellar: :any_skip_relocation, sonoma:        "83b784a32a3f0aa106a5d298332c847982cbbda0737d9b4ae0f1edd066ab45eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff3346225021db3d64821763f75159763f6068cafcb23481bbdc14ab658d0dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3346225021db3d64821763f75159763f6068cafcb23481bbdc14ab658d0dc2"
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
