class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.13.05.tar.xz"
  sha256 "f058c8fba37596ab32c3a4b2aedbdbf5f2b8a8ba1d312059e733290543ad00ac"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "484632f5ede25db3a241fd67545f88f357f141a99152c13ffff4cf531b706290"
    sha256 cellar: :any_skip_relocation, big_sur:       "92f16d015fd98a39b2fc4035134077cbebba49e05d307018336703e7b78ccca6"
    sha256 cellar: :any_skip_relocation, catalina:      "01ee57ddeb2d0134b8e01e895152f58e796cf547ad5e341baedea0aba58eee34"
    sha256 cellar: :any_skip_relocation, mojave:        "4c6ec1d023ead35abb1c037db5fbe601a5edb5a4f82095a274b8a2f182bf1570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef3c8d2739eb59d29c0beff8e8a0e0fcb1f1700aabb119e853f76a7a43f0da8"
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
