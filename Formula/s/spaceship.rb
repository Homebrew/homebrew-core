class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.21.0.tar.gz"
  sha256 "990f3e036a93b7e7860b8de82833fc4c0fedb4df06f68af242aaf6fe9e61148d"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84eace17844d30a9c2f60cd493a7afbeffca1da08f8d6bc2ef1d26338adc11a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077566293e9bbe856e0703dca5dc771b39716a738b5f6a59d6e8c7aa281974d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feb71d2a0b3d9e175fcc0c65a853a5744c5209b2173dffc49c4788014370dd76"
    sha256 cellar: :any_skip_relocation, sonoma:        "57297c8a29038f69c8c70f599bffdbe9b63384ee41b44f6bdaba39c63db29dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c808d17e3bdd0434218e5b849145eeea68629a3e8c6b08d95881d56139035e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fb363db031640964ff0beeef6f4aaa1f637489f0422f12e2814eb382109e0b9"
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
