class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.4.0.tar.gz"
  sha256 "31ed26253943b9d898b936945a1c68c48c3e0974b146cef7382320a97d8f0fa0"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d4a310199a7b40dea729051d4dbc6fd44480d29d2ef619f6ad3a0d7d86e9762e"
    sha256 cellar: :any,                 arm64_big_sur:  "1edca89e855c54de431b99ab1f0a083438b56d56a770ef019f3638b69a3cbfae"
    sha256 cellar: :any,                 monterey:       "9e3aebfe4d65aa4acb6e16343f58b4fe26159a4ba4ae2a6209911147f16d8f77"
    sha256 cellar: :any,                 big_sur:        "667267cd379da8478b31574c5e25bf3f8e150c6f80ab59c2278bec042c71c7aa"
    sha256 cellar: :any,                 catalina:       "5607031eb5776de5b4a68e8c50f312771cae89e8b2266df60718b2e07e35d070"
    sha256 cellar: :any,                 mojave:         "9906d0abfcd17c86df23c18b1ed112de0266ccbc7a50c24f741f78bffa552540"
    sha256 cellar: :any,                 high_sierra:    "c89edde9d9229dbe524d28b661265349af72a2dac0b85f066751d4716effe1ab"
    sha256 cellar: :any,                 sierra:         "2f24051eb854a2345e88a1e023aa76fa6c2cb7522ec0fd7644af15694b456f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86dc964a1409f31c97cde673a4f6862af83e38bf7fc67636499eaea916a67f68"
  end

  # The SPDY protocol itself is deprecated and most websites no longer support it
  deprecate! date: "2020-07-05", because: "is deprecated and not supported by most websites"

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
    # With deprecation and lack of sites using SPDY, just test for failure
    output = shell_output("#{bin}/spdycat -ns https://www.academia.edu/ 2>&1", 1).chomp
    assert_equal "No supported SPDY version was negotiated.", output
  end
end
