class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.4.tar.gz"
  sha256 "9c2aa718d78f6fecdd783f08ab83b98d3169e5f670404da4c16439306907d729"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "fe96013a2cf3bc61a1b43df63b3294d239ba3def8f4d3706a6451ec1b81a54d0" => :sierra
    sha256 "3aa950749c56b12e5e9ea57199b70d08b08f74de36586f400f75aaca81dcf5b6" => :el_capitan
    sha256 "9ea2207ea35051af4b8de5d0e90b8d8f9e376e6759827896d21679f0962640ad" => :yosemite
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
