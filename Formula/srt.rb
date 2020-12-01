class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.4.2.tar.gz"
  sha256 "28a308e72dcbb50eb2f61b50cc4c393c413300333788f3a8159643536684a0c4"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "78f263e929cfda664c6c80dce3902f91994a333daa3204c59d5af6507e208e95" => :big_sur
    sha256 "4d194b3700a8a66772175193fe43a3e6dfc4edc96dba84c5ccfe505a327a2dc4" => :catalina
    sha256 "2452cf8d9fc6eead38676dc6f70f83493716fd89b620c8b71b53c8e340ae319d" => :mojave
    sha256 "34a56a324d053ad9ae552c75c8ba3b4289934af552e91d3d113df4e6ff67cd6f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    openssl = Formula["openssl@1.1"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         "-DCMAKE_INSTALL_BINDIR=bin",
                         "-DCMAKE_INSTALL_LIBDIR=lib",
                         "-DCMAKE_INSTALL_INCLUDEDIR=include",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/srt-live-transmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
