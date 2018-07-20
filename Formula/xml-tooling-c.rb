class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.0/xmltooling-3.0.2.tar.bz2"
  sha256 "5709cf30c9d7cfc786599ac2433653fac8cc64d425781068af86019c8ce8d689"

  bottle do
    cellar :any
    sha256 "86825d5ddf6c43e7c3d21b31a4a2d2a401298f77bae69271c97e96a3758d36e7" => :high_sierra
    sha256 "2878f5cae902c814c2da3f7de43fe68f4d3d10e8e6798b565badbbce3ce45348" => :sierra
    sha256 "45eb412468e872aa65d2f4552311ca1ef78d579b9944baf2a613ef129cb87d72" => :el_capitan
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
