class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.11.0.tar.gz"
  sha256 "52247a18ec349764f0a924214f78be07e4471ba137eb3836f3472254a76881d7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbcaa26e0fb2349c69c2355d5158db38394026a3b0919facf31a6863f898cc7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bfb10bf903b62d52cfc5a352a4fad79f7b688be3336f7dabb07cb729cd71a6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c411907b92122900c3a355f18a4665f740e0613b7eddbbf8812b4446c983a53"
    sha256 cellar: :any_skip_relocation, ventura:        "9a8a5358e701990ea5c1b95ddaa9cb8a8f8c40a7f827d2e2cb79dd0d979f9580"
    sha256 cellar: :any_skip_relocation, monterey:       "b858256c325904a193ff749759e5e870383f1db80aa9627bccdcea113571a386"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b9c7f99543c1c63ca42785e1a873b9bc4338ad6cc42973983d52be4bf6a1969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d914ef516b36e076c84a7730f0a132fda44063bd9827f46038dd18055a569fa"
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
