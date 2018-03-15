class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.2.2.tar.gz"
  sha256 "7a167cfe9f3a497c8d9483f25873fe63273c550aaee1d2bbb9d7bf39f169efcc"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "b7ca3f37963f4bbeeeadf3a5902122770928e096552c3655208de40ab250131e" => :high_sierra
    sha256 "9a5e297f60b445aee785f9d8ae40843d52c4314e6a68ff53b69d2f57efdedbae" => :sierra
    sha256 "0e3bbfd2185fa06624b9e62a3bfaf303b5ffe7ca6db61b636b83eedf120b6db5" => :el_capitan
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
    system "#{bin}/stransmit", "file:///dev/null", "file://con/"
  end
end
