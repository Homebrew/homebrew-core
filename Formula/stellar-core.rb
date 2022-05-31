class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.1.0",
      revision: "e801fd93b2757bebb18ae8b4550afba444d225af"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9de5d0e688df4ff40412d0608631ef843c314b11decb50919b374bc9f7185ee7"
    sha256 cellar: :any,                 arm64_big_sur:  "9ee6a195da5e5743b8e8863480beab027e77ce158a7a240b6946ce929546f3d4"
    sha256 cellar: :any,                 monterey:       "40cf6974be6ec750e39766603661975dda453ac53e10c1749724148783f28d22"
    sha256 cellar: :any,                 big_sur:        "ea38b51bf05d38c2a960aaf3de67539922626b866bace5c5f15a253b9b107e0b"
    sha256 cellar: :any,                 catalina:       "3f9af9a4da2b981da6ac202201535f58a2cc6a910c0c53117ad9cdb4883552b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a606e6df4e7f991c0fba56c5b36be1c550a57661dd6c6ac69806e15ad5bff8e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    system "#{bin}/stellar-core", "test",
      "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount]," \
      "[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
