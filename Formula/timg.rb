class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "7607efaffbed0b65b3c824956de421b155a4f14243e7a752b19454f88bf9d563"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "28d0c27b753c1a104b5120352c7939565a547919388ff2b0fa03a563efeb149f"
    sha256 cellar: :any,                 arm64_big_sur:  "f3eb242ecbe5c59c5f3b29b5045f7666139327995dbcf6d24deec8d62b0092b3"
    sha256 cellar: :any,                 monterey:       "a648d114be31886b6450ea88a1440d2c99dd856938421c345bd042183c5e3d9e"
    sha256 cellar: :any,                 big_sur:        "e8c461f3728f413833bbb2d7fb6e1f25d1de01fccd1518df9ab0f310d3c3f155"
    sha256 cellar: :any,                 catalina:       "6bcff3160692be766cb27955e90adca0daded1f7af9ab6768f45dab3ddb76c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a083f6de16d632bd1a43351036f4da8dfdb74b742a3af4ecdc0e58351df2812"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "openslide"
  depends_on "webp"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/timg", "--version"
    system "#{bin}/timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}/timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}/timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end
