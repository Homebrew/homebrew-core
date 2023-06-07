class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.0.tar.gz"
  sha256 "64ac4614db292ae8c5aa26de0295bf1623dbb3985054cb656c55e67431def17c"
  license "BSD-3-Clause"
  revision 1
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f86256aed05f84aa98f925384c6317fecc60e9f55a52c92a8c9ddcbc0af4116d"
    sha256 cellar: :any,                 arm64_monterey: "181852278a6be20e21b8bf2bc4fb0a6501cdfe8fc5e216bfde223267a6a5f612"
    sha256 cellar: :any,                 arm64_big_sur:  "e694b99161c42592d69ec3f08ce1f6bfe89cb9f1de4af2d5381675a0892cb766"
    sha256 cellar: :any,                 ventura:        "7f0a23ef69c04d1994a5e1e5af7db6be289c3d45a88ce14de10b9d577da7637e"
    sha256 cellar: :any,                 monterey:       "eb4aba8104a748820b831e222ca1feaa94ca4adbfc65069528061fbd57831ead"
    sha256 cellar: :any,                 big_sur:        "b65c4d06df31960977bd4822cedf8018f66059006b114ab97514599630776eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a703a8e6b6599fbd91ffa96022547073c167fee431724f50544716f4bd8dc036"
  end

  depends_on "cmake" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "static"
    lib.install buildpath.glob("static/*.a")
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
