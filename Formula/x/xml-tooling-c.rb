class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.1/xmltooling-3.2.4.tar.bz2"
  sha256 "92db9b52f28f854ba2b3c3b5721dc18c8bd885c1e0d9397f0beb3415e88e3845"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f76efd3281936cb832a574976783f056e66766f473d849aae63c746e188d6f39"
    sha256 cellar: :any,                 arm64_sonoma:   "672e8c185c451dad3d04b70756130b8d634115a694ae4cfbdf559d2876685d27"
    sha256 cellar: :any,                 arm64_ventura:  "ae4ac6f8e8c3316ecde0a3ee93a9ccb6378cda802cc091cd171a4730e677f17f"
    sha256 cellar: :any,                 arm64_monterey: "5a8b264c7570c6ad106eb2edd451c11157373f206346eb8a4b8998e9ed62a851"
    sha256 cellar: :any,                 arm64_big_sur:  "abcb3207ed424a52d6b5555c63fe484f34022b09c5e25c8ae3dd99bb898c5ad5"
    sha256 cellar: :any,                 sonoma:         "6d21ebd6fb31b2e87a6cd17b2f445f044d9f9a570c0797ecf63d278bf56f5dc2"
    sha256 cellar: :any,                 ventura:        "079ed64f572a73735ec306bb7d011e3ffe429c496001fafc1498937d8684a78a"
    sha256 cellar: :any,                 monterey:       "df0f4a56208757543bb35a7f56d5c56b68699a7422af4f908d83d4ec585cdc4d"
    sha256 cellar: :any,                 big_sur:        "d9b9cc4501d19a476a3f2a0dbde388b3d50102518bd54cf018e642ff881f042b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e7112c339d983cd2238781a912a5b972b49e6290f0ba17ccfa8835bf19ad2b"
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
