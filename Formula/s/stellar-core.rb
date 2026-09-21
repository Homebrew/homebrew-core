class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v28.0.1",
      revision: "947aad8413c189d85504acf72207e85eeda9b021"
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
    sha256 cellar: :any, arm64_golden_gate: "1bc9c9cc101593df1b000a0211784e268f1f00d5ff6674d15dbd0ed06d606f1a"
    sha256 cellar: :any, arm64_tahoe:       "a45eba22d3dd41db23c8f67a90245705c92eff9792087643905af0c8b18c3f79"
    sha256 cellar: :any, arm64_sequoia:     "8ede2f5d5d1f7fc2df785e2f65d48f3d26e475b30ed9712f87aa4e5b46c8d456"
    sha256 cellar: :any, arm64_sonoma:      "5869860c035e22c125bede8ad5f3268a5fcd0c601a48eaac4c90d414ab4dae07"
    sha256 cellar: :any, arm64_linux:       "e53ae206410140a852c9efdb31da72b8d9150f049d3b076a9d5e0b1a0c17d50c"
    sha256 cellar: :any, x86_64_linux:      "3380990ed3f198969a7e294a425b06dbee31d31bb05af6a669d324f541b76e0f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpq"

  uses_from_macos "flex" => :build

  on_sonoma :or_older do
    depends_on "coreutils" => :build # for sha256sum
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    # remove toolchain selection
    inreplace "src/Makefile.am", "cargo +$(RUST_TOOLCHAIN_CHANNEL)", "cargo"

    # GCC 13+ no longer transitively includes <cstdint>, which the vendored
    # `libmedida` sources rely on for `uint64_t`. Force-include it.
    # https://github.com/stellar/medida/pull/34
    ENV.append "CXXFLAGS", "-include cstdint" if OS.linux?

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-postgres",
                          *std_configure_args

    # The p21-p26 soroban host submodules lock `ethnum` 1.5.0, which fails on
    # current Rust: it transmutes `()` into the now-non-zero-sized
    # `TryFromIntError` (rustc E0512). 1.5.3 replaces that with a safe
    # constructor and satisfies their `^1.5.0` requirement. Bump the pinned
    # lockfiles and the dependency-tree snapshots the build verifies against.
    # https://github.com/nlordell/ethnum-rs/issues/60
    buildpath.glob("src/rust/soroban/p2*/Cargo.lock").each do |lockfile|
      next unless lockfile.read.include?('name = "ethnum"')

      system "cargo", "update", "--manifest-path", lockfile.dirname/"Cargo.toml",
             "--package", "ethnum", "--precise", "1.5.3"
    end
    buildpath.glob("src/rust/src/dep-trees/p2*-expect.txt").each do |expect|
      next unless expect.read.include?("ethnum v1.5.0")

      inreplace expect, "ethnum v1.5.0", "ethnum v1.5.3"
    end

    system "make", "install"
  end

  test do
    test_categories = %w[
      accountsubentriescount
    ]
    system bin/"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end
