class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.3.3.tar.gz"
  sha256 "fb2e50c027ebcf32f8ebf6525a29a15e765c7a94efb52ccc3c770a0384b1fbaf"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "27ca171a4c95ce4048fb55ede0ebefa98de2922ae843f2d592c02e07e18e5234" => :mojave
    sha256 "7b292fdf1a31d7b8a11abacb6bb03deed8b5729971daca91b20b7e03011d4e4a" => :high_sierra
    sha256 "ac561d9e33e57ef6dcd5ba37261f4ba8a94934eecff1e6598519e43464811c00" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    openssl = Formula["openssl"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/srt-live-transmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
