class Sparkey < Formula
  desc "Constant key-value store, best for frequent read/infrequent write uses"
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-0.2.0.tar.gz"
  sha256 "a06caf23c64e7ebae5b8b67272b21ab4c57f21a66d190bfe0a95f5af1dc69154"

  bottle do
    cellar :any
    rebuild 1
    sha256 "035ae7c18eb13ee8ae2167aafecade136cec43816aeff76df790f7a5e3350408" => :sierra
    sha256 "fb1e14e774cf28b43cda024e73aa1201967dfa3c8d192500e56b3d42bdf41850" => :el_capitan
    sha256 "40bb3d9f1937bcfc3ddb1608228affa3676bafea61665f9aa1525936d2887260" => :yosemite
    sha256 "b7a5df3013850fbb10e2e46ffde968972bed654dfab6964784b7b2b00b054e2d" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sparkey createlog -c snappy test.spl"
    system "echo foo.bar | #{bin}/sparkey appendlog -d . test.spl"
    system "#{bin}/sparkey writehash test.spl"
    system "#{bin}/sparkey get test.spi foo | grep ^bar$"
  end
end
