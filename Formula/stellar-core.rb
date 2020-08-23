class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v13.2.0",
      revision: "e45018ea97695592bc9e7a61cfdbfb6b5411b84a"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "36cbcda3bb3064cdbedf6a37925757227087d50d513b65ed6fd83e731b9496ab" => :catalina
    sha256 "c789eb0cedc23e5878e702119b9a6c6f1ef853b512ac926d8a9ef13146231649" => :mojave
    sha256 "76d0a3743be0948ccb584677a98a1994711ff8d74750f8c5149ff3f858bd6b33" => :high_sierra
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
