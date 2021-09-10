class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "7607efaffbed0b65b3c824956de421b155a4f14243e7a752b19454f88bf9d563"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9efb49bbad5a1d202cc8c41bfdff21d65e9eda416fe9cf439c4d3c10692d6d85"
    sha256 cellar: :any,                 big_sur:       "09fe7cbf66f51101c316ecc33291e3c98636d59ccfd069e77894056dec8c6bd4"
    sha256 cellar: :any,                 catalina:      "67cfebef4731e03d201ee578cdf1aff72a1dca4248a56381be57bd2124520f72"
    sha256 cellar: :any,                 mojave:        "bf8067d82e2306a521b21021469c30114c24d1d7fa04f806cfe1c4e5e908b69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b88f5fd8f7030dd2f59895d8c177b8344a2b9078d72c6658430a685c93e1c2a2"
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
