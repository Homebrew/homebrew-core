class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.2.3.tar.gz"
  sha256 "81c728c04732b79e350ada51a8d54021906ee3e910e798e2968091a6f6b86eff"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "cdee26c726e59591902ac41938fec5228bd744719bbf2921d3d2595d5e50a092" => :high_sierra
    sha256 "f57690fd8c02044a5186e293b41d46e0ad358a175ac0bf66426a5999a106b7ad" => :sierra
    sha256 "ad9789b5dd5d365b6087a339bf7f99f526da7962883f99ee762cd3e0e8d24233" => :el_capitan
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
