class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/2.6.1/xmltooling-1.6.3.tar.gz"
  sha256 "dd1216805e9f24eff5cd047f29dd0c27548c6e2e9f426ea1ba930150a88010f9"

  bottle do
    cellar :any
    sha256 "c5a746b0fa1038a446bc3e26e75667bb0f5c2d9aedb8a90637db1e9522e9610d" => :high_sierra
    sha256 "cc45abb3233e6c8388c05eab993c0f1b2f0531c05e457aed323f9f1c1a32fd23" => :sierra
    sha256 "b280565740be8ebfabe293403d5765182687bec283f01da44468730e7f80006d" => :el_capitan
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
