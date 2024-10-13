class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v21.3.1",
      revision: "4ede19620438bcd136276cdc8d4ed1f2c3b64624"
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
    sha256 cellar: :any,                 arm64_sequoia:  "d27bf9f7b85ed2b096c96dd87e5eb07dacb468b36745382771fbe4b806b28311"
    sha256 cellar: :any,                 arm64_sonoma:   "6050375e677593dbefe6a2cd87339dfdb2cbcc33fc8a6089fdf3d614a3f56c68"
    sha256 cellar: :any,                 arm64_ventura:  "c901d6d438b358488ac813fa40dcb05503425cf7049a9a2972118269ba07f160"
    sha256 cellar: :any,                 arm64_monterey: "3d454b4ed02f39b9aaf522ece2169a7d2396a07b0da55f83b3c85d2b994f91f3"
    sha256 cellar: :any,                 sonoma:         "c34085dacf3e90f69b4481860623f7e0bd1e14afd300bf4dac4d53d65c92ee61"
    sha256 cellar: :any,                 ventura:        "a9bf5d2838c834ea3155022eeb534802cb008a1984b2b4ba7785f0bbf4bfbb40"
    sha256 cellar: :any,                 monterey:       "c494a82c424a3a6b183f581bffd43918f59cfde3e5d616d0ec9f9ad2df2f4b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d6508a9cb75fdf830de986429acc15bf590e7cc10e47089f5ba488350f71a6d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem

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
