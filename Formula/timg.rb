class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "26cc4b9b7c2fe82f71f0b40e42d3f0060a966b943611e211d01d1cb8d9498251"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "01c5028b5b8342cf87366b90bef3b9d24485e09014e0c77350ac54012620804c"
    sha256 cellar: :any, big_sur:       "ece0ca4585f66286c254d61192c1cedb8e0627fdc6c784115bea1eb4e1bf1ce5"
    sha256 cellar: :any, catalina:      "918cb24b877c141e37813aa406d0fdc82f0d031a98966f880f9fa5948bfe73e2"
    sha256 cellar: :any, mojave:        "417fb0934de8ff856fcf9b0f70b360734c874ef6ebb921fff283e76622ce5f68"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
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
