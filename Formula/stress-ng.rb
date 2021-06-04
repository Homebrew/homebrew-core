class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.08.tar.xz"
  sha256 "39e98cbb682bd3f907b2c718c20747bc94804abc92fbc4dad3a50bf530108d09"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b8b5a14c9c1d09c7c423230737a9d3a8ea310bc348772f34d881e3de915f46e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "12ec86573083748a993dfcde1c388152428be681ed4be39dbf08f0ed1ac066a6"
    sha256 cellar: :any_skip_relocation, catalina:      "fc290b71d25b459c6e527145ca2ebd6d24f05fd84bc2a7d68f076c43feec0969"
    sha256 cellar: :any_skip_relocation, mojave:        "bfa0ec38f5e634160ec49f7aed4646900029d53b6fde7e7db2690aa7595e7236"
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
