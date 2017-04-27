class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.4/tcpreplay-4.2.4.tar.gz"
  sha256 "da78ea1a1fe8ff177a4f9e71c4c6739b79ac86db2c2bb90955318b8e8439beb7"

  bottle do
    cellar :any
    sha256 "f887e8b25cf52bfb59e6ebdf7b7f556de6683080283ca87f7dbc677b3b89558a" => :sierra
    sha256 "546cc1eb8519c457d65cfc2bcedace7cf7075876fcb1872add165aef8a383c8b" => :el_capitan
    sha256 "7ac09c09e8f0f7004b9c84356492f652a395bebe76ab3ffd6e6b29c31e291838" => :yosemite
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
