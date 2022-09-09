class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "66d2e00b50068fd6638bb8be1859c50ca4f24caef751f9dc95b303f37fb07b1e"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "544ece49b78ce94cc86b051f79c7d482a422f703eb6a6ac9629cec6e407ab636"
    sha256 cellar: :any,                 arm64_big_sur:  "0194db39ce6bdd677cbe6ab0fb0ae04f15079d59966714c8452e1a2e6fb0f552"
    sha256 cellar: :any,                 monterey:       "32c07c228f70b47fa944f87c6c966a4eebac41cfc82df9670af9aeabae465e53"
    sha256 cellar: :any,                 big_sur:        "072b04b7a2888e2d2b5e3b727cb915a757743d3b4eb7b7e28df4f78d7ee06c10"
    sha256 cellar: :any,                 catalina:       "476d093d5d8b40f92b8aaa050a5dfa071b581e1cf87fa3c1820c71c8d7a8f620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80bd1ea0746bbe5a216c29ebb345631329ec9cf2a5c3b1c2e90bad48bb7752e5"
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
