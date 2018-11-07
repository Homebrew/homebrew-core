class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.0/xmltooling-3.0.2.tar.bz2"
  sha256 "5709cf30c9d7cfc786599ac2433653fac8cc64d425781068af86019c8ce8d689"
  revision 3

  bottle do
    sha256 "102b92e9c2bbaa974b28672e9059494686c6fbdff6a6200a8a81522b357b475d" => :mojave
    sha256 "5ffb76b87609c1fb643efc243978e1fca42db49748a811a1e71b5d96f66a6841" => :high_sierra
    sha256 "b3ac28676aa355c5fd9ae8802ab9d26e6df0cbd187d9f1a3648c92773d04235a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4shib"
  depends_on "openssl"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.62.0.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.62.0.tar.bz2"
    sha256 "7802c54076500be500b171fde786258579d60547a3a35b8c5a23d8c88e8f9620"
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
