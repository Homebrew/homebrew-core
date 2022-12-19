class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.28.tar.gz"
  sha256 "6dbc41e0615e1e2a2e1d56ecf2a3a9f555bb39ab16fabc8f4a0cdc35735188bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dd5bf5e0144e5dcfcf5e24d99f0df82a981b63598eb8a1dc1dc20192b0c32cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f86bf01de5c1735e81428d118a9299a803f1f0264f71653bf30ee3f1caf1dca9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1afbde1d1293168331a7d80f93ae04e6ee877110e4fafb19af831fd277e01ec2"
    sha256 cellar: :any_skip_relocation, ventura:        "214dfbc49fbcd210b7bfa1336ce7601217da580543879061d105982db9ac0d21"
    sha256 cellar: :any_skip_relocation, monterey:       "3a29853dd9eade845fbda33a4c766c5fe125bb0e77e147ff976dc3f5ff553632"
    sha256 cellar: :any_skip_relocation, big_sur:        "337c2109eff0e73b322c61dfc92ecd09d13b51612071d889d01b92775c890722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e61eb500543022cd1e9a2acba7e4f7b676ad8322a967ce534153763254faa2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end
