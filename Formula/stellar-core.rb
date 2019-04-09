class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v10.3.0",
      :revision => "de204d718a4603fba2c36d79a7cccad415dd1597"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "f7ee7ab3bdc5d6af649d6353096515a745368af0ec63bb4871423a2fa7150ac6" => :mojave
    sha256 "86ece26af68a770a246f2d9216cafde9e9dadb898863a85a77424f779db3674f" => :high_sierra
    sha256 "2f30560c708c16a8b70fef75c378cd6f36d0c3840dfec0bea1f7217cbb81c683" => :sierra
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
