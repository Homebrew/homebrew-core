class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.13.3.tar.gz"
  sha256 "8e39135f338e269a15b0c1610964377923077de77e02f50f5be31e9b753233e2"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2abb393d1297f9064057e860d47eb41c1f1920b0e96cc5db33aaf955dbf39967"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5abf19f7df1bc2374e4b834d872711076c6a7167d53e64eaa752f96b31ab1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c02342d01a32b9c5daa0fc62e602fd1b82a700cfd0267ee72b819de77df91fea"
    sha256 cellar: :any_skip_relocation, ventura:        "ee7462b42b738b7e1de8ae0687f4d7438d8b05b2773b2b0c0aff7c8136dccc19"
    sha256 cellar: :any_skip_relocation, monterey:       "0479c8aab8cfbced0dc492e7caf65ce2585bd1803f98359842ad9b8a0738cc89"
    sha256 cellar: :any_skip_relocation, big_sur:        "93caacd8952d3652d2b6d13c99b03cc0e5f9d961ef407b3887bca6b9115a5c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3411bbdfb26cb6f44578d6f25479fcb94c2d86b36df0eabee1e773f2c37fc3a8"
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
