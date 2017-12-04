class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20171204.tar.gz"
  sha256 "556596a138b6a403fbe105affdc7beb8fa98e292767304378c8308fa11b73529"

  bottle do
    cellar :any
    sha256 "04d9df2927a34376892fdaba7eeeeb3afd577a19baaa45f16394da5bb5fc725f" => :high_sierra
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
