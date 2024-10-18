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
    sha256 cellar: :any,                 arm64_sequoia: "eb00e1cff98cfc36357bef956745b382933939db6375472ba7ac47c2495880fc"
    sha256 cellar: :any,                 arm64_sonoma:  "3199b66a057117eaf57d8dec705b1bb740caa61592bedbaa39d9621752495f65"
    sha256 cellar: :any,                 arm64_ventura: "5298aed9afab194823a2022bd5d427ede7a9e873768fedbdbef32803724aa6cb"
    sha256 cellar: :any,                 sonoma:        "08f0cd68263afff7da8a4fbe2469280373d5d285be2048c1d9ccae6ae27b2d19"
    sha256 cellar: :any,                 ventura:       "fef897bcdae12eb52327097b65e334de1030745f6cf33b26570600ddb14f2b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd9bff2c71f2b6d1c1985ec9d60ec89135100d6465d71a78a6635b02a7d7d25"
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
