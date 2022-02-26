class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "66d2e00b50068fd6638bb8be1859c50ca4f24caef751f9dc95b303f37fb07b1e"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "de4c65235281a2b9c5d62d28fa39053e21f30c4852ae3f6a0cb419a5ef4231d4"
    sha256 cellar: :any,                 arm64_big_sur:  "da8576af220bdd5052fcd031c0e2b0e1fb206d449c40354f72d10dfb5d9c6d7a"
    sha256 cellar: :any,                 monterey:       "f9f639aac4e106fb0c3ab2f4776acee6d6423f4f497491f334e43547e734ccea"
    sha256 cellar: :any,                 big_sur:        "0efbad0c7a082200d97ec158e1934362d82f5db03aa1130f8ea54088b73c478b"
    sha256 cellar: :any,                 catalina:       "5a2f9661a9e5ad1ada45486c2efb99a16f070f955d373cefdb63a6c9079e8b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c173cd55ef26536b606b64e5044777732fcf67b625d17f6c430947325e8f2ec1"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg@4"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "openslide"
  depends_on "webp"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/timg", "--version"
    system "#{bin}/timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}/timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}/timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end
