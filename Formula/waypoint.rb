class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.6.1.tar.gz"
  sha256 "e4b75b45511a284e02b8809a6637a56ffc8188ebb786f29c34f6a6bd7cf69165"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b6a1b5bfb2cc1106b2fe510cd3b7b1b0f7f4e1bb5e1b0bb97d3fac08b3ca46d"
    sha256 cellar: :any_skip_relocation, big_sur:       "20b0803a72efcf0a176005674800acc08fbc5e1b2c33d7814c3bb660f09d878f"
    sha256 cellar: :any_skip_relocation, catalina:      "52638ce195b22221e5584dd38020e3c63b9aff239be7650087c47e75a9766bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb327bbaf3653d8507fcbf69829f65bc11b60cbbdabe98d3ca77d416bd270a6"
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
