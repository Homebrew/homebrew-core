class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.22.0.tar.gz"
  sha256 "3e6a1d27e0306509ba5d197dad44dc40cff5fa4d14d85ae0e4293a0d6dfb0e2f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "492bd653adbb35233590493af812a2d2e6f087707185670374b5f4b28d0a90a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "534badd4c595a32338bfa1627cf8530b5eec96ac24388e5b6080e57e89f3bd19"
    sha256 cellar: :any_skip_relocation, catalina:      "d8ef7bc535c99083c1e2426ddb99fa107a8b287f389bfd5b882c9239762e17a7"
    sha256 cellar: :any_skip_relocation, mojave:        "6bd79dcc54fe7c42a7834cbde657b4b96edf2fa5a8121536b7f17fe9a6a8cfe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f03e7dd99740c5792b14f6d92e33a9d8686eb56c282b12035a8b59a494bc2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}", "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
