class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.0.tar.gz"
  sha256 "5a7f6797bee33310c690be5d9a6c63125f36663ac3478e98ac6b6142a70bce1f"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "2e13c1ef59fd23193c577de8819858fcebe755e40c0448bdee423a2bce0e6e4b" => :el_capitan
    sha256 "962bad9f05baa67d0e911ce7eb08cc92ad77a6d8124a61af5aa03467cc3cd9f3" => :yosemite
    sha256 "3b889f2c294fd916c51699eed1d3c80f9acb28b25d07ebcd71f36ed6410eeabb" => :mavericks
  end

  option "with-16-bit", "Build a 16-bit x265 (default: 8-bit)"

  deprecated_option "16-bit" => "with-16-bit"

  depends_on "yasm" => :build
  depends_on "cmake" => :build
  depends_on :macos => :lion

  def install
    args = std_cmake_args
    args << "-DHIGH_BIT_DEPTH=ON" if build.with? "16-bit"

    system "cmake", "source", *args
    system "make", "install"
  end

  test do
    yuv_path = testpath/"raw.yuv"
    x265_path = testpath/"x265.265"
    yuv_path.binwrite "\xCO\xFF\xEE" * 3200
    system bin/"x265", "--input-res", "80x80", "--fps", "1", yuv_path, x265_path
    header = "AAAAAUABDAH//w=="
    assert_equal header.unpack("m"), [x265_path.read(10)]
  end
end
