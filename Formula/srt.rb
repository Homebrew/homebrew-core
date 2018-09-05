class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.3.1.tar.gz"
  sha256 "f202801d9e53cd8854fccc1ca010272076c32c318396c8f61fb9a61807c3dbea"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "ca1d4f269452d216938ca7617f83eeab8c47ea51d3cd4bcb5a9fedf514a4aa3c" => :mojave
    sha256 "848cb1edeaa90be70ddd2000c79f42432d881de53f4a47e00876c728b45f4fb8" => :high_sierra
    sha256 "18ada4492fb671487fca41eeaaa8dcae9ebf7d096f2becb7894b8d215c7615ea" => :sierra
    sha256 "52267ab27bbc19a52285505d7f9630c990cb6ed3ef5abd233bfc1a8c92b864e6" => :el_capitan
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
