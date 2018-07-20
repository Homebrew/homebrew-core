class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.0/xmltooling-3.0.2.tar.bz2"
  sha256 "5709cf30c9d7cfc786599ac2433653fac8cc64d425781068af86019c8ce8d689"

  bottle do
    cellar :any
    sha256 "88b3c749096fd59258317ef31a381a553a1df453fb7d7de09ecb18c8d9ac5994" => :high_sierra
    sha256 "dd5f6f55d9d8f9067470f0a93f9ba379ef6e5ae8b2d7e5892b8b79003321b23e" => :sierra
    sha256 "4627af97a11e0c427f20cfacd463b79fc19db15062bee990f8c7b2392d605593" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "boost"
  depends_on "openssl"
  depends_on "curl" => "with-openssl"

  needs :cxx11

  def install
    ENV.O2 # Os breaks the build
    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
