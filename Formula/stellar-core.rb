class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v13.1.0",
      :revision => "469b2e70dec29ade2c57d39bc9db129579e63207"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "daac05d53c9d2c9c1bcbaa0b5dd1ef2dd25cc181a0813f8c4c2b7790c740b151" => :catalina
    sha256 "a88b933d4bf936d9546441f16b39f7d8a7f687a97e35ff47433ec36cd8d393de" => :mojave
    sha256 "5bc0f1aafa73eb26f88775b68628436fa1591caf8ba92af75a4bfc4fd9f8c7d9" => :high_sierra
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

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
