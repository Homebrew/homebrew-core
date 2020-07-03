class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v13.2.0",
      :revision => "e45018ea97695592bc9e7a61cfdbfb6b5411b84a"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "be37793c1041c8d01fb3c038f2042a8f02887f53decee5f9b5ba19891214d0c0" => :catalina
    sha256 "77f0e8ac437a797320c8351e7aa0cfddd296a1299b5ba1994f34641eb6ec3c63" => :mojave
    sha256 "5d576008e89a26149afaae80971823f59b474bf3ae55f01e8ceca491e5d812e5" => :high_sierra
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
