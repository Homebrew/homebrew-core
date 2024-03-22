class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v20.3.0",
      revision: "1609a7a5ce2bcd69a18ce439b2c4e9e13420bcde"
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
    sha256 cellar: :any,                 arm64_sonoma:   "840a75fdcc9a82cf2152b2657b96d2b79ac3d2aaf5624c9301b1eb6f71ad5177"
    sha256 cellar: :any,                 arm64_ventura:  "9906f23e0da6bc81e0904efc6f606058776a2fc2c8bae8a410708c69f9b516d1"
    sha256 cellar: :any,                 arm64_monterey: "b3b2c2122628ecbbf213b06e2e4cc7c05a8cb802f33f9c36db7168aa29f4f988"
    sha256 cellar: :any,                 ventura:        "0b64edf8c2007ac5d733fc564d860f7e5f2290cbb7d37a21a9ae84703ea2d418"
    sha256 cellar: :any,                 monterey:       "a0aec355ecaee41e0d87afccd4bec1a73f322ec794b302bb728359ed5b413fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3793e8929b124c247cc0830d08ea4d3a9818e130350f4379b6dcd646db11745"
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
