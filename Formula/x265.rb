class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.5.tar.gz"
  sha256 "2e53259b504a7edb9b21b9800163b1ff4c90e60c74e23e7001d423c69c5d3d17"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "e5533fb7b1c32a7bfcd95495eb17388b68e848cd87884bc22dfa6e0f5dfd1dca" => :sierra
    sha256 "eb45d06b00b7da14f508291f20add9892db9cbcc08a8ebfb29c2bf80a46be394" => :el_capitan
    sha256 "a715de311bbcfbcc65353681a5665d395230b2f70e27621c088456f5490f4328" => :yosemite
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
