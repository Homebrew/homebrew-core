class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.0/xmltooling-3.0.2.tar.bz2"
  sha256 "5709cf30c9d7cfc786599ac2433653fac8cc64d425781068af86019c8ce8d689"
  revision 1

  bottle do
    sha256 "2fd69122b2fa8f8b4029ac2c99e57914213691f1cf225fc2cf92eb7664cd95f7" => :mojave
    sha256 "9f79c4dcb252510563bed587cb6daf46f559170c8d18dcdf578e381df82cf826" => :high_sierra
    sha256 "8bed31c20f47ad632bc18520331ec52c7cfe67a365e6f66979816993e600f74a" => :sierra
    sha256 "8c46bd6bc746ec5e91e56fc44daeb3f003b65e79db3486db8aaed0951191213d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "boost"
  depends_on "openssl"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.61.0.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.61.0.tar.bz2"
    sha256 "5f6f336921cf5b84de56afbd08dfb70adeef2303751ffb3e570c936c6d656c9c"
  end

  needs :cxx11

  def install
    ENV.O2 # Os breaks the build
    ENV.cxx11

    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl"].opt_lib}/pkgconfig"

    resource("curl").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}/curl",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}",
                            "--with-ca-bundle=#{etc}/openssl/cert.pem",
                            "--with-ca-path=#{etc}/openssl/certs",
                            "--without-libssh2",
                            "--without-libmetalink",
                            "--without-gssapi",
                            "--without-librtmp",
                            "--disable-ares"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"curl/lib/pkgconfig"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
