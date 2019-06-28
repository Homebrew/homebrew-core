class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v11.2.0",
      :revision => "f3857733a9b67da4528df59bb616ea84ba539a1a"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "c1473918971a04861605c718abe38686d16b0ba4ec508766792354abc90cf128" => :mojave
    sha256 "ce9b538a413cc7b36734b5e59723359f1e610e6ac54dfe59b5626c88f8f851ca" => :high_sierra
    sha256 "859222f7f6df9135ef4c833c7bd7f377273f31183fb5fa50193f91f1fdae43b0" => :sierra
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
