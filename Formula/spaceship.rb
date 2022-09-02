class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.2.0.tar.gz"
  sha256 "717e82f52959a74e4586a687cfcc14a761415c957b334276aa118b5738e405ad"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3922e5ce767b2b21732bbafb8b92673166e2a95e90e536b1a02f7ade6c931450"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "384419ff230a911c5b0c00a2ce38e2833255cf22d9b1f45409fb044344fae97f"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5f5f8ea5e403bcb1d34d5df588f9ecb08a24a4e03416d89ecbf117b07965d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "49a8b8e77c9c22a53cdc9e9c20c05b5f6c7a324dcb9d26b046b7d3c74522b058"
    sha256 cellar: :any_skip_relocation, catalina:       "c4879cbfb351f19c8a499e42142f42c8bd1ce56e5d4b2b50123b60d063e39ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6441f178dddfaaa56c3ef964b21cb724809d8f2bcf3bad76e1daede520b7419f"
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
