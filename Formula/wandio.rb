class Wandio < Formula
  desc "LibWandio I/O performance will be improved by doing any compression"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-1.0.5.tar.gz"
  sha256 "4184ef09322cfa6b685f4f453e86f74723e4e1613e8a0ea88c8538ddaef51547"

  bottle do
    cellar :any
    sha256 "e60bcff18c497ea0e9466faf177850726847098c6d0a54d6366c540e7724f478" => :high_sierra
    sha256 "caed8a09bce36cd9f5ccb4682daf2425fef364d835febee57a8becab1fcb284d" => :sierra
    sha256 "ccf0bf929eb54000fb6b6603ac853be4f4cb8c3579fe07830b7e3001b4d795e7" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-h"
  end
end
