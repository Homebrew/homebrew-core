class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "99ea217643c506afce2cb5c9aa8cbc0848669677b3236815acb823fd7fcce3fa"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ba247d391091df8ace17a581841eb7352c061d4f915387fcf89cdb47c2a6daf1"
    sha256 cellar: :any, big_sur:       "0e61537ebb11a76dc1e9e36d8401eb4bdf6474380987fd98e71bddf1761c7d7a"
    sha256 cellar: :any, catalina:      "229adbcf4cb368f7d8a03f384782265eafbdb9545e1eeeb330b3116d7e0cedb8"
    sha256 cellar: :any, mojave:        "4107c2ba151093ed36472e2fd1134b2e0ab6ce6add3e661c8e0cfc975291e437"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "openslide"
  depends_on "webp"

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
