class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v26.0.1",
      revision: "e78c97ed0f517883cb7e93766e62f4b46b7d6d8b"
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
    sha256 cellar: :any, arm64_tahoe:   "28d7e9c4f7e63e24215f03eddbf7641b8f2308ad4ac06933352c9f213387f172"
    sha256 cellar: :any, arm64_sequoia: "e8c227d7a5c6c89d0582f484384c9ecbc68c7b909285f296b0d531ed031f4769"
    sha256 cellar: :any, arm64_sonoma:  "29e895cf96aec1ad0f7255acfb61d4764e34cc5d97ef1688d1bea4dd6d147142"
    sha256 cellar: :any, sonoma:        "c59e40f3ed281476553acd1786065675e18ce1fada8b7b56fcd9d0c68d845109"
    sha256               arm64_linux:   "a41f28bc600a2cc31c80e24f3e9a4a0d70bc539b112dde43be843e465e6f822b"
    sha256               x86_64_linux:  "e72be52e267eccc8b6cd0951ea6e64fe44375fe00e32bf64eb69642ac56f5363"
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
