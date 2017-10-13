class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.2.2.tar.gz"
  sha256 "7a167cfe9f3a497c8d9483f25873fe63273c550aaee1d2bbb9d7bf39f169efcc"
  head "https://github.com/Haivision/srt.git"

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
    system "#{bin}/stransmit", "file:///dev/null", "file://con/"
  end
end
