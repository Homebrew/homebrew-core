class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.11.1.tar.gz"
  sha256 "8615d9333f9ee3c94a55d2594deac7a9c9fa4fb44cf83540be190a17eda19a5a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "379ba729215bafe99e7199b7900ede5d287614f8d01538a734e3da503365991d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f5003ee88a79966b22591c3bfd498abe6f24f88f8c52e5a6562bfdd915ff157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "850d7779f3615fc6e31a82268a5cc8b1d4ffc67ca51224c87f2e1ef5c6dba84a"
    sha256 cellar: :any_skip_relocation, ventura:        "5649310b049310cd18b61cf23711a5b428fb91d2bfa0de737ecd2f80cfc296f0"
    sha256 cellar: :any_skip_relocation, monterey:       "33c3c003811440075d9754e8952511abeb33990981606625bd41d28845c07bf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5396553fca6f28614ca1c792743ef28b363139f936add38e5097913e2e990d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a720cf9fc7700031bc47dec592cc9e3a6942bfd72274e7d0bb0bc33f2ce5a78"
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
