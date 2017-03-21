class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.0/tcpreplay-4.2.0.tar.gz"
  sha256 "924f80cd1958a4c4447f0a6a54e8d3af7aebd3674aa4ef9973f69b43b1675221"

  bottle do
    cellar :any
    sha256 "2da5173423553488b9ba3ac6bd0feab263f4b4b348f0bf40eb5ea7529e636023" => :sierra
    sha256 "9abeb3831fff0b33e3730ada375a4292eac1e1dab20b0c87f94549b883ac2fdf" => :el_capitan
    sha256 "ddc0e2d0c85a4649becfcb8ce03acbe47a60c4fe3b375cf7673b5d7160040ebf" => :yosemite
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
