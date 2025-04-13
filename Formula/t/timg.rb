class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "08147c41ce4cea61b6c494ad746e743b7c4501cfd247bec5134e8ede773bf2af"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd86d8ab997a80cb1e6067cf38c13b7eadfee02bd266e586bffbbfeade93554a"
    sha256 cellar: :any,                 arm64_sonoma:  "dddce59f7d705fe792f556cf2e148dada0ed503b432c695ca286ddb48d926367"
    sha256 cellar: :any,                 arm64_ventura: "db65c04c43af07594e071cf569f6aa299936430a10e98de55f53d25c2e9fa177"
    sha256 cellar: :any,                 sonoma:        "8b9ddad7d1afa24b2d00ba104ef910e07faffce6a211d06ec478605fdbe272ed"
    sha256 cellar: :any,                 ventura:       "2decdb120bb52f7f2080c2526e9f227313d94ab8d6680478ff5de4e465afbcb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b542a752faf9ce910ac5b5c4c9737be3f5a570eef15305433da55a96d7623f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3feaed8c8bd6d7ec821e675f9c9182bb29e0c514ddf2e6dd630ab41876cf74e0"
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
