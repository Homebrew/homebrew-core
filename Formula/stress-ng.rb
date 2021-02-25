class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.04.tar.xz"
  sha256 "b4e34bda8db4ed37e33b7a861bc06ad77cbbd234d63236da2cb58f02e3f3218e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d559bd3b2a1ed59ee18b871dd2d0f6498ba4def5ee0c85dcca2971eab504ecb2"
    sha256 cellar: :any_skip_relocation, big_sur:       "27a8f97fd84bbee7283dc026af9e65e9b7724086368d508a2159a0fc84695895"
    sha256 cellar: :any_skip_relocation, catalina:      "0fda3254100a1e6b8ce5178d28a5988484faa6c88054e5a5b87db5801da5571e"
    sha256 cellar: :any_skip_relocation, mojave:        "c2c5566d1f12ffc98d344015d1c831b49cd235e5f16f2468cfdb6e1ee44837bd"
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
