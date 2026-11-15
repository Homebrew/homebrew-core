class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.33.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.33.tar.lz"
  sha256 "5df763a8ae2c2bcb94a87294630db2fe3ca827aeb21354d6f2215ed1dcca7970"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d07bbea8b6e086d0cf9b3fef70922c4ea94bd63a9624a76e676123c038e0b638"
    sha256 cellar: :any, arm64_tahoe:       "731345a4ea45bf6b6fc35d5a3bfc2bd8c1249cd60db89a3a7730f822112e4951"
    sha256 cellar: :any, arm64_sequoia:     "9f670f14e056431a696da9dc113d749e2ca47129436c4ac01fe96a628a425f54"
    sha256 cellar: :any, arm64_linux:       "1ba531a0af4c7be6fdc3bd656a8e213db3a16c6cd65a0e769a952dcb691f6271"
    sha256 cellar: :any, x86_64_linux:      "c0e3a4867727db9430396d993f3e08a49bddbb17d9d59de905d1b05909bcdb56"
  end

  depends_on "lzlib"

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    archive = testpath/"test.tar.lz"
    (testpath/"source/test.txt").write "TEST CONTENT"
    (dest = testpath/"destination").mkpath

    system bin/"tarlz", "-C", testpath, "-cf", archive, "source"
    assert_path_exists archive

    system bin/"tarlz", "-C", dest, "-xf", archive
    assert_equal "TEST CONTENT", (dest/"source/test.txt").read
  end
end
