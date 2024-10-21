class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.0/xmltooling-3.3.0.tar.bz2"
  sha256 "0a2c421be976f3a44b876d6b06ba1f6a2ffbc404f4622f8a65a66c3ba77cb047"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0ef902c27cf8bfa73f4c0f6bee15ec69d9f8a63bfd8b34006b495b9802d7340"
    sha256 cellar: :any,                 arm64_sonoma:  "ceef02c1031a06a879a79db01b058b32933da2ba8fa64d956844f9bd2fc35cec"
    sha256 cellar: :any,                 arm64_ventura: "fa0690dbfc52ee1b79aed3b3d3d768470c6a40da769165959d581b644959b540"
    sha256 cellar: :any,                 sonoma:        "6893f239e822a225d47b76d1fdddb881e1eb9b3ffd5f230fd4c7779f2befd848"
    sha256 cellar: :any,                 ventura:       "7c31c534202e7ee09a6b43c0a68f75b17bcddc27d6e25df419383419d60a79e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2342976e7b86e5826af7d8634ae96c3abc75b1fae9a80436d7e513278887e0e9"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl@3"].opt_lib}/pkgconfig"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end
end
