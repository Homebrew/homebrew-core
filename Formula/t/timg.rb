class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "9e1b99b4eaed82297ad2ebbde02e3781775e3bba6d3e298d7598be5f4e1c49af"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a32eb799df975f94b44693a2ee31dccbd4cec2496b3ac1217eeb0a48b6aa037"
    sha256 cellar: :any,                 arm64_ventura:  "12d373f0c17e24c6a6710d50143141259c4e8020a25a81158c3ecd474ab8dff2"
    sha256 cellar: :any,                 arm64_monterey: "8e204f86a5698f3ab748a00dad7d4c14a61966ea0604cfbfb06f0c1b558d0a52"
    sha256 cellar: :any,                 sonoma:         "970bd1b59c978fcec647aa39006d7921e04fd7f5b584d6b6e930cd561f1feb5f"
    sha256 cellar: :any,                 ventura:        "de063a275cf14f58250b8c1affa76b4072110e5258c32a1d7a9f0c7aaaf39cc2"
    sha256 cellar: :any,                 monterey:       "bf032b93294b7acac48cb7503416797e6ca75484af24aa00df8afa8165362a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3e4122d5346417f331078d1351cb075dcaac05e90751962a074686ef5c5ea0a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
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
