class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.0/xmltooling-3.0.2.tar.bz2"
  sha256 "5709cf30c9d7cfc786599ac2433653fac8cc64d425781068af86019c8ce8d689"
  revision 3

  bottle do
    sha256 "f9abea4ed4e7ecebb332288f4341f817c3fbd57853938ef9a115c5abd16e164c" => :mojave
    sha256 "a84eb9b4d9ec6d1112e90f5a7db858ddaf174a44d296ae83992da42f74007d07" => :high_sierra
    sha256 "bd80c1aadca3759c995f39d16291623752df1566f37e8f5b75bbffcaad2a0f15" => :sierra
    sha256 "d9ce481e3c1a53f864ddd93b03573acff1003639a2816bd4a1bfc5c984e33e5b" => :el_capitan
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
