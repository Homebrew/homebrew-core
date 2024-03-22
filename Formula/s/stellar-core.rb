class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.14.0",
      revision: "5664eff4e76ca6a277883d4085711dc3fa7c318a"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c02b5f80dc1e5bc67c5345cb9e41d950a72ff5dd95e87dc1a692ae739aaf6ad"
    sha256 cellar: :any,                 arm64_ventura:  "3d743c3c190d286146b4641686a962dc6bae910ba556ced19aa16e4f876866f7"
    sha256 cellar: :any,                 arm64_monterey: "3bd593bd7fcdf4da807c8efafc1a6811ae7d669b6eeec9e14473cdbb624e9771"
    sha256 cellar: :any,                 arm64_big_sur:  "ac8f0216f0c40a283251b535e830e5ede21a483986068e1fb5e5793abe9ac26d"
    sha256 cellar: :any,                 ventura:        "93c9731b317370b3b0e536fe3c360d14e637a1917512ba87aaa73ccb541399dc"
    sha256 cellar: :any,                 monterey:       "8c24dc045cb0c9356ab26874cde6ac6d9a217662d04d48167c1998f1453ed641"
    sha256 cellar: :any,                 big_sur:        "70e2b6efdd7c02172c9cdc44f5485e2d821f82fca9c4fb398f5a6e639bab0b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7abd7620b0d2d7674acd699132917e21d542faaf7d5286f1c170df46d6aa55c3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem
  uses_from_macos "flex" => :build

  on_linux do
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
    test_categories = %w[
      accountsubentriescount
      bucketlistconsistent
      topology
      upgrades
    ]
    system "#{bin}/stellar-core", "test",
      test_categories.map { |category| "[#{category}]" }.join(",")
  end
end
