class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v18.5.0",
      revision: "d387c6a710322135ac076804490af22c4587b96d"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "11a3b74170d606d3bf4c51249759d10b843d66521e7de1943dbfd3ec3e186531"
    sha256 cellar: :any,                 arm64_big_sur:  "d8532a5c496876b87253ad8a36555b0c52839db239f7ef9fb1aa1437966e78e6"
    sha256 cellar: :any,                 monterey:       "7db773c16d46a328b96ec10ca7b4dfa7fd0c18949d6605c8675e438d3801320b"
    sha256 cellar: :any,                 big_sur:        "9ba2eb078a4aa55ebe4f72109609a1235313cf5d03aa38358e8c6b0a77f8e6dc"
    sha256 cellar: :any,                 catalina:       "8a62fe1017d33b31b5bc9ceeb58e59321dfa69d9bd96117a778e04ed43df87e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd3cafc74d62dd91b32a6d87a321ef32fc7c224b0bd6863e8ab9e53b3aceb4f6"
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
