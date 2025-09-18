class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v23.0.1",
      revision: "050eacf11a15afb2e95560dfb5723dfdcf78070f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "c04fd5b9aaace8e5b8a3a2d7e2a108031c53737df25d1e6cd64d2bba9c789e62"
    sha256 cellar: :any,                 arm64_sequoia: "3f81b2599339b2637e8892b207127bea909782ab692ac398ceada6d836cdb41c"
    sha256 cellar: :any,                 arm64_sonoma:  "5f20f7aa7b39bfff588b715fd65df67afa73ec32c86d4b07356cad2dd7b24d49"
    sha256 cellar: :any,                 arm64_ventura: "9adf336157a88caa21d506a1043110eb8966207c65ff476f4b44807d3a8f9fe7"
    sha256 cellar: :any,                 sonoma:        "7dcaa843016563e392656bcd44d36e2ea5c1090e3f0df1cfcf5e996308b2157a"
    sha256 cellar: :any,                 ventura:       "4ed06d390acdef994ceff2f7f562ca950bf6d67bdca0c466009836496a7b63fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d105e6d0687f9a03444ed4c2c4285038995776af432d8ef031f010fdf82cead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3dab52db935253b3d3ee61b2c286245fcadb1ede505dbfd5d57c70cfe8e697e"
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
