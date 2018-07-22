class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
    :tag => "v9.2.0",
    :revision => "7561c1d53366ec79b908de533726269e08474f77"
  revision 1
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "42973d1b0d23fa0d64d27c171a3feeb7256545030e678637b7ba428df6d066ed" => :high_sierra
    sha256 "1f6be307febae9e4711669efe0e04f02d88884e10dc6a590e5c8c2e7ade321d5" => :sierra
    sha256 "441e28cb07e72faf6d89e15a47b0bfc4469c2faa95ee2671ce33e2184b843914" => :el_capitan
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
