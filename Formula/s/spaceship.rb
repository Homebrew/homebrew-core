class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.19.0.tar.gz"
  sha256 "89c8127666b9990d8f126c7e806894c1777210413a4e837e4ce819ca1d04777f"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13afdedcab4a857eb1dfb03a3fc2b94b78974b2ff126066412bf749ba7db74e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b3e5da9244fc896f543805e204298e662c46824fd74e89d31500d8d0bc262ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2006113b61bad51e000572f5e839b4faa0b16b5333e6d9a0c2e40623c3d5d7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd329d0cde6e563ad2b968f567d72f3dac9653012bd7016317d73e9a0939add6"
    sha256 cellar: :any_skip_relocation, ventura:       "7ed73635a4caa510bbfd23b7fd71a61e2a4a1ee5529435e5430d123aba5ee5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a0aba68a8a11e476e0f6da16553fba9980e2bde1e456db26e21e84bf3b3b9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1553d9113e76a821073746da978cf08621b4cce5461a730b82fbe7c542b6e10c"
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
