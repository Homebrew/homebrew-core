class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v30.0.0",
      revision: "0e49751aa9ddf892302cca02cea7f3f5d97df9f1"
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
    sha256 cellar: :any, arm64_golden_gate: "41d48362f55480aa57590dd0f90938ed15a7cf096b5b43d39568d9e7df136d50"
    sha256 cellar: :any, arm64_tahoe:       "4f2963bae1af06b037e8ce6e397719ed3721e093d89f98d8358f69ec457aa25c"
    sha256 cellar: :any, arm64_sequoia:     "bee2b67e4625de8f1c63353e89cdf4acb348a62d9bc929d294562181c127b709"
    sha256 cellar: :any, arm64_linux:       "fd6a9808efb97796fa4c185ebcb46e10875e51bd5f3ee4555e8de107fd3e534b"
    sha256 cellar: :any, x86_64_linux:      "f9cbeb8c633bc22fbbf5fbbbc8fd2ba60c47f063173c0bcc6ed069360bc1fe44"
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
                          *std_configure_args.reject { |s| s["--disable-debug"] }

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
