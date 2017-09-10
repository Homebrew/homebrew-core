class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20170822.tar.gz"
  sha256 "b239f3c302a4c39b329835794b31a9c80da2b2b43baa674ad881a78f4fc5892c"

  bottle do
    cellar :any
    sha256 "4b4f1beef3c56eccf1bb14522110ef2758a4571c822b068831d9d0b2c6e12bda" => :sierra
    sha256 "867532f48e92fc965bd073dff7783613e1556ab416004ace51c34e74bc11beff" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
