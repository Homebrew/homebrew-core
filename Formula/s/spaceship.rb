class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.19.1.tar.gz"
  sha256 "c74c24b899df46656dfce56e330e5a70801bd54dcf3ebac877f99c1ce7b07c63"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d7ebf8c4287d2e7dc9f067d9be745a5ee11fe6fefdad12a2e53cb575bca0db7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260a6bd913f5af19058338f46a169999e32d25787fb2dddc8f4dd5e510e5ff87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d74fa6ef80e222ed800d3dc0d56e6f76dc6e260a80fdc5e2d5b0174a2a56514a"
    sha256 cellar: :any_skip_relocation, sonoma:        "86e6e526c2741c544d3748e06915face82bdcfc5f6f658912c430f12a8010d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4ce2b91005163820f34eda2704476acb27352b46079b5fc78adc19894a2235b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "783bf9c28e2bf2535d8a3b9ea2c1530dd3444e1db13df3f4b8bc97e398283abc"
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
