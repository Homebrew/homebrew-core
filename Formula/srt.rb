class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.4.0.tar.gz"
  sha256 "c2ba0bb9382ab42f9eebac831dc021e7da26b2971aaeb30a891dd24297bd929c"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "775311e52cde0937eb3d2082b080ea023673bedf65c044fdad67b1740e7f5fa6" => :mojave
    sha256 "3d8ec15e6670482c6ced3d98cd6dfc4726318d9b4d1b37d2ea00692e01a1b778" => :high_sierra
    sha256 "5b305e2360bb7ec1f0d6e6154b42d5dbc0face555e9e7182aac6be7def0dca77" => :sierra
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
