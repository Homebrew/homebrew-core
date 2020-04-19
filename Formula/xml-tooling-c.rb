class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.1.0/xmltooling-3.1.0.tar.bz2"
  sha256 "722723cc2731a25db23c6acc5bc67e25a1554224e7039edd4e9ea5816e525d0e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7288a254dbc9e0b0e67889c8729e93d6df3973ac2c8107f49a7682a68771e4bd" => :catalina
    sha256 "8a554bf5c32b3849a28035aa3f67be30ed3eb638e154435d9d51d7bd051db1e5" => :mojave
    sha256 "2345b350f57a2c9042946060bcf3480db90daf6aac8f7f5a43c0cf5858e568a5" => :high_sierra
    sha256 "701c93021b159fafc19306bf52729820e93c23cb3b164f953595d1f4f59aa3fe" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4shib"
  depends_on "openssl@1.1"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.65.1.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.65.1.tar.bz2"
    sha256 "cbd36df60c49e461011b4f3064cff1184bdc9969a55e9608bf5cadec4686e3f7"
  end

  def install
    ENV.cxx11

    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl@1.1"].opt_lib}/pkgconfig"

    resource("curl").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}/curl",
                            "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
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
