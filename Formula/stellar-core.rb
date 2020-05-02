class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v13.0.0",
      :revision => "9ed3da29be1c2c932b946025ca2907646a9072f4"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "286f0cc4b6b43001b4bbe20b02a8eadb6aaed057e30f2ad770728ea604f8d4c4" => :catalina
    sha256 "ddae2a56f3d655eb5cf46c08d0425e56cee674b7d12f612105a9dce9be9581b7" => :mojave
    sha256 "80a5a5834c08dd54a08b336f081d5232d613e4e427400e8e107c2db544544f74" => :high_sierra
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
