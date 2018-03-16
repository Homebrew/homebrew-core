class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
    :tag => "v9.2.0",
    :revision => "a8b6a9dcb6550ce652dc9f81bc92a28be7c9baf8"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "f38d0048c0492c0eda539f4fa67b8dd5139d868043aca6e297f178eafe369618" => :high_sierra
    sha256 "eec3a200ecdb25f224ffd2bd7b2b2a9c71cf65e0a67ab3550661df98c12fdbe8" => :sierra
    sha256 "495fd635c8f9f936c2cb4d7bf306253430b49258ff167c951ce294cc63dc0e5e" => :el_capitan
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
