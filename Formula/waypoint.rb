class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.9.1.tar.gz"
  sha256 "486f50d2e51a4e7f3e35617d17ba50aed02b76cc59bcf9e790cb3dc982afe138"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1982703206eca72383fc0f8ca63f196df829af4fbdd4d212f55dd0cf420e723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e7697186d3518e7e1d2f98b78960f457f5aa51b83da1924ed8109b196d6138"
    sha256 cellar: :any_skip_relocation, monterey:       "a23fa1c3b8b73743c3df0f6957b852b825a10f96c89439f05195d639cfaa062b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a97c4210664380f9fd0504df08b9837eef8e1463f07db77370fb3e7b95b26b5"
    sha256 cellar: :any_skip_relocation, catalina:       "8f622524683d31ba53450890099c638ef06428bf3e6fa809bbb6c7594abe94a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2393ec3c757d3fafbb84d7d0f91f5f85515ae3a68e33845174ef7cef889962"
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
