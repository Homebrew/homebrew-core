class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/v1.35.3.tar.gz"
  sha256 "2cd45c68f75a301ed7a4efda5f69ed2fd5dbe97836a03f04acc72da79294e869"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be143d195b4e7dedb904649ed701007d5fbfddddaee168f4ef4d41196a152f07"
    sha256 cellar: :any_skip_relocation, big_sur:       "caa8f81fc92c06e909694ec21ee407fdf9e4a2175d8d810c763a42f42d21a8c6"
    sha256 cellar: :any_skip_relocation, catalina:      "120ae1a842fd49f3a704f49db27e62151966cc300d43ef253055ec930aa50126"
    sha256 cellar: :any_skip_relocation, mojave:        "aa9ec7d043e869e1082766c51d216b6fc9b6c5f3668002fc656fab03f3390f7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"uplink", "./cmd/uplink"
  end

  test do
    assert_match "invalid access grant format", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
