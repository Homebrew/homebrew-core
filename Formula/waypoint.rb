class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.6.1.tar.gz"
  sha256 "e4b75b45511a284e02b8809a6637a56ffc8188ebb786f29c34f6a6bd7cf69165"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc8cb70559f91e6eaee97c1801d843bfe5d517ae90ee5414aa2ff04e1f7cfca1"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c35b6915a7cda9c16c67e8e9c0227b8d54269b5ce26879915cecb556086f00f"
    sha256 cellar: :any_skip_relocation, catalina:      "721b753057ea546c67c7ee2ab8c0701a5f16202cff551fcff67bd943c30e043a"
    sha256 cellar: :any_skip_relocation, mojave:        "ceb9e19043256d2433495e4e0036ef04db0b6d831d3a054a71a461842b7eafc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e300e326c4a3ef4a9af33ebca7d21ffa5b046326cd5a48dcdb0490ed862c29"
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
