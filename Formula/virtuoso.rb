class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.8/virtuoso-opensource-7.2.8.tar.gz"
  sha256 "979d221d1ddeb7898db0a928ad883897d9ddcd39886a54042fae9a9b9b551bfa"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ee2e4a5e99a4b489028c7d5a8f1a28b832a5ac9c57632d37b72992e462163b04"
    sha256 cellar: :any,                 arm64_big_sur:  "4334a020863749bd59ef5ad2a9d22e9d47dfa05d20afa7c9f2097665fed444cf"
    sha256 cellar: :any,                 monterey:       "e1c6970ad1befbda4b335ae8c0f82d584db209745da7c2af6da89ac68e754e27"
    sha256 cellar: :any,                 big_sur:        "9409cf1078a6ca2acdc53834cb7e6a7402fe8c3ef52ede37180ac96457610aad"
    sha256 cellar: :any,                 catalina:       "074a26ddddb44f656c37f0784b68872ce2b770c3f28a291138fcc1855cdebcd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6c037f39025c0a2693414951494a117294824e4f15a57f2af0c22b838b47e2"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "net-tools" => :build
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-internal-zlib"
    system "make", "install"
  end

  def caveats
    <<~EOS
      NOTE: the Virtuoso server will start up several times on port 1111
      during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
