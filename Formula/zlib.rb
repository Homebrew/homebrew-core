class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.2.13.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.13/zlib-1.2.13.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-1.2.13.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-1.2.13.tar.gz"
  sha256 "b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30"
  license "Zlib"
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55e71e5c7907eb8870b3f8b00349c620dc6115d5139dcb45cc3a87101663162c"
    sha256 cellar: :any,                 arm64_monterey: "27b22a6738cbf4a4f3925ace7c72aebcb53a7c13c002ff78492718e15774e8e0"
    sha256 cellar: :any,                 arm64_big_sur:  "83700f7752031794c295557ee3c6aa9783f93ec9de44ac117f7958a83d823dfa"
    sha256 cellar: :any,                 ventura:        "cfbda79e30416433d6a554f187a99fa9769c79a35e73ccabb53c3c02170ce26c"
    sha256 cellar: :any,                 monterey:       "8473a260917ecc2595a8f903bdd8a23a034683eac350839000a26b17286c7462"
    sha256 cellar: :any,                 big_sur:        "495733577a835472554be619e26ad09fa62684d1d1eba3efae5a8beaeeee9a56"
    sha256 cellar: :any,                 catalina:       "4da7de2b14c12452d4612417e571e04188c6a7594b7f583e7bc72e27f9d965c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0082aa29a61507e237389ee4e9fb6a6ed0cbd5d341e3905527c089c88e730411"
  end

  keg_only :provided_by_macos

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    touch "foo.txt"
    output = "./zpipe < foo.txt > foo.txt.z"
    system output
    assert_predicate testpath/"foo.txt.z", :exist?
  end
end
