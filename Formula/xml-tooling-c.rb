class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.0/xmltooling-3.0.1.tar.bz2"
  sha256 "f94dff26aede7e8be37b78323ad0accae73d190cc94d5d3f5e5494ebb5aa45da"

  bottle do
    cellar :any
    sha256 "1f9b5866dbb3063472792de55754fd2cca59c83495dee31e9b20338f28490737" => :high_sierra
    sha256 "77acd117fad43a5c0360f3a33a5b3c4625b0bf811530fab9dfb8966856cc95e9" => :sierra
    sha256 "6b82aeba412679db73ff21b5fd0e18743a4afd4ba67ba888bae780d10df60e0e" => :el_capitan
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
