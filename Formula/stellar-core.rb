class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.0.1",
      revision: "2b38097cbe980b0b602db023956a37460d5bd29d"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f95f40c979a78eaab3877eb6dd2104c5fd52c7c7048dc44347953b55778a879f"
    sha256 cellar: :any,                 arm64_big_sur:  "0975e73257c78a479efd8df3867721c162ed0b6ce0105d05fb06dc589dda45b6"
    sha256 cellar: :any,                 monterey:       "f9979120501b461420ac17411b7c55bd8a0196cc10d3756d83753d9a3162e872"
    sha256 cellar: :any,                 big_sur:        "1319c9b0c574224b584475157c509a0c79e8d579103795056216c642ae066403"
    sha256 cellar: :any,                 catalina:       "4dc70a214a207e61a9f00684debd1b0280d5650cc60661339c9f49ddeb49c964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdc4b40e2ab3bb4a88eb035dbeda2955ee0aefcda14b6831b0cced8012da58d7"
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
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

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
