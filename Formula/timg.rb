class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "3c96476ce4ba2af4b9f639c5b59ded77ce1a4511551a04555ded105f14398e01"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2aa49e177be79d8150d6d58b5564915299707ae1adb47231c9b58ec8528a904"
    sha256 cellar: :any,                 arm64_monterey: "ef795a7c82472824ae61684368e12b7a0eb58df7ce0c136aa2613f3e7c32e138"
    sha256 cellar: :any,                 arm64_big_sur:  "f44efd3cbe12f48d032d503b2e0c345e197c02cd456f8aacad74948ffac5d2f8"
    sha256 cellar: :any,                 monterey:       "f6ea386ca6e7628af83126a6fd0ca086253f45bab54eee778db82205511e3822"
    sha256 cellar: :any,                 big_sur:        "1bc9709aa7fe5ce23a8914cb145d0c86f5d72ae41778e966ac834300b894bde1"
    sha256 cellar: :any,                 catalina:       "c980eec1ad0955196bb6d11450dbe6122b7ac6123a5c455f05e74786901b3cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e6401589698af47c0bf9323cf49606e9ab074d9089da029803ca06239def967"
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
