class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v10.1.0",
      :revision => "1fe2e8a768ecc4db2d53a4a67fc733bb1e99ecd1"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "3203ed07db6511c82c7a70316a0d3458f8457be9ddeb0b4ebe14d3ad05c7eb97" => :mojave
    sha256 "b60d53c3aafcbdba140e1b2efaa7641a16861262d20573dcae9e95e1cdbc1d6b" => :high_sierra
    sha256 "d08d247b755bbce9502e4b862d3e46049df9c48d6f8c648241cec3bf9364a28c" => :sierra
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
