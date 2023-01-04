class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.13.1.tar.gz"
  sha256 "eb8572afb2d6fd62e3992cce869484043cf3c6bfa849bacfd857b6fe22817465"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fd8878875bc9eea7c8607c10587adf25ae38aeda14fd8352ef0aebad2cd2f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dc69d150db9bcecb82924ba80d21be16e5c5524a838ae010355c165f7737cbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34e0b5a27b86f7f2d21c84307cf3450b7f23709e2f724d53f3526ba313bbbf89"
    sha256 cellar: :any_skip_relocation, ventura:        "281253571a8ee86030761dbb38e38da04beac0d65013ff6503f407778b2a2c04"
    sha256 cellar: :any_skip_relocation, monterey:       "ed2b484903c82cda6ab3fa8c00a263bda1ec174bdbb3d79becbefad3e4be7d70"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8af91a578cd2779f4c2b53198532374685f1f6912d7d837aa1da6ca1e44a122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f3a749cea525685b1ee86d29a57858bceb725e4e10299bf5dd0f7e59d8d40c"
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
