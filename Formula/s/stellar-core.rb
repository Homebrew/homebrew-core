class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v22.0.0",
      revision: "721fd0a654d5e82d38c748a91053e530a475193d"
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
    sha256 cellar: :any,                 arm64_sequoia: "c957356fe42af606a2ff611716c12cb5cd22661c7a4a4359a8fd353258044858"
    sha256 cellar: :any,                 arm64_sonoma:  "5b1763530f2255bd30ec9f9dd6e55b9dc47c1071216b66af4a426da6b7b324f9"
    sha256 cellar: :any,                 arm64_ventura: "cd41dd53666990a82bbce2c5103d033c0def90039df14e458714bf06f203ec41"
    sha256 cellar: :any,                 sonoma:        "52e34cdd2d0c43cd942e5a3d3f67d0b219565fe0be16feb1b2ee6c6df7c2ba8b"
    sha256 cellar: :any,                 ventura:       "adb33b8efc941647c6362489677824282e7a6365b80c0f665959bb63adb25a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7b47ae6a39d43b88ef02b8fd79aa9431fde22f3ebb9589413e2bd0b49000b7"
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
  depends_on macos: :catalina # Requires C++17 filesystem

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
