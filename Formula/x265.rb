class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.1.tar.gz"
  sha256 "88fcb9af4ba52c0757ac9c0d8cd5ec79951a22905ae886897e06954353d6a643"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "875cea552176a4aa274e2acf35abbfe9ff5d4f28bdcbd086a40cf1a7e2b578eb" => :sierra
    sha256 "d4b0f634811f8f44d26628588b6d8bc481c1f2e25b6ac2116767d231caf58b28" => :el_capitan
    sha256 "94309db8f594dc0ea1156351c45c3e6533a95004058075db40c15ba5d313c1f7" => :yosemite
    sha256 "f5e6acc3c8c4ba5c2e045663dd8ee667bf997e1b8a7d32093b7539945c101ca8" => :mavericks
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
