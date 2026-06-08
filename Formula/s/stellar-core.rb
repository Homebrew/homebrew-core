class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v27.0.0",
      revision: "7696c069d720fb450caeae940769b0a78a157363"
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
    sha256 cellar: :any, arm64_tahoe:   "e1db35501b6114292b42da01af8f9d71ce0eec5f4e9a657bbde5e390df1529a5"
    sha256 cellar: :any, arm64_sequoia: "30d13f361af9b31b3a15884722b2b06d3447b13f163c6301b171a6b6e2f6bcd6"
    sha256 cellar: :any, arm64_sonoma:  "dd46939dda24b035ccaf933368944fab0b2aee32f204aab40a7a7b229273c491"
    sha256 cellar: :any, sonoma:        "e9a008523ee45b367d4c88b0ddc4d0f2f56b9064beb5ab73a38687675e7784af"
    sha256               arm64_linux:   "5ebd789973f1a08f5666f8930f8a3b8fb00c7d323f439bfcec2908cf8086dbaa"
    sha256               x86_64_linux:  "b51e342ceed541af963752990c98ebbbc9aacccafee9a5f4bc3ad29bab2b8469"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpq"

  uses_from_macos "flex" => :build

  on_sonoma :or_older do
    depends_on "coreutils" => :build # for sha256sum
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
