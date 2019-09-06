class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"
  revision 2

  bottle do
    cellar :any
    sha256 "76a0e5189b47fb03227ee27b1bd9a3436e2cde74a60832ac6a144f81fa30f191" => :mojave
    sha256 "580068545553ba1d4467c46cbb59abc6559e22b13cc64724c37e32b432329ec7" => :high_sierra
    sha256 "915b165ccfbf98e8887334ea7ba70ce11ba3bdc100117c0106846bb819c34833" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

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
