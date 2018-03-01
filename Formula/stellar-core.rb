class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
    :tag => "v9.1.0",
    :revision => "a278e95978bdac6d1015d82f4859dad780e752d3"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "2eb5403e7fcdf217e3bde9ec09919c7dcbc90f317c6a6adb2913997bf47618a1" => :high_sierra
    sha256 "e23598b805518739534c7f63b28b1612b7915db8569003fa2a10701cf65a7be3" => :sierra
    sha256 "d82469269c1807b742106205179951e8887e68eecf5804b7b73399e332d34559" => :el_capitan
  end

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
