class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.9.1.tar.gz"
  sha256 "486f50d2e51a4e7f3e35617d17ba50aed02b76cc59bcf9e790cb3dc982afe138"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "709cc456de37201faeb157e7952a9594a252fb2489f51dd2508d2011e1029b47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c7e9349fe9b4a3051be67688604e19460f5d6ab2d72c09b884b007dfa46d5f7"
    sha256 cellar: :any_skip_relocation, monterey:       "c58e540db170228066e1c92b611b2bd81a09c7c041648f8df30fb0d25851591c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3403b28c226ffd395b684616b340bbe97bd6c2c7e63ff1071aa935d3ebf3d9b"
    sha256 cellar: :any_skip_relocation, catalina:       "1036f1193ca5a0a21833b71549923dda9c7d17c1f417e8856a67df28f4f5f7ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f50c71321e07198ca9726a5cf98b68aeb18f36c32fcea69660fd520534ec212a"
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
