class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.3/tcpreplay-4.2.3.tar.gz"
  sha256 "68d8d49dab5bf58b2e8d244eee1ee7f2379d967da19fe97dd9d59bcf40a22abc"

  bottle do
    cellar :any
    sha256 "54e2b91bb468a674e6bf95b4adbc4d1f039188732c5e89585b68a0846f0afb90" => :sierra
    sha256 "c3084c304adfee6a233383728f4554a4769fefb88469e3abe25e6beecd1c40eb" => :el_capitan
    sha256 "f005808bcf60fae4867515463204419b233927a7268fd491718adfb67aeed45b" => :yosemite
  end

  depends_on "libdnet"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
