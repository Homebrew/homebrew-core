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
    sha256 cellar: :any,                 arm64_ventura:  "258729ad7ed89afe48748058f3bfa89919373b4ef5e96f679aa95fe11ce46a17"
    sha256 cellar: :any,                 arm64_monterey: "4a3f6d4cb0eeac79479e64aa88bc12485d54aadbf48b20cf9c7c19c13c13647b"
    sha256 cellar: :any,                 arm64_big_sur:  "695842b73a7c76c02aeae2f9785cd213b0cb76dda28a674f659c9b8b5bced15f"
    sha256 cellar: :any,                 ventura:        "8c27c31db50f3ae90b224554bfc5740f53c9ae9de6ada41b81e757fdf6f013ab"
    sha256 cellar: :any,                 monterey:       "86084e15e90b6e6c4e5bab77aea90d9eb6f544abd05d6d144d648d6a29fe86ef"
    sha256 cellar: :any,                 big_sur:        "53716cba38ac454be6691244b174e607e8d129c7e2bc653ad1807839cba842f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6250765040e8f0eca475cbab10f59f46217cdfb4d2eb0e8a4b87d5d92a35a01"
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
