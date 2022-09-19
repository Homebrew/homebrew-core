class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.3.1.tar.gz"
  sha256 "a6bf1a9a60d5ca41a3805fd1d58fb38956f7e2b9f058684a6b455c556b589ac3"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae5ff9d14041e436fe07fe9917454b24516662bceed70126788bd932c1845fd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "065b70b5f26acc4e578923bbdf820919d650d6e5b14b02db2a5c1e4f47b086ce"
    sha256 cellar: :any_skip_relocation, monterey:       "402a0b7f2c7b22eb06e9f1352224322cce5ee0605ae00d1b164e6c10d2db7e2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcce01319aa51ee54ba7d308f1293cf0b8e8a68dc472196a25a9f2aa87c65d22"
    sha256 cellar: :any_skip_relocation, catalina:       "ceb517107d2816b4e4ebae831cdf8e3c46db20adb28607c66582ecd280cc3c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4da6e14f2d4ee04024e3eb35a41cf034fb920d86d98804b04b42dd8c621fd81"
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
