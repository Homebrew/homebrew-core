class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v24.1.0",
      revision: "5a7035d49201b88db95e024b343fb866c2185043"
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
    sha256 cellar: :any,                 arm64_tahoe:   "5852df29339bdf942dfffd7c3631f5914d39691355f6cd272706d14653bfc2cf"
    sha256 cellar: :any,                 arm64_sequoia: "844a90afa7f8489619ee8c952a1626dce0ad157e8dee6c0d6c266a36cdb8cdba"
    sha256 cellar: :any,                 arm64_sonoma:  "1dd65c994e9bf63700d4c170769e9c9ca25548f9d6d8496dbb1600ef4e66c934"
    sha256 cellar: :any,                 sonoma:        "1f760a465340f62d07f5d8699a0540f8b315038196d9f9a25157ad27b8797d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46f43fe7813a42cf9d8fd7adb14991773bff83c1bad601efccc3d19807efc7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36974ea5cfe19885ae78092dcf90c7811a7e169184ffcb74524fe42f2263465"
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
