class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "46eac8d5434b281afa6d64ced5f46c732c1c4d0699e16a22175b7df179221e2c"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "531c30dd7c35e063b3275906ed52852787515e919aa0509061e8f6aa9d104b29"
    sha256 cellar: :any,                 arm64_big_sur:  "da011715f8a4d17401ae07f6df5785793ce40b3427ab2614aefe37004fa785aa"
    sha256 cellar: :any,                 monterey:       "a463826c4fefc87b00b263f20089bc19ea9ed9a03e06bc3a6cb54c656ce3da22"
    sha256 cellar: :any,                 big_sur:        "4b3469d10b9bb86a593d712e336b668bfb7c4182d095394d17ebee6431673f32"
    sha256 cellar: :any,                 catalina:       "a5e09b3923a28853aabc4538f84891ec9d7b4a80b9996873bfd0bd9cee2ae0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f2282c858059757eecbb0546315b00966f67baf5d48b732be29683350c5bff2"
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
