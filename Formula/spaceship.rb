class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.13.4.tar.gz"
  sha256 "cbc396e2d1f9b09b2e16f55d04da1a3573e10caa833d170b3a1e7f534f268dcb"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "084c866a927dbf89003b026c33eadb79c93245cdbc5d6f36a368613937628b9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3e5fbde7a50e26de8841f6180b8065c0d2142310315dfe45398d1a78c08346d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36a66f1666731ebe828e31e5b80f8f8b43f879199dc08ccd59e6a6e32e6765b8"
    sha256 cellar: :any_skip_relocation, ventura:        "4b58f4a8edd8c0553ac71bdaf7db9a0d1c71ad8de966fe0c689001c65eacbe52"
    sha256 cellar: :any_skip_relocation, monterey:       "713a2882e951ae1674a25cac97d4dfac8bdf58047a3c4c2c200be045ef84ceca"
    sha256 cellar: :any_skip_relocation, big_sur:        "343a60ab6e17842a189f25d47452bbb0769372c3040a3951a7b841832ed44256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f0ea5c428fbcc1c7301469bbc397a2bf9f485e48f9e8237829d994215922772"
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
