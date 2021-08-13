class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.5.0.tar.gz"
  sha256 "66cb6cd23bd809ac19ee94a01fd6d1e82101b698b44e3be7a6839a8cb720ca30"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fbe1e301c256638a523f58da6c9f8e9f8f5c8df887c531e93e87090927653e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5d4edd5f4e8c5d01860af62a16eca028b18597fbcd009b9df86c56c87c5f1b6"
    sha256 cellar: :any_skip_relocation, catalina:      "6e7c1fbbecd377da80139d1e2d066ad1caa0ab9393ed49868a173dc8dba016ec"
    sha256 cellar: :any_skip_relocation, mojave:        "82404da2cf00bd24aea288f4e96879b571449648646acb093f0f5723e6c1371c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42d7c3ec6cb412adac46fa5108db2b8ea919f76976c1f6dc158833de149bc58"
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
