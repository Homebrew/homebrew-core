class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v20.4.0",
      revision: "7fc7671b8bc1ccc3b1f16a6ab83bc9f671db8b70"
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
    sha256 cellar: :any,                 arm64_sonoma:   "ec45f17fec3bb568029925c38d3145a664c42c37b0ba038334efa1fe2e27bfd5"
    sha256 cellar: :any,                 arm64_ventura:  "4fb059fab7c88052472b1b0cbfb628b1c8b57200adb3c91e7d631d454ff75f95"
    sha256 cellar: :any,                 arm64_monterey: "7ce21b48566f96764c36dc962188b86aa80878173ab7ede218a0026d54295ccf"
    sha256 cellar: :any,                 ventura:        "bfbbf0872d9db07197fe17b2f4a4e2c0e72b170610da55243f3a9142871f76ea"
    sha256 cellar: :any,                 monterey:       "3976e9131b2158d01e54efe8fd919f841cb65272d6ca9dfdc59ea54eb103fd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d08530260e8801b9e0d82f90d5bb0a5bf82aba51f163d29addd9bca858faf27"
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
