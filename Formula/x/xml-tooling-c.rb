class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.0/xmltooling-3.3.0.tar.bz2"
  sha256 "0a2c421be976f3a44b876d6b06ba1f6a2ffbc404f4622f8a65a66c3ba77cb047"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b36b66bb9b46fd88ee081350f982c80b786f7badafdf75a741c900be3e1b911"
    sha256 cellar: :any,                 arm64_sonoma:  "64daef61885d864d71a90bdfaee06917c8c804f16047e57cd7f61e7ea010f2d0"
    sha256 cellar: :any,                 arm64_ventura: "0e898674f0dff6301c67b43a6f6d2777e8b1f6699db05030c53ad941386e5c88"
    sha256 cellar: :any,                 sonoma:        "bbb79415f2f27bbecb0695af2c7547f3c08f3caa681564c4f5a10c1732d41f25"
    sha256 cellar: :any,                 ventura:       "c8d74d8e11b29f17443ceafce0ab9764a22e5cd8dd049929fbc93b11abcfbd7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "482017f1ea455f4ecdbac8be24a55edb91ba4c852d288e1be5ae0c7034aa47a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7b54bffbe67ec82fa423f304ee36a5877efd2bcc3d163d5bb71f23dc9a7dcd"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end
end
