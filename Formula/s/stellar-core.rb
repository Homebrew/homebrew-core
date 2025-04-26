class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v22.2.0",
      revision: "e6c1f3bfcf9ef7b07b718b4984283c1c0bb91acd"
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
    sha256 cellar: :any,                 arm64_sequoia: "226fc71cead41d70628e8c7a54e0c27b0e51601259d276d4300a7b2edee85c53"
    sha256 cellar: :any,                 arm64_sonoma:  "69dabc43e9c9cfefcb7d2acfb4cd34a9c3f748d7ddd2c275d652aa1234e650ee"
    sha256 cellar: :any,                 arm64_ventura: "925f3a5acdcb3238b5b33b1809d3b46f52cf7488dea06fbb912f9b397ed0ec94"
    sha256 cellar: :any,                 sonoma:        "c26b081ddccec3cb08251aeec08c9fcdcffeae48065ab62b8c7e884852970811"
    sha256 cellar: :any,                 ventura:       "1ad8bf4a3cb97b6f649d2ab07a7b50457a2307fc4b31174b6f339965d333926b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0a79074e8bc2d29fc3b2ac078e1e3463d1a6aac4e50fe51be9f274878bc6176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a5c12e89785725ea1baa9c5ac05ed422b4609e78f897d6506187d77fbd7569"
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
