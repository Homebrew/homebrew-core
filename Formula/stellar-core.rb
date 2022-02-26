class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v18.3.0",
      revision: "2f9ce11b2e7eba7d7d38b123ee6da9e0144249f8"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "048413c08407db38f016438911cc24498d0919b8cb8a09196f1ddcc31b5ddb76"
    sha256 cellar: :any, arm64_big_sur:  "c8d41192a8f14e1990eb9110696253a0c2c24e3fa8f9532acc00596a5b356f45"
    sha256 cellar: :any, monterey:       "2d1d408bf2741d1c8af2c997181d29848a862f1f49dbbf057417dd76ab4ae010"
    sha256 cellar: :any, big_sur:        "b9802e2eb2a7edc26f70184cae0f882807b1ffe86cec3b5c5f49e6ce84521e5c"
    sha256 cellar: :any, catalina:       "c1b97b9a1f273caee556d6f24dfb096f21d3955ee25cdadf81ba06e019f3165f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.22' not found
  # Upstream has explicitly stated gcc-5 is too old: https://github.com/stellar/stellar-core/issues/1903
  fails_with gcc: "5"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    system "#{bin}/stellar-core", "test",
      "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount]," \
      "[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
