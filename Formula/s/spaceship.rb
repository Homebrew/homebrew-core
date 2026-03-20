class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.0.tar.gz"
  sha256 "3cffaa45a30210169a44c331936f23feb990ca1ecb7ba66adfc359616091e692"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b71404f6e39f40a8ccf34e5652bd2c0a4ac1c46573e36bae865c6061424304e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b71404f6e39f40a8ccf34e5652bd2c0a4ac1c46573e36bae865c6061424304e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8bf0178aa3e4888db510f2b949449b25dcb7b5c0e5dc88dc34d9b14cb47151a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3529e3bbdd8dbd328a7341271e5ecaf1334867f6367a0c241226d1956727aca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea59c52c09e33f771a90246fa8738a7ba52cf3d73104d63459c3e4c630e8929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d60309ed6daf9e69fbae3f9846d835053d09c8bfdc8c58c4d3d7e3f0d2a3c21"
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
