class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.10.5.tar.gz"
  sha256 "1de76e4a4081a26970cfc96938049ea7bdeeb33e352139fa138299c59e65ce75"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94aa0d156aaa235fb91cacd3ed943eec4b3011573a404e38f8f31e2d29be1a45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5ce5ca6ccbde556f318fceb661841afb42367b47e88dae2eca182fb8a4f09fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d753277007ec3876f04619b1c03b28f60216d2717b57c07a290a2aff1607fce"
    sha256 cellar: :any_skip_relocation, ventura:        "a6ca04bf308a501ef25abc3839aa1af6065c1e3023943cecab14dbce1c8c6b26"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5527ae5ca6957a5dda25341639af23c0bf6178071e4c0089267f3d316b07b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f712da0ab94469f3862abca2b68ec484651f6aeae6aedff31d19477dfec22de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e673e2e77f293498d7cd317bac66286a29ad8ea1c05ef92ad5b44255c92a5f35"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    output = shell_output("#{bin}/waypoint context list")
    assert_match "No contexts. Create one with `waypoint context create`.", output

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
