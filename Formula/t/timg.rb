class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "9e1b99b4eaed82297ad2ebbde02e3781775e3bba6d3e298d7598be5f4e1c49af"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f97d66cd02faf6dd2327e02ec3551c2c697388be68b368802be35c6fcad64035"
    sha256 cellar: :any,                 arm64_ventura:  "7f31b2c44512515e976377d4fd697491b10ae79a2834c3c5a795d297ec02bb2a"
    sha256 cellar: :any,                 arm64_monterey: "0166ae9896c4db5a02d71e66e6fc5f0af3436ecbd908a361ca7b8b1caf3fa1d6"
    sha256 cellar: :any,                 sonoma:         "1a130b51bf0197035bcdaad8c6550b440fce44fe3d02e9b2d11a5dda9b4fc18d"
    sha256 cellar: :any,                 ventura:        "6a2f343e80bc905eace4a7215b9d02f29cc49174ef3cc09a7296c01e3aafdaee"
    sha256 cellar: :any,                 monterey:       "5b0c38c92e453255bc7e9f86a6da90442bc97670471cd6b92896445fa86890e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc179e4ac7e3efe1bdbc03eb18cf011c7bcc8fb9e55e1f1e84f6e77188ed712"
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
