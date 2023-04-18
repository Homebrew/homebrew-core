class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "3c96476ce4ba2af4b9f639c5b59ded77ce1a4511551a04555ded105f14398e01"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98de11a20c1dbe896286ee35fc9ec12c266650c63d7a0e57df66476683e26959"
    sha256 cellar: :any,                 arm64_monterey: "202b3f03024ef84c6a08d1bb5bfba86440b94c147a8fdcebe19e6f7ed7342825"
    sha256 cellar: :any,                 arm64_big_sur:  "34ff35a5d99a0fdc651819cfd4e6314e5451c09a3ee7f9074a0ce1fdb8edfefe"
    sha256 cellar: :any,                 ventura:        "171417102b5c14e70cd720a8808232304c9bf6db5eae5c939c50d6f88bdfb81b"
    sha256 cellar: :any,                 monterey:       "865bb3b2651f6ce8fa7af91816b0acb851b95eb728f60cbfe2a637d124d11c6c"
    sha256 cellar: :any,                 big_sur:        "918d2e04e40591d7b501c790f67ba3fe274558103168b8e8370931dc9c05e01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e343a40d3196e3500255ddec01cc22f83104911359b1d3772c9ac7a5b18146f5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
