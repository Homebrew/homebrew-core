class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v10.0.0",
      :revision => "1fc018b4f52e8c7e716b023ccf30600af5b4f66d"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "713ae3fcf00a522fa02c4086ca31139848278580587fa3658f10452476d7ac6d" => :mojave
    sha256 "103de6a0ae5ef42cd2b8a91cdd681541d9458bde9932a00a6631ca72eaad8905" => :high_sierra
    sha256 "daad2ec61b924be34738b0bb48cabbb2001d490f912f949d7576780ec6e1b004" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libsodium"
  depends_on "postgresql"

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
    system "#{bin}/stellar-core", "--test", "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount],[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
