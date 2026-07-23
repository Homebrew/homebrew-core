class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "59c908867f18c81106385a43065c232e63236e120d5b2596b179ce56340d7b01"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29d6beebc4277ef79f9d14c083fa370a7b929b03a769d676ac9b2bb87964ed68"
    sha256 cellar: :any,                 arm64_sequoia: "0c8ee925cc198a9795f2ff70674a1ef3cbc8bee913c5d9372babe3ab74120b54"
    sha256 cellar: :any,                 arm64_sonoma:  "1e322a578c3f81fd6cbfcb27dd55dd5f9504525668abc56590ef155d0eaa65ba"
    sha256 cellar: :any,                 sonoma:        "2bdef3af0e1ae32d4e893d6f8d5984bb1568b9f36e3d91276dbf87d40d7abe3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "318dbf7ec1b15f1e72f684b4d8b749ad81e777e3149d5f86a27956f46c79205f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83740c7f5cc8839d160a8c269e5c4a483e50c0869213a73dd82abecd0ab389bc"
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
