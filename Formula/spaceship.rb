class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.3.3.tar.gz"
  sha256 "a4fa302a4d1285fb6c2a05e084560df53cb1235b2fd6c9393be5b232e29264c4"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c7d9e2e0fc199fb4d53fb4b80d617f6b8cbbf6a1c81e6496d3bee146e8060c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60f087d2aa35e74d332b45973f2843825d9b9ecb66d07d9987f5f1ac8961544b"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4e8a51866f21babe2c92e2c299d725fb9b760a9e650938b2bb530263f3e8d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7f96b830b50bf03a3ce7c5eee2863a6208154cad34708354c0d064672c423cc"
    sha256 cellar: :any_skip_relocation, catalina:       "f770e3fed932204c293ef8c2f1c1d91a13b77aae3cdeab19ba12b2c4ce1f3988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7bef70d61a70af4443150fd67627fdc20602da58d99a17273fc26b404d3975d"
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
