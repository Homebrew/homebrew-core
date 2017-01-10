class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.2.tar.gz"
  sha256 "b872552535e41fbffa03ba7cbcd3479c42c4053868309292e78e147b7773ac4b"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "9ff35598401ce827ea176b7f311bb5cf2260f51007f02915fb78e86c6f9e2176" => :sierra
    sha256 "ffaef9f463769872cbdaf57fd0323d416fa344c5e4f54f36d08bb4f5885a064e" => :el_capitan
    sha256 "ac714ad740db69cff490c81efe5b7f46f293f0f9339280cec1b5a77bbfa255cd" => :yosemite
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
