class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v27.1.0",
      revision: "3589a696b0d4ef5a2cf2124e349c671d71886d9c"
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
    sha256 cellar: :any, arm64_tahoe:   "807bb65b02eecf983a1e70348ac2e02ff8574872a31eeb81d92f41f6b5e10c92"
    sha256 cellar: :any, arm64_sequoia: "2702f1b6c5ceddf98cc6d3226e3badb38a361054d386c6c7e544ce9a311d25de"
    sha256 cellar: :any, arm64_sonoma:  "85536e4618df4123571639541567f3ad0116aff015c966a0fb2f7794410438ac"
    sha256 cellar: :any, sonoma:        "346c20d53c2f0a1415bcc8bf8661621f8eceb78e976291c050386472ea64e0cb"
    sha256               arm64_linux:   "4297600bfb048bbd102bffe41c1fa41992f34b892f63fd27d91fc517f5c29c52"
    sha256               x86_64_linux:  "ad2d0493abe173d0f99da5636240934937a3bb221d1a590a4f96094783950db5"
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
