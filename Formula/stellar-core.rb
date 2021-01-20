class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v15.2.0",
      revision: "54b03f755ae5d5aa12a799c8f1ee4d87fc9d1a1d"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "08ba23e842d24127f91e13d1cbbb930342de816f9c09d5b35252fe4b5777476e" => :big_sur
    sha256 "2076dacd445634910b73f447b349803ec166d197da50fd4b8419eea0cc226f08" => :catalina
    sha256 "b6d163bd6884e6bc01f230756254a95d75654d3c8c2de8dadc73e97c08eda045" => :mojave
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
