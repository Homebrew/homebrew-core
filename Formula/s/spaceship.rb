class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.2.tar.gz"
  sha256 "24230f0c0a8dce3bb20d05b20deb6ddb60116661410d324cf43eb138a4ea2097"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17f3f81dd1ec6361d640d3eff4cc704bef2f9960679479d97687c7f66c3f984f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f3f81dd1ec6361d640d3eff4cc704bef2f9960679479d97687c7f66c3f984f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "582d9b26274e082389d273036c6b10de464b547b600ab91d3bae95966742b2ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "92eb0994406cec1e2d00a066340a8aaa547f2f693e582d91220e1e2ee48df8b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb5a623f8860d993877b3fa1af19bba17fea885a4f758c79c19b4f5330152189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b858564e2aff969020c5d0185d9231b2daf9235ef8b26ad6031acd5ac93a1b0"
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
