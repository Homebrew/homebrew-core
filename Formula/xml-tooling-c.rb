class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.0/xmltooling-3.2.0.tar.bz2"
  sha256 "635ce0e912d8fbd450103c274237067923efac3e1b3662b4d3040f3ac5eb2e86"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b0f96c66e6f3fab2d33b44228b4690b3b480fe92d19774028f1b63f8e2da1bf"
    sha256 cellar: :any,                 arm64_monterey: "a04d49dde2d69e17ee4f258abe9a992e43b048fa10f1a8bcfd02c1fc37839a5f"
    sha256 cellar: :any,                 arm64_big_sur:  "65e021c1f203021118f1ed17a67869077a2ae014774729173010c8095e3b89ec"
    sha256 cellar: :any,                 ventura:        "7dfecb4b3317f24cf5b5dec21e7fa2856d90f0afd0e49c7247e6714c5c4a38c3"
    sha256 cellar: :any,                 monterey:       "ebde61320a9596a85561d46b4dae80d0e6e4abc2b3dbf506eff2ec85d82c52fc"
    sha256 cellar: :any,                 big_sur:        "57c8c16990f589f0e07a7e5d57dd202c4f35b6e66d57bbda66d4d9bc2af6bd33"
    sha256 cellar: :any,                 catalina:       "859a056b4271610e876b42606d145a0ddc2d79cb94c0470e2ca93cdef38c4e2b"
    sha256 cellar: :any,                 mojave:         "69d6679f8c610867e03269af38ce56306af656a2e1f7b3bbce30d25085d6ae9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc7b883e123f169a52223df4b1bbf66244b3d3363a29984ef3fde445fd625c0"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4shib"
  depends_on "openssl@1.1"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  uses_from_macos "curl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl@1.1"].opt_lib}/pkgconfig"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
