class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v22.3.0",
      revision: "e643061a4a6e052dd96cac2c167559a9963f45f6"
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
    sha256 cellar: :any,                 arm64_sequoia: "d4cb5615d156f87d733549f57210a40239b5b6bcfd9e89f3b9205f36102e9dd5"
    sha256 cellar: :any,                 arm64_sonoma:  "27f7e0c48b467ee601542843f6c44b1751b42d9f7024f2875c1af6723b2b7a3a"
    sha256 cellar: :any,                 arm64_ventura: "d2c21e224b7e7468919867f4965af674bb1df2a64fb2a7556a013ac6c469d7a6"
    sha256 cellar: :any,                 sonoma:        "16448b8653aa7b0c98f91d38e3a935c94f3c2db6ecd5bd1d1085b8b3dee2a065"
    sha256 cellar: :any,                 ventura:       "203663dafb43c74c0a1d6dff46bfe625b9adde779528d8072748d4cd858c3084"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2235f7ccae63ae9193902983c878aff25ed87a482345bf74dd3c803181a0ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbbaf3e58aef189c1283aabb94b256ae837b4572c411401d02c57d56c67182aa"
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
