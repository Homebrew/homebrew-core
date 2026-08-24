class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v28.0.0",
      revision: "a9b8613218e141ddb89d621e5f04d4c75a149d36"
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
    sha256 cellar: :any, arm64_tahoe:   "66a64e0898bbc7c3398b1715e4125e27d0f55bb1649e71611b487d7fb57328f1"
    sha256 cellar: :any, arm64_sequoia: "41aa7f77659eab5ea3467a3842c02db06c8860588c46a6628acd52316829e970"
    sha256 cellar: :any, arm64_sonoma:  "85f433bbd88abfdb5181cc986ad9bbd15b90899e0929f39055d0d962a7afdb88"
    sha256 cellar: :any, sonoma:        "8d28b8ee800a45d2f39afe67d0d289e0c511c2151d373fac7eaadeb580f66042"
    sha256 cellar: :any, arm64_linux:   "c28429e6fe04abd273e58775fbee5f8cbb2887e8a6cc7b3dcaef22fe1da0b040"
    sha256 cellar: :any, x86_64_linux:  "69814814b136c71b68b2b45273a5728889caef0dc84fa6d6c9ad242e0bb7183d"
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
