class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.11.0.tar.gz"
  sha256 "52247a18ec349764f0a924214f78be07e4471ba137eb3836f3472254a76881d7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fe05487d941dd2ccb17aea36b090dfb637e3b2a228ab37cdf949a4f17828671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1160e1fda451f68e0d26b1dafa31c6967e017186435bd59e456de919fe4541ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86cd1f2c17e1e78f6b341fd9ccfa8795523f5be8bcee7cac974317fded5d399c"
    sha256 cellar: :any_skip_relocation, ventura:        "3a3226d0e8300c6576fb0554c68a71e65ab6556e8e9df79ff70defb82663d4ab"
    sha256 cellar: :any_skip_relocation, monterey:       "d520c9ccd1cd57a6d1cdc0ee42590e2b17ad555ed403405707d3f0804c47afac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7cd99a53e5d73a80660f54b57aad80fdab8b44153004c0008ff7d04445e9e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25b164da5ccb08b39df5de16a8d8a31349fc2cf7d53e23b860e7206ce9eb14c7"
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
