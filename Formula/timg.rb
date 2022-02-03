class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "46eac8d5434b281afa6d64ced5f46c732c1c4d0699e16a22175b7df179221e2c"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e685438745bb8198fb2610d9189f306eee50241f1628c0c6ac0e800b8b50406c"
    sha256 cellar: :any,                 arm64_big_sur:  "d1b7b34627f93a5608e38c945d8f72b2092f64be3dddd7f8aa75dc3f04e6df97"
    sha256 cellar: :any,                 monterey:       "9378c737939d88b259e7fc5b6c8801b411a7bbefac8f0c638143abf68336b407"
    sha256 cellar: :any,                 big_sur:        "4f9c7787c6b758dacfed884bce82593f778b4aaf6410bb1ed651ea4aa3d5c22c"
    sha256 cellar: :any,                 catalina:       "2d72266c3af4065421f762f83e5a103d71a1c48615c1a3b4d47714f67a6fcbe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0470577731546e4afb8259b4d44b6411cfb660ea213c805f601a92deaee40e52"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg@4"
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
