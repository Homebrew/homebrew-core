class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.4.1.tar.gz"
  sha256 "e80ca1cd0711b9c70882c12ec365cda1ba852e1ce8acd43161a21a04de0cbf14"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "bbadac0b96337c84604feba7fc654cf1c1bb8040a616e0ee2603e580da5e5df5" => :catalina
    sha256 "5a689897fa108ad3976d609fba6b9233e1cdab7eab5e90a45ec6b52e899718c0" => :mojave
    sha256 "01039fd82d968be00949e93af2e1eb5ad16152099975e1e00d355641b7eacd01" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    openssl = Formula["openssl@1.1"]
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
