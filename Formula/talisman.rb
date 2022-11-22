class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.29.2.tar.gz"
  sha256 "0b2ff1e468d20388c382341068eea25e3e45e628220c277391aee1e21c0223a1"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bdc9d67537f846550a78a9021714cdb661b8c9f5bdda07c64c4c00f305ef18c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afbd94631edefe17c73125c49610be17883f4c7599bcd5a839b378c74269f71a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac800f846c995161c874d3c1deb3d8a81589888c322780a7b39e1ee63fa5b942"
    sha256 cellar: :any_skip_relocation, monterey:       "b4364a8d8b0054744a79a313417601b2ea38230fc1a2b90dc092a1dd0b375610"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e752e7d794e49672bc53b888edbd6d08df9052d30dbbe7ff8480a09a0f24c68"
    sha256 cellar: :any_skip_relocation, catalina:       "be6bb6170945b183fb596e81c44f23a51b627d60cc19cae6ecb7f97757f8e172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e3e81ddb99d292c4fffd000eed7a42c4184900c5d10c21ee8eb7256ab6ee694"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
