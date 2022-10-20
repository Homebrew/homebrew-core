class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.3.0",
      revision: "9ce6dc4e9889ce86083c0e3ba2e773e0ff2ced3a"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "186883a46b6ea40ed57cfd73bfdafc9c0851e959276fe7129448e9264b1381ae"
    sha256 cellar: :any,                 arm64_big_sur:  "f2675972968d89533a57bc62e8a1986e5f80fab849a82d48d429edfd6411e4d1"
    sha256 cellar: :any,                 monterey:       "5da6984516ff8cf8bd070f747c08378d1dab7a111759804e4fbc72fbd185885d"
    sha256 cellar: :any,                 big_sur:        "48e88ea4cf0d8766b836e25baad281e850176827137db221b44c616a26c771ed"
    sha256 cellar: :any,                 catalina:       "59c092d3a45e4a8c11225fc928301a0ec50e1191aa4377d5a25b0b316cf7a943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576ae0b79ec1f32bd48113c5193d0ce715d7694016701e1a739ecb688ceffad4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
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
