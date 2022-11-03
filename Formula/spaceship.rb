class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.8.0.tar.gz"
  sha256 "ce720effbfd22ed57f1ca82d40434df93e99d089cd65e87a3abb399869166166"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65de0698247d434ef4b21b87140489fe79b580fd70056e4603df764ce48779e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d47011d2a8eb1056b49eea3ac944e5f5753cd7b042589a1c9e7dbb7833a5a5aa"
    sha256 cellar: :any_skip_relocation, monterey:       "a804f30c1e1d23f40070135dd36c84713958fc0cccf2b5b80b5c87f40ab710fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec4dd5e40334413771c9e40a9d3cb9a5f8edd8869b1c082172d511f522d2a502"
    sha256 cellar: :any_skip_relocation, catalina:       "c642ec685d8b8ad0c640979ee6e0cff257357594e5d7ba28ca961f1ab1f336d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0660460d90fc22a369dab6ee3c980c92e084434d6512ccada77ac66691d713"
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
