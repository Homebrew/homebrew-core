class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.2.3/shibboleth-sp-3.2.3.tar.bz2"
  sha256 "a02b441c09dc766ca65b78fe631277a17c5eb2f0a441b035cdb6a4720fb94024"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5da6a421faf2e3aaf0d222816712269cd31a78fa716854492d2c9f87a6115a77"
    sha256 big_sur:       "99e4e8bb7eb6fb35d545079b836382f8b1e5fa71c8e6473cde4f18fb109e3b09"
    sha256 catalina:      "1f8547fa3587591c061f7569668cd128f4918e78555c9b180a694d5a45adb4ce"
    sha256 mojave:        "cf2279276c1f7e2585ce9d1cd12f456550215f0b4f8f950be607c1f8e6574cb3"
  end

  depends_on "apr" => :build
  depends_on "apr-util" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "httpd" if MacOS.version >= :high_sierra
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
      DYLD_LIBRARY_PATH=#{lib}
    ]

    args << "--with-apxs24=#{Formula["httpd"].opt_bin}/apxs" if MacOS.version >= :high_sierra

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  plist_options startup: true
  service do
    run [opt_sbin/"shibd", "-F", "-f", "-p", var/"run/shibboleth/shibd.pid"]
    keep_alive true
  end

  test do
    system sbin/"shibd", "-t"
  end
end
