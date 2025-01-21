class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.26.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.26.tar.lz"
  sha256 "53fe055ef70348570975d220cead5636f9175f0c07bbec8e450baff18b9998e4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f226b870f51c28d8f4243680f4741f6027795e3bc2f8e9b386505066dde88b88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "852db23175e4c9d9f626b3d263e66d7a27cc5ad70a4d8c99ed7cbaa50a9579d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d627f225865b0aad38a4fe79066a0f5e0352d360d784734c7f4051a73171658b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d36183f2a6e0bfd1941a75f6119a13b3ac902e88a55445f71ef77ae4b748e225"
    sha256 cellar: :any_skip_relocation, ventura:       "fde27f67dfada1b594952d9a55e205a217059462bd06781b041a7c9fdcafbd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d535a40442b811556f3047254be35c3079ea2168ca50ee11b9af41797e6a9104"
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
    assert_predicate lzipfilepath, :exist?

    system bin/"tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal "TEST CONTENT", dtestfilepath.read
  end
end
