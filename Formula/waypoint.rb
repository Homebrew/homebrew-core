class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.10.3.tar.gz"
  sha256 "e75d0fad442bfe46874968fc01eeb8aacb5c2ef3cfc0fe62e29ef69bec444d04"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "089d80935b55648cb61ed2b22821218cf67ca21999197f932201e31b58dfc946"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f160ed8d0f65970b7c1703051130c61096b6fe86f423739bea30f61d2666f4a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76b4b2f5e21bd265b5807e44b92b153f4bb14617a03584a313712ce4a57f00eb"
    sha256 cellar: :any_skip_relocation, monterey:       "1e69bbfd98e2158eb37da80ed4ed489d111ce20a142e0a2c3619a31a4fce23a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "628a49f55dc3b84a8018e3ce5a308dcc0a4d6a1e99a06014658abc9e88fcfad2"
    sha256 cellar: :any_skip_relocation, catalina:       "0fc3fc3ef377de0c9008d4dd1021525ec206e6968f6095b84b6a2e50076ab698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b38c217041bb4bdfe42afc84a1d383cf7167fab97da528374aae40d6b34ec9d"
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
