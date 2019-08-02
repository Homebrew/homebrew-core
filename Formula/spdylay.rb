class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"
  revision 2

  bottle do
    cellar :any
    sha256 "10d813d333390d5e8264362de2085e3be8419730fd2333b8101180057f9e485e" => :mojave
    sha256 "9cb131c7f3205acdf923fd3a978a421f99af649d6262698395e458b1a2ef442d" => :high_sierra
    sha256 "02084694808e70244e96c4aca7c1351e135215c28375ef84f83d1a86b0324ec1" => :sierra
    sha256 "613ca2f401b491abe6d16eb51dfe1d955d7e985d04fc82950633c807f15b017c" => :el_capitan
    sha256 "c4fe31125eaff34fca1a71d7fe923d9e0fe3cde230df0fba0d9bb2c2067ea493" => :yosemite
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
