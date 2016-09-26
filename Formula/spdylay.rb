class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"

  bottle do
    cellar :any
    sha256 "bae2c35d625b384d3cc2c435dcac0ec70411fae460c67954088f139db1a9eb28" => :sierra
    sha256 "9ad6868ba79f087c9ea66eb2289251c097efbd4ac658212778f8ae1280395c31" => :el_capitan
    sha256 "cfba9690f38798808ef1f4bd69c32145202073fffb9fd88eb25c487cd1cb53d5" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent" => :recommended
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "openssl"

  def install
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

    if MacOS.version > :lion
      Formula["libxml2"].stable.stage { (buildpath/"m4").install "libxml.m4" }
    end

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spdycat", "-ns", "https://www.google.com"
  end
end
