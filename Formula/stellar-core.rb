class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v12.4.0",
      :revision => "c47415d4cd2b313a6f89fcb5ee7de46feb4673a1"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "f7144241fcacc349100cababd61a79ae5695f2e79cfb931f225b18ec0041a32b" => :catalina
    sha256 "56cf031923c63c1fb0228980b1f59e7d125bd877ff8658a08045f1a92cecd963" => :mojave
    sha256 "02f118eca380d8e2f8dbfd7883e3481a3338c11457735b88cbfb4004fe8424d7" => :high_sierra
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
    system "#{bin}/stellar-core", "test", "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount],[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
