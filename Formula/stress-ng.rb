class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.13.01.tar.xz"
  sha256 "f37f739e4d15343360a47980b67dc8b2a6bf3d4d3ef727d55e2dd99a0b64f9ea"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d5dd85c22296276b5faba121d9e9d259354f86f140509fa13580685aad36adb"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e405f09b29c734b1c9e16faf3ccbe53e13083a8e4aa7c4ed755eb798b01509c"
    sha256 cellar: :any_skip_relocation, catalina:      "c71a7cfa62e562d7df35ab6108340b1f5ac69930073c76985c875944c5d40140"
    sha256 cellar: :any_skip_relocation, mojave:        "da2df3e6ac647456e091c66539b895ab7c556ce6f04e3af083e4ea5f2feefbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c318fa8ddb46ef47d3a076850d9c4b4386399cc4bd142a77a63c1a0d5dad3e8"
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
