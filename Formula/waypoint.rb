class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.6.2.tar.gz"
  sha256 "3cb434af08226518428a7cd6b001aed93fe28911ad39ba54a3cf8d967de2cd56"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bb76f5db6eb91a388055f5a06ca2bfa764992d80d7035b0259fcea8512226e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2da767779b237e75e3e1e416759743db46c0b79dd33633744689829587cc13a2"
    sha256 cellar: :any_skip_relocation, monterey:       "319d093bc8cdaf8ed820ec486d06924aae0edc4b0c51b32f2e202e99adc2889d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e058ec050b52e616c0aef72ae2f955df4fdd5f95242c3ef4bce352dcc89574c"
    sha256 cellar: :any_skip_relocation, catalina:       "b57ed57a952767a293c015cc252241d00bc640ee66ee84d2ca824458b06d15b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93523a47eba543b9a02615ac3f3a0b917d127113aad75786bbc6b04b97d599fd"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    assert_match "Initial Waypoint configuration created!", shell_output("#{bin}/waypoint init")
    assert_match "# An application to deploy.", File.read("waypoint.hcl")

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
