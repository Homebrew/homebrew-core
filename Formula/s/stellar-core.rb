class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v21.2.0",
      revision: "d78f48eacabb51753e34443de7618b956e61c59f"
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
    sha256 cellar: :any,                 arm64_sonoma:   "0b59cbf8f63d37b287c5e072e2fd4d901ead7cfb4ee090be3c1ed9d9c682aac5"
    sha256 cellar: :any,                 arm64_ventura:  "ac451768a9112f9a3775d39fdcf81dc72d64b06cf63d3f68725d2ba7c34a2c1a"
    sha256 cellar: :any,                 arm64_monterey: "2974a6b354ebfd127a66991f4c5c1e584019d7b5e61e33c723c8b41a01e1d3d5"
    sha256 cellar: :any,                 ventura:        "81d9847c1846ebef319c9df2d2b617a76ffb7efb26cc652c46aa02f39693a505"
    sha256 cellar: :any,                 monterey:       "e8bcb1c3c1a1f058f3cb8a07cae64a900903a63fb7b0ddd56fd71ba67117a679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b24e573998a6d0b79b21f00e0b8b80a578365be2dd88f61a55b6fe78533b22"
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
