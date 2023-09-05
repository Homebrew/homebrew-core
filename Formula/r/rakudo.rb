class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2023.08/rakudo-2023.08.tar.gz"
  sha256 "9f520a9267d0062033a175788d9315ed22592023066d916334231702c207eeb1"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "91b5948e44fec2b5807ce4d6cf29cb0b719039ba957125dc953d2c590370b29f"
    sha256 arm64_monterey: "68e7468576698fcb991707db4ae4b6a2728a7d46a515ec597cfa2897cdbf4157"
    sha256 arm64_big_sur:  "e7822b25032fedbeaeb61d6517ec1c0d15f54a4f002e538d6fab4eb30fe84b79"
    sha256 ventura:        "3bc4d586e24350b6763782778da55ed6f4e5dc0c2909a39d076cc7c2108a789a"
    sha256 monterey:       "ded1ae20e10f6094cf20e1fc51f4c4727c22e2485f7f3ad44fade6077cd4e7f1"
    sha256 big_sur:        "21e5b8be791dc9cc7d84e23bbf1e1927dda24e9a03d43d882cec5f5a7e61ba8f"
    sha256 x86_64_linux:   "53ea60f57acb6cacebc1d661c9f98783edc0f03c06e2dbd3c901af111bebea29"
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
