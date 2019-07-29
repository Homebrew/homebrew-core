class Usbmuxd < Formula
  desc "USB multiplexor daemon for iPhone and iPod Touch devices"
  homepage "https://www.libimobiledevice.org/"
  revision 1

  stable do
    url "https://www.libimobiledevice.org/downloads/libusbmuxd-1.0.10.tar.bz2"
    sha256 "1aa21391265d2284ac3ccb7cf278126d10d354878589905b35e8102104fec9f2"

    # Backport of upstream security fix for CVE-2016-5104.
    patch do
      url "https://github.com/libimobiledevice/libusbmuxd/commit/4397b3376dc4.patch?full_index=1"
      sha256 "b28e17c82dc11320741d33cf68fd78e1baec9e4133f5265b944f167839cbe9bb"
    end
  end

  bottle do
    cellar :any
    sha256 "2305d6794314c64d0fb8c3339c2d75a8e01d218715bc871560e4fe9fcad486a8" => :mojave
    sha256 "253be465f391159e278a0a9625775075503f75b0a404aa64b9f557486de3b82c" => :high_sierra
    sha256 "37a70014ca7c861639b8dc0f280b66306c082091731dfc3a53d1ef709ab98d5e" => :sierra
    sha256 "e7227fb7deaefc2990e23d9cfdb3aa4305fc7f31e902560fa46272168c85e151" => :el_capitan
    sha256 "0aae53db481257e6ce5eed9be080b63b347f2e05d5dfecc55b0936a9ee5ab336" => :yosemite
    sha256 "e36b16d09c26e83daf359216a9b66fd2515a10d7432fdcc724c7aba5224f19b1" => :mavericks
  end

  head do
    url "https://git.sukimashita.com/libusbmuxd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libusb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iproxy"
  end
end
