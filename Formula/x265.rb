class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.4.tar.gz"
  sha256 "9c2aa718d78f6fecdd783f08ab83b98d3169e5f670404da4c16439306907d729"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "e7c5b8ef30d7a35320f64b78f3e5a1b6c1533671db0ce6e71059c043dcec4ae2" => :sierra
    sha256 "c4a0cab05a2af4df79c4f1728a7b7d091eb5d8a76ca410a92bce65fb8974cd36" => :el_capitan
    sha256 "dff03fa4ff6a0eb2e37cd7e262ef4f265cf7d54efb49fefea10e85303c41fd26" => :yosemite
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
