class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "ac8905e4615d964eee6b014b9ff3413160cfc5b73f547e91736bc06c928ac811"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa3f8b23df7dc319c58c90138d417af36c8dd8628007b4ef3146b41464fed70b"
    sha256 cellar: :any,                 arm64_monterey: "12f5d3fd70c318c986b3f625887759f8e4d7ebb36271167a2e3ebed765c499c4"
    sha256 cellar: :any,                 arm64_big_sur:  "354d9e376fd40c2906119ed13ab988886156b98499ccf969bf8fc6eb14edc2b9"
    sha256 cellar: :any,                 ventura:        "99e8d4d27f5a6734d9c40aaaac9c4e209866d5af262b19f74929e8b6b3468de9"
    sha256 cellar: :any,                 monterey:       "9d5acb578bd3900210531c883b45e88eec76c159500c375e47aa088650059c8e"
    sha256 cellar: :any,                 big_sur:        "7c5b249dd53ccb12ad4028a632e48b80a4d1a53dc9ee999f9fefe92e4a0cb001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea526ecc96da2e3bf3d6c73ff9df46e851ff33ab1849ca2cd77c3f2ab99e963"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libdeflate"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libsixel"
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
