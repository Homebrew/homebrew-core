class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.1.0/xmltooling-3.1.0.tar.bz2"
  sha256 "722723cc2731a25db23c6acc5bc67e25a1554224e7039edd4e9ea5816e525d0e"

  bottle do
    cellar :any
    sha256 "0608d8938278794d1101b96e70d7f408b3e12f270eccc9cb1a8595e2880ab934" => :catalina
    sha256 "d04a629486e2478f98c1f729c474d18fee5fc4bb0b2f2bdab17c6e4b3131db9f" => :mojave
    sha256 "6ee9b56942dcf7b05e830c11eb4249c14d07ae367433e40838454f8e6cd84858" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4shib"
  depends_on "openssl@1.1"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  uses_from_macos "curl"

  def install
    ENV.cxx11

    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl@1.1"].opt_lib}/pkgconfig"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
