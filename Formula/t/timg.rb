class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "a5fb4443f55552d15a8b22b9ca4cb5874eb1a988d3b98fe31d61d19b2c7b9e56"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c8350f7fe1ed4dc4442b36edf9bed57cc7f91d8ed216a23e5b70fd5e094ca6b"
    sha256 cellar: :any,                 arm64_sonoma:  "68666166df0ec18cea0727596196fbde09525e366acbc96f280900dee189e1ab"
    sha256 cellar: :any,                 arm64_ventura: "efa5d590ef38f66e6abc82b1d93d5b25b709d8a7ff300c339e82cb646c97cc42"
    sha256 cellar: :any,                 sonoma:        "2b7b02c5c71ea66fd8343fd1d2bd3a48921f5f141ab3475f3504daa7b1aca7f5"
    sha256 cellar: :any,                 ventura:       "6709b3b50e2e5b42fdc10979f0e54cbc8961f5cb4114689cdf2835738f4ebf72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5382f40353ec7c2e43e38966dc4a859a5ef032f98a6858b76dd76e71cae8a1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b3b2f667e0ce20d21fba8ada97bc1d4c41a4d00171bdc67a4d7b56e062f6dd"
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
