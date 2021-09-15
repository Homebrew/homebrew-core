class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.5.2.tar.gz"
  sha256 "13979764fbf25f89260b7a824a9e44c60b7236595f6381521dc83b444cab205a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f922273ef47eeaf075e5fca66a11f0d4fe00d8eb7b20e4c97ab79a91d243c0a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "c66a02639666b4cd31991308d100adcb534e46faec8c9e7d2ca771b1dbd66453"
    sha256 cellar: :any_skip_relocation, catalina:      "802b27d57c87b561753ffe175f9e8b912a5622baa1e67eeebd16317664962e3c"
    sha256 cellar: :any_skip_relocation, mojave:        "d4516816a3dce1ad74ab064ff4d38aa9b6405b26b389eaa0218a0134a45b5485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d128ba35b5648446d755d8d3f199909c812e1bd98fd9ba5faf43cb3bba0f66"
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
