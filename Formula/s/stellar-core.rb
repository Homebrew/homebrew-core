class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v22.4.1",
      revision: "5d4528c331c553ccd8963ece9b0fbdd41efd43cb"
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
    sha256 cellar: :any,                 arm64_sequoia: "860254d33a2d578f583c16c50d2e49a7b0dc4adb28f509c3e9584208d79581e2"
    sha256 cellar: :any,                 arm64_sonoma:  "5b50abf0563e5fcd1501dca761b9dab2634529ed5bf0fc3592de4157964027db"
    sha256 cellar: :any,                 arm64_ventura: "004ec4897d6da078d4bcaffaeb6c85b078befee011a43dc972faa6ecb524f5a7"
    sha256 cellar: :any,                 sonoma:        "2ba9ace590045400a3fbf695f2f2d1ac79cd5f980a4f19bdc8cb2aabd9c27034"
    sha256 cellar: :any,                 ventura:       "ff13f56530c6a55b32e7150b46956b790909f7e383dcb4d5f6b943cad3d73b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f54889e142ef87bc90de29ed2f43a97ba7defb965cf26c6f5a73081e0b1eb7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7912218dda9cb3797c1d64432136cffbfd2809d684f52ea2371683c40ae2e2a5"
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
      bucketlistconsistent
    ]
    # Reduce tests on Intel macOS as runner is too slow and times out
    test_categories << "topology" if !OS.mac? || !Hardware::CPU.intel?

    system bin/"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end
