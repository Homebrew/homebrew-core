class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"
  revision 3

  bottle do
    cellar :any
    sha256 "5607031eb5776de5b4a68e8c50f312771cae89e8b2266df60718b2e07e35d070" => :catalina
    sha256 "9906d0abfcd17c86df23c18b1ed112de0266ccbc7a50c24f741f78bffa552540" => :mojave
    sha256 "c89edde9d9229dbe524d28b661265349af72a2dac0b85f066751d4716effe1ab" => :high_sierra
    sha256 "2f24051eb854a2345e88a1e023aa76fa6c2cb7522ec0fd7644af15694b456f27" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    ENV["ac_cv_search_clock_gettime"] = "no" if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"

    Formula["libxml2"].stable.stage { (buildpath/"m4").install "libxml.m4" }

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Check here for popular websites using SPDY:
    # https://w3techs.com/technologies/details/ce-spdy/all/all
    system "#{bin}/spdycat", "-ns", "https://www.twitter.com/"
  end
end
