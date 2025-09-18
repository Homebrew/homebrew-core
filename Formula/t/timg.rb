class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  stable do
    url "https://github.com/hzeller/timg/archive/refs/tags/v1.6.2.tar.gz"
    sha256 "a5fb4443f55552d15a8b22b9ca4cb5874eb1a988d3b98fe31d61d19b2c7b9e56"

    # Backport support for FFmpeg 8.0
    patch do
      url "https://github.com/hzeller/timg/commit/158e465da4a5ab1aa5af855dae3f1aa78b731a23.patch?full_index=1"
      sha256 "6204606c02178d4afff6c22cbe7d38784602c49c66e73f1980f5cdfa375723a7"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0d90bcae4283cf4bc0ad914df5c2d2ddbe9e1473cc18fa0463c6321c228f9723"
    sha256 cellar: :any,                 arm64_sequoia: "44fe7c963249e79c47026c8183be7c7e930a6cbd9d4f413782691cd119ccc9e2"
    sha256 cellar: :any,                 arm64_sonoma:  "cc49b201ed92aae26f956ba474679024d89bf3733643d0698c888bdc7df73815"
    sha256 cellar: :any,                 arm64_ventura: "08971a6483522c51da06ed0b1894f03901276a66aa753940182df01d7dc162f1"
    sha256 cellar: :any,                 sonoma:        "54e371e256646fddea9cdc752198fb10c50423bbccb66e71d128c367f2a216db"
    sha256 cellar: :any,                 ventura:       "0cc3d5aaedb27e74ee0ee2792377ba423879e0fcc532ef5ec5f75afb5c1347c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61dc9fe1ee8b93499091ca39cde2b895eb6aed3bf6c1e59a66762f76264e794d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f8acbbdd54951fc1ffaf513c26621a3c01619a59b93b07f679df4119b5e1f0"
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
