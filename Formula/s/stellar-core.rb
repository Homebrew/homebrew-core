class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v21.1.0",
      revision: "b3aeb14cc798f6d11deb2be913041be916f3b0cc"
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
    sha256 cellar: :any,                 arm64_sonoma:   "a7ecf624d58c5397e328b7de784b542aba50af1bd2842cbca18861c04040bf80"
    sha256 cellar: :any,                 arm64_ventura:  "5a5231e045ebd9714646d13c73e92247c2a401879559a02efb9c93716f52c8b0"
    sha256 cellar: :any,                 arm64_monterey: "ec66a2049f7f1c695f0e1fa082a477c5ede7e55d7fd620877e97bdeeec33aaad"
    sha256 cellar: :any,                 ventura:        "d0f1aac8c0831d284a51487c70e0ed17c1266d94dcba761c3091313f9cc42c67"
    sha256 cellar: :any,                 monterey:       "d264099b21e38a38f133e386080b1005d404e8eaef99007b01904736e33a9e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4eceec6dc5ad70604e14d636706a730375fde77a02abca75fd53bee8deb012e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
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
      topology
    ]
    system bin/"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end
