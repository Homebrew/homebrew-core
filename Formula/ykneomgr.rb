class Ykneomgr < Formula
  desc "CLI and C library to interact with the CCID-part of the YubiKey NEO"
  homepage "https://developers.yubico.com/libykneomgr/"
  url "https://developers.yubico.com/libykneomgr/Releases/libykneomgr-0.1.8.tar.gz"
  sha256 "2749ef299a1772818e63c0ff5276f18f1694f9de2137176a087902403e5df889"
  revision 2

  bottle do
    cellar :any
    sha256 "8eaee6c402117972a2b3ec4db714594b9e6ddce1bb23c795db3650b576deda38" => :catalina
    sha256 "42dbcc5c2c3f33b3c6cfa6a87be4a37153ef68d361374d2cec410cb406a62bb9" => :mojave
    sha256 "256291cea42d30f95754e2203cec73a7acef9436be3ad0040ce7d966fc9d8470" => :high_sierra
    sha256 "7917d4068d2c68d3309b32ff443622c0540829a9e3cf0053913697c321c74067" => :sierra
    sha256 "4ee15391465d785920dde2347b716af4f9c2aa9b38faf8021d7d18f041b7c277" => :el_capitan
  end

  head do
    url "https://github.com/Yubico/libykneomgr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "libzip"

  def install
    system "make", "autoreconf" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "0.1.8", shell_output("#{bin}/ykneomgr --version")
  end
end
