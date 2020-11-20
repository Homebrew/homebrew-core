class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v15.0.0",
      revision: "8d6e6d74cfae65943211bdcc5ba083976d525a04"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "ad24e3feb5b24aae9e3215aa3ec2e2415bc1f9fb926a67f0716f74f6c506f9ee" => :big_sur
    sha256 "530c0b445fb3ff8f3b605ac1be74075b7da4b94a754b8717413066bc85d0c221" => :catalina
    sha256 "9c848143e59520263fe4755087c1c22da6fe99a9bac0d83e63bb684af50f6e7c" => :mojave
    sha256 "d98413d62b354b9e2a552a3116cbc46d64bbd317278d518f0b17aa933c797562" => :high_sierra
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
