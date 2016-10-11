class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.1.tar.gz"
  sha256 "88fcb9af4ba52c0757ac9c0d8cd5ec79951a22905ae886897e06954353d6a643"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "a8baa8e1290de5c92396b14da4128a427ac03b2f46c5b3b2daf3786590c86405" => :sierra
    sha256 "2149bd6737507fc48a8eb8cc9b664324f616a97a59f69884870c605452521881" => :el_capitan
    sha256 "1caa3cdda0a9b3ff71d776358195e975d5f368894f83887e135f6b89bebd57f0" => :yosemite
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
