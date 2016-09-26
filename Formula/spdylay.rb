class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d2cc6897f06a167b4693f0dd82517d1d62585e62ee085c55440221c1e8ab280c" => :sierra
    sha256 "e5697185ba673e6bea9ca829c173611a7d54001276c63ac25bc0a4d8eb27b86d" => :el_capitan
    sha256 "7941300edad0919881502d991886af07479a0c52dc06f04c1b66170f34cca6ed" => :yosemite
    sha256 "2c93e33dbaedf67e7badf73a35c28ec0abe930bc8e53ad87d990394384a563ac" => :mavericks
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
