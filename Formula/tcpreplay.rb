class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.5/tcpreplay-4.2.5.tar.gz"
  sha256 "941026be34e1db5101d3d22ebddd6fff76179a1ee81e273338f533ba4eca89d7"

  bottle do
    cellar :any
    sha256 "63295be51e0bd4b572ce2e4f17679decb990ea48058aa5bdece6a6b108c6f681" => :sierra
    sha256 "0b9515ebc8b05696d9de14c7a245ce35ce644e21083f4a66b2079163bbf3c4ce" => :el_capitan
    sha256 "40f257f58f9949936289043317a345e717f0ea9ac33a197af249858574f5de7d" => :yosemite
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
