class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.4.1.tar.gz"
  sha256 "556a8e70dfbceab02ca59afdd97549da4cdc00e1b006982fbdeee446fdae0562"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "853847353a7ad6cd452a7af521f734f41af3fa746dde461e13a3d69e9eee42a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a1cdcd71b43977ffa8df6eaa7c83f132d398ca75fa260764daa80e6afa5e806"
    sha256 cellar: :any_skip_relocation, catalina:      "652081285932b97d7e4caaeb8d8ffdc970378083f8d0847fd4574b92128ed9ed"
    sha256 cellar: :any_skip_relocation, mojave:        "afd733c68296f2d3048452c8a605a0b5d9d6203fec276ab1c89fa3c3d8a76814"
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
