class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2024.02/rakudo-2024.02.tar.gz"
  sha256 "41ad8d8045137f0e0801ba069fff6e5238b090953b0d5029b44dc02968abf782"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bd035aa66bad4663a6a627dba3ee22a3a747dbb57a1933c8dbe039f58e06f08e"
    sha256 arm64_ventura:  "c8594b1f52be7a5f4ab4822668e092b94896c89a2291ed38a679fb8e11937290"
    sha256 arm64_monterey: "cf4aeecd2321cbb2c2594064f999ac316acd0e8a120cd60fdb19a38426feb2a0"
    sha256 sonoma:         "88424b3b78428da0bb789da25b293bec59153c0e698f78e8d3147f4d2b83ee16"
    sha256 ventura:        "7cf4c8d63ca44455dddbe70b7c408b6adb45c562e9facab97c80f02656683489"
    sha256 monterey:       "3715042f5fa21fd33a2209553bbe81e3fa80e90fb6a6ac596d1501225c130d25"
    sha256 x86_64_linux:   "eba664918ffca779de223dbe923b1f41d090f7f12cdfbdc93b5dd11527f03536"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "nqp"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
