class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.10.2.tar.gz"
  sha256 "0980532b1388e7a55468d131d823f12e9565eb706b31438faf9bde2fa8d5705d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "105833d684303f52bc4dc832fd0695b3bdbc0ff6b7526913bbbe652a607e5c45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c570386d97c51392736a6e2e2e0c22943138e521afe47f20f1a936661965f045"
    sha256 cellar: :any_skip_relocation, monterey:       "a00aeceff396960aff60599d0ab112af09778d5c862d46fa4b2dd8f0cd236b4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f2c0baa7a848a21976f5f81dc072e4283889b0d9942a17e2ce4e0b0daaf27ad"
    sha256 cellar: :any_skip_relocation, catalina:       "c1e60788ac29fe947ff5b6dc6f367f14ab347b87b395b080490122a41a428068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86746acd02e28dbaa6b80d869a7f212969d5ab34b736822db706f1cfd45a79a7"
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
