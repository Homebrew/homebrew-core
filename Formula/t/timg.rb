class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "59c908867f18c81106385a43065c232e63236e120d5b2596b179ce56340d7b01"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "78332097424ff280db9f9c94370942017c542f0cd30fe090cf7e4459cbc2fb60"
    sha256 cellar: :any, arm64_sequoia: "f59fdca979f3257b299eb7310b5c4379ec1a3c37a22c8ae684f7ce07dae4a896"
    sha256 cellar: :any, arm64_sonoma:  "8e499f724ace59217c4f8f6915710f5b07f68b64aab5e4249ac18e4f2ef7d8fe"
    sha256 cellar: :any, sonoma:        "d38851084b2c94bfd4e68dbb8c5a77aacda5bf5c0d83ea8301144f90b9a3f4d4"
    sha256 cellar: :any, arm64_linux:   "f9c3b81e2601b71b40c1a991e41a78fda4db36d8d559374e36f1e1a147f0a1db"
    sha256 cellar: :any, x86_64_linux:  "13dce32e5a416b027a52c2a88d8f79b4481671e2a89b0f7eec5ce47919b4e631"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "glib"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libdeflate"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libsixel"
  depends_on "openslide"
  depends_on "poppler"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"timg", "--version"
    system bin/"timg", "-g10x10", test_fixtures("test.gif")
    system bin/"timg", "-g10x10", test_fixtures("test.png")
    system bin/"timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end
