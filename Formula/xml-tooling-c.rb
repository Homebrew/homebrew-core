class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/2.6.0/xmltooling-1.6.0.tar.gz"
  sha256 "25814c49e27cdc97e17d42ca503e325f7e474ca3558a5a6b476e57a8a3c1a20e"

  bottle do
    cellar :any
    sha256 "8b75e123e8c12ff205f5a953aec23ceda024da6a40ee9b1e996f1046eb3ecdba" => :sierra
    sha256 "bd3982c79a8c6f321d6da685ab1c512143c6c0831a1dd3c126e61ebb7f8f0081" => :el_capitan
    sha256 "577dd0d2bcc8a21c64d8382050d7336d8bd3d4f92c47359825a39e752aead6c1" => :yosemite
    sha256 "37396ffc11a7c096d135a87ae10d47b937b2c9a66a82b328d261d2801bca93a5" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "boost"
  depends_on "openssl"
  depends_on "curl" => "with-openssl"

  def install
    ENV.O2 # Os breaks the build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
