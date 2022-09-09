class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "66d2e00b50068fd6638bb8be1859c50ca4f24caef751f9dc95b303f37fb07b1e"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "be4ca4b2e169c3ef834df9f61d00fb23758361dcc588fd2d6bfd2442dfe41426"
    sha256 cellar: :any,                 arm64_big_sur:  "29cb0704f3d3b4ad4aff526358a6613ecd78e077970b015cf8f1d2483175ca04"
    sha256 cellar: :any,                 monterey:       "e0fe70320d537417d3715f3aa6f27349506db40c49b9b1dd3dded5aac648b659"
    sha256 cellar: :any,                 big_sur:        "879ce842653d7f41044688cf8fd421090580b15f366964321babcbd1f0fff1bf"
    sha256 cellar: :any,                 catalina:       "567e278622c286895367fc61fe01b736f0b64f0c78de2b841f8a51ff9878a5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa0ec5657396c90ace6275db5bf210343c46724f2459295a871753ceeaa2e380"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "openslide"
  depends_on "webp"

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/timg", "--version"
    system "#{bin}/timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}/timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}/timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end
