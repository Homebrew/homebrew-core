class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v26.0.0",
      revision: "8e43a2d3b83ee48fd1a2507ea727a21ab9fc8c23"
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
    sha256 cellar: :any, arm64_tahoe:   "7c36cdc15041c081e1cd03ad3ac0fd9102e29f46d9fe0dc1a9d615daabe9f319"
    sha256 cellar: :any, arm64_sequoia: "97783785359a31438af50a2303eb0666c28a3612391b0e4d99fdb3bb72f6d622"
    sha256 cellar: :any, arm64_sonoma:  "004a9ad20362c217af9d6d300ef9661518d91c7b79d4ec2a236bda5372a03305"
    sha256 cellar: :any, sonoma:        "8a7a9b3d9d42111997b2834e4aee975fa6cc714fecfe788ba988d7b5369b7040"
    sha256               arm64_linux:   "b9c534b0c6a38cfc4298a2c700ac4fc1530e330a401eeb4a1ac5a69ada4ed9ac"
    sha256               x86_64_linux:  "be8a27d86652d75443b5e2357af76474b954f7d1e27215d46cc5651051830d35"
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
