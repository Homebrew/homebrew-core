class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "80efc260b1550e7e179ffa3bbdaf9306fc84744021d1bee32c46dd6ff57fae3e"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "10191606a5e90f4005d59dd1061a76db350acc9b21bc43626aac3638a31ce4a0"
    sha256 cellar: :any, big_sur:       "60387df53f5f7fa3b8f7b030f857dd8812c61ee9a91c2ae077df9badd75e9847"
    sha256 cellar: :any, catalina:      "8c7da5f45ab920841a8266ddcc237aea7d2e450478957b08cd10f6525c5233ca"
    sha256 cellar: :any, mojave:        "7dfe97f79d88e43772ae3257ba6cf3088a928e886d1b65c25130e6271fe7828d"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "webp"

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
