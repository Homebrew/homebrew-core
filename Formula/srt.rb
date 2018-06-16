class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.3.1.tar.gz"
  sha256 "f202801d9e53cd8854fccc1ca010272076c32c318396c8f61fb9a61807c3dbea"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "d9dcee275c311bbf3a042b3dece0d6e49f2280748fbb8202c859c5140a344982" => :high_sierra
    sha256 "2dacbc47b25ece470530896e24817161d7b5bfe069dc304fedb7d8dd374ca811" => :sierra
    sha256 "fc80f8ad53aba6ffe5daf0de2827e3adb44066d97fa1e705c906bd305c427134" => :el_capitan
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
    cmd = "#{bin}/stransmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
