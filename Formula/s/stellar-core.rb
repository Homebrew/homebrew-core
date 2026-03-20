class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v25.1.1",
      revision: "a5393933f5e8c0d5be2d493b6624a6589bec155a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "89ffe935421dfc64ba97d3a94e026710f52eb0144971bbe610793c6491be606e"
    sha256 cellar: :any,                 arm64_sequoia: "caad0ea533cb2469016413dff60d495bac7856481f80dcbecd640055efe7e178"
    sha256 cellar: :any,                 arm64_sonoma:  "99e30c21e02b3254a19008898dc829d684601d7496c9fbd199706d706433969d"
    sha256 cellar: :any,                 sonoma:        "57fe1a30b1ff56e3303ddb2503169bda15bf3efc3e32f686308d660ddf5dcaa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41ab94aef9b3489f8b5f03baf6e26e09e0fa2ce1f453d5ea4886e20e0eacf4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab56ce4af2b663c6380b30c9c909c6062c872003c7ee4b91d6d55be4e27e72c"
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
