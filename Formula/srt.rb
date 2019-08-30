class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.3.4.tar.gz"
  sha256 "d3ddf3ad89eb93a4dbf44046775eb63e04780cc536781490d65321d78d4b19de"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "2a860e3f144d6f2c8b832dc8a2c24fb368da3b6cf6a015444505956785e5374d" => :mojave
    sha256 "659f0ef3e17e6b28d7a4a0b93fda589bf93ecac075e84b7d3da49f1e0327955b" => :high_sierra
    sha256 "408db415206b107cfffe5449e394fd71600320f124701615c226db7421247606" => :sierra
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
