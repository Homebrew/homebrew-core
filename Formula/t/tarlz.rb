class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.30.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.30.tar.lz"
  sha256 "c6339319413f37fc4b155b1ba8a58640a7fee36498b095d3b6d3c13d9c7f286c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1c39f86e634b0a13f0614047a41694748d26a75ab32c0a4b15fd3c4c87426f85"
    sha256 cellar: :any, arm64_sequoia: "016449a5c0caeb49d96fb2527aa349d2a7eba7a973fc752c3cf7832ecf6a1a77"
    sha256 cellar: :any, arm64_sonoma:  "12903a0aeed39ee40488a1002a6a38cb4d66ef24d2e2e05cae22d7d163034f4d"
    sha256 cellar: :any, sonoma:        "519b3f566e1e46725938f5977ba4d05575289504991af71ef2d0df10c9aec8fa"
    sha256 cellar: :any, arm64_linux:   "6b515b803fbd636ec1bd9cf5bd4993ed6938a4fbb788d46f421a98679a02fce0"
    sha256 cellar: :any, x86_64_linux:  "7d177431afd66cbada06599e62702594724f02f7a1bba544668b053051ad0ae8"
  end

  depends_on "lzlib"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    spath = testpath/"source"
    dpath = testpath/"destination"
    stestfilepath = spath/"test.txt"
    dtestfilepath = dpath/"source/test.txt"
    lzipfilepath = testpath/"test.tar.lz"
    stestfilepath.write "TEST CONTENT"

    mkdir_p spath
    mkdir_p dpath

    system bin/"tarlz", "-C", testpath, "-cf", lzipfilepath, "source"
    assert_path_exists lzipfilepath

    system bin/"tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal "TEST CONTENT", dtestfilepath.read
  end
end
