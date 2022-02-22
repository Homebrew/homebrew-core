class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v18.3.0",
      revision: "2f9ce11b2e7eba7d7d38b123ee6da9e0144249f8"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "83dc45e9db1b5981ed5960cd7368aa93d12a91ad0d7c57a310a98fbbe5ae395a"
    sha256 cellar: :any, big_sur:       "5370feb4f95248952bcb674798077f9832685a27c53a290ae112216f0755513f"
    sha256 cellar: :any, catalina:      "256f91735275e90f55e0fe0781a3b2fbb630978a12774daef1d8e144830f95b7"
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
