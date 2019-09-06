class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.1/xmltooling-3.0.4.tar.bz2"
  sha256 "bb87febe730f97fc58f6f6b6782d7ab89bf240944dd6e5f1c1d9681254bb9a88"

  bottle do
    sha256 "17fb30e25e030285cc3d0b345a05285bd8d8bc64ba5878b3cbdb2302cd64e020" => :mojave
    sha256 "aaf875d4511b95f8dbba08b818b990e0e6d323048222f4a95189b4333ec7af24" => :high_sierra
    sha256 "491f5d0c4956b38b3b0c1765b028630f89865cf73a6bf5fd49e459b3b8a77daf" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4shib"
  depends_on "openssl"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.65.1.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.65.1.tar.bz2"
    sha256 "cbd36df60c49e461011b4f3064cff1184bdc9969a55e9608bf5cadec4686e3f7"
  end

  def install
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
