class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
    :tag => "v9.1.0",
    :revision => "a278e95978bdac6d1015d82f4859dad780e752d3"
  head "https://github.com/stellar/stellar-core.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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
