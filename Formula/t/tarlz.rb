class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.31.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.31.tar.lz"
  sha256 "e7fafcaf83ce215d94f758ff07037a3fda4bcea006ccb7909ce3f83218e98f71"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "328421f6970c6a2ef8d6761756cf430f9e7729288abd19f66ddc86db47b27ac6"
    sha256 cellar: :any, arm64_tahoe:       "f86f03912b3b3a5249d1bb7654d29b914c2b117e125e5f22a8e1d9821fc54c62"
    sha256 cellar: :any, arm64_sequoia:     "7496de4b57ec402943cbd955dd4aad174415dcc08c2f9db551e9785a4b09322d"
    sha256 cellar: :any, arm64_linux:       "8f39075c4858a8a8f5dd0cedb75077c1a0e49d13fd44e08740a69b4359ec3b23"
    sha256 cellar: :any, x86_64_linux:      "f5fbb0ecc6fbac68bc548dafeed95eea54527c80a58b6c6393719abe41b58114"
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
