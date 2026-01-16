class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v25.0.1",
      revision: "ac5427a148203e8269294cf50866200cbe4ec1d3"
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
    sha256 cellar: :any,                 arm64_tahoe:   "8bb2f1b23a136c1b3686904b9386809bb9c3415f58919c4cb6e7afc9e97b7327"
    sha256 cellar: :any,                 arm64_sequoia: "1c01d331291b77b02dd53602a84b634795dde408e70fae70ab3682e61adeffb1"
    sha256 cellar: :any,                 arm64_sonoma:  "8914daf0bf6a97345825108310ac58424c16787c7f8682c3402e85e6c35b6331"
    sha256 cellar: :any,                 sonoma:        "b137ed8253b0c4de1cffed0ceaae29493e5b3a6f099adbb2553450fb1340a9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1967e1788e64f85c98821fab4bdd71854b149eb43bbd34314894f03b78a6dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55de5d6adaaa3757f8723ad9cc803e893229b73d1c687c4186eccfc1c1167fa"
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
      bucketlistconsistent
    ]
    # Reduce tests on Intel macOS as runner is too slow and times out
    test_categories << "topology" if !OS.mac? || !Hardware::CPU.intel?

    system bin/"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end
