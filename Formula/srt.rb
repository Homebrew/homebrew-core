class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.4.0.tar.gz"
  sha256 "c2ba0bb9382ab42f9eebac831dc021e7da26b2971aaeb30a891dd24297bd929c"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "4677542efa6b3f2ed07342dcfd7c02594ec47f7789f6b1dbdbe0bcc17f4d3b68" => :catalina
    sha256 "f0c82082de31196e38d8d9b93dd991ec57ed020b50739d447e27496555575f01" => :mojave
    sha256 "cb53f2eb06f79bdb840af4396220303c4c9279c9bea90076fe13f23949dff89a" => :high_sierra
    sha256 "6075ef4880615220e11550c6bf60d87ee426eaaac0bb4e65e1f6a65a34ad1f55" => :sierra
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
