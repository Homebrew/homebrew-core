class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.4.1/shibboleth-sp-3.4.1.tar.bz2"
  sha256 "bffe3e62e46d86cc75db1093b77fa1456b30da7c930a13708afa0139c8a8acc1"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "02732d1e0fceb8355fb7ee196d834dd33232374db66f13bf78b5475b7a11bf37"
    sha256 arm64_monterey: "a250892c2cdd08ba37230ca61f2d9d9cdb3d61c5300991aae6db1bb4c61544ac"
    sha256 arm64_big_sur:  "1c560ef6e9233dfb527cf85ce6e419b168b58b9c07b358efa160ed92de848128"
    sha256 ventura:        "5f7956100cfe411cc9fd4b6f2cfedeef39893e30844354ac5c825e4ff8ba4a12"
    sha256 monterey:       "1cc0e826c460ca137b4bda20563615f2a4999bb5ac2d8e618d308d653cd29886"
    sha256 big_sur:        "af5a8fa10ea9e4d9990ba641e8e3ad080e54d31264ad6eb1d93240bbb1d5068b"
    sha256 x86_64_linux:   "03ba8592aab7f9315a596ce39d37cb1e319db400ea7098dcf876c8327e4815ba"
  end

  depends_on "apr" => :build
  depends_on "apr-util" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "httpd"
  depends_on "log4shib"
  depends_on "opensaml"
  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}
      --with-saml=#{Formula["opensaml"].opt_prefix}
      --enable-apache-24
      --with-apxs24=#{Formula["httpd"].opt_bin}/apxs
      DYLD_LIBRARY_PATH=#{lib}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  service do
    run [opt_sbin/"shibd", "-F", "-f", "-p", var/"run/shibboleth/shibd.pid"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"shibd", "-t"
  end
end
