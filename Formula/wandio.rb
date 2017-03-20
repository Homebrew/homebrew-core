class Wandio < Formula
  desc "LibWandio I/O performance will be improved by doing any compression"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-1.0.4.tar.gz"
  sha256 "0fe4ae99ad7224f11a9c988be151cbdc12c6dc15872b67f101764d6f3fc70629"

  bottle do
    cellar :any
    sha256 "18377dd9738246878e3357ea95e0164e7ec2f66eab9708b662a5961678355873" => :sierra
    sha256 "a05a9f0b56ccb80fd8de1cd2d3921a08599b88bcd9e9770df81a5fddf2163d24" => :el_capitan
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
