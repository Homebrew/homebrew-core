class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2023.09/rakudo-2023.09.tar.gz"
  sha256 "e33b9999f2157721faa97a9a3df52825759680f777bc480a922bdd20757e0cf7"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "37e968cbd9e9df5fa12e359f68b862800ed34c220dddfbf9f2e0cbd28f4c8036"
    sha256 arm64_monterey: "ba928972182ad121c2cd2f87a323b761fbaf3f04f5012faceda48f83a0dd0c3d"
    sha256 arm64_big_sur:  "ede21c4f9da8441a6db1783c9ff7874fa9df066cd92d8046f1a98e74582cbf3b"
    sha256 ventura:        "d565edf7336a06139678b87ecd6c02ff34ed317b1f4489b019dd88e8660d34bb"
    sha256 monterey:       "b3b7e5f5a6b0e7d664d9c5c48a962f9c03a9a31559fcdf1a5b25e9cf57b6484c"
    sha256 big_sur:        "204177d792bbec421abd38fff5a1e25fe87f35625378e8aa5f1e83bb2474b3de"
    sha256 x86_64_linux:   "da09c10ce071e7635f3f6518d47251289d8c264bd343088ce0857874e044b514"
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
