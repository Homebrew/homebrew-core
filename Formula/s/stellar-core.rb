class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v25.2.1-external",
      revision: "3356bd4ac9646281ee81636f04033ed247582ec5"
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
    sha256 cellar: :any, arm64_tahoe:   "fff681f122e6878d6d367951e466fb5441441b94a93ba1a587ba9c410e10a8be"
    sha256 cellar: :any, arm64_sequoia: "edde3fc5a2d07c3e59552292107dc7d35ad51536dce2074c3aeda700f82897c5"
    sha256 cellar: :any, arm64_sonoma:  "ea62cb42c436c63f7dc4258f7dd625ed719bd4daebcf84ec9412e3809a90743a"
    sha256 cellar: :any, sonoma:        "162eafcaccb5aaf1f33a93051f1e0293159bf38ed58e16eebeeef55a3f298d33"
    sha256               arm64_linux:   "5fd1f4c7f11982661f8afaf7d63f4bbe8fb0e3ddfb175073accc9950e08f86e1"
    sha256               x86_64_linux:  "71119db2b8a4cd73cec25139e8cf231bf165e9de85e732cccd2b00f24aab4345"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"

  uses_from_macos "flex" => :build

  on_sonoma :or_older do
    depends_on "coreutils" => :build # for sha256sum
  end

  on_linux do
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    # remove toolchain selection
    inreplace "src/Makefile.am", "cargo +$(RUST_TOOLCHAIN_CHANNEL)", "cargo"

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-postgres",
                          *std_configure_args
    system "make", "install"
  end

  test do
    test_categories = %w[
      accountsubentriescount
    ]
    system bin/"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end
