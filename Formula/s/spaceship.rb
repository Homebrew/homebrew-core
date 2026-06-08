class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.3.tar.gz"
  sha256 "12506d2fca2b1ab887a81b13cd18fb28877e19e0d36310404b3933b2c764f2f8"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82ae5018b987a7759dc5a06c5f254eb557e8a35795a057a1b864602d1676a8e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ae5018b987a7759dc5a06c5f254eb557e8a35795a057a1b864602d1676a8e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ff1b8c7edc9492a47913a702a2b5282f1083e2f6da1933af8495ad565ec0a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2001cb2835c020c761c2314b357da5e5ca668f7abbcb4240a86905ea46f98008"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c626c7b4ba5010073ecb8061c814a397779cab88d80c00a5f223e266f664b12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c626c7b4ba5010073ecb8061c814a397779cab88d80c00a5f223e266f664b12a"
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
