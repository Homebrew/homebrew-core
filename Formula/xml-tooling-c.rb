class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.0/xmltooling-3.0.0.tar.bz2"
  sha256 "3f9762ff517270c4c114cd0fc1412d4545247215ba83924e7e490e3401a3ef0d"

  bottle do
    cellar :any
    sha256 "1c3be0d73b48e5e47284623bae7f3a8840e2bc0684d0146f550c637f0aca1b6b" => :high_sierra
    sha256 "7bd073591df0e604d227de6a69883ddfa72b2dee9fa2b44c1ab57fd5b4c24276" => :sierra
    sha256 "d5d87c12f03e64d62421aff27732605801ba70a50c62b2815f468ce737306d9d" => :el_capitan
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
