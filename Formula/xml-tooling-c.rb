class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.1/xmltooling-3.2.3.tar.bz2"
  sha256 "95b8296ffb1facd86eaa9f24d4a895a7c55a3cd838450b4d20bc1651fdf45132"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "82a7123ec05ff4b0b317de79593dd6357946875f932551e6882857fc3acb9c62"
    sha256 cellar: :any,                 arm64_monterey: "cbd0a7684e3ad9c36ebb12352e986920f03d26a982a1910c62ed525f9cc71dd8"
    sha256 cellar: :any,                 arm64_big_sur:  "b1b152e45a1899923a767d20de18720cd215ef6fa5c6e737e80808ae77bdff66"
    sha256 cellar: :any,                 ventura:        "07f29554ce9fcd13de4e6a65a69e189be4e281c3498b80a9a0fcf75aa4ef8454"
    sha256 cellar: :any,                 monterey:       "e5674556cd12e57db8a2d9a8781a44bc4a87be4c3b0bfe44a196f0cce65943ea"
    sha256 cellar: :any,                 big_sur:        "bf5c95c1a510b20f6a1fff57f432100c05fe689452853f9dc6a00b9a89b93016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5918ac165b0a7bfd4c333e42a37171d913e8379989475d68a60af99ee00013a4"
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
