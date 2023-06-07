class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2023.05/rakudo-2023.05.tar.gz"
  sha256 "cfae1cf1321c8130e4746eb5f5c926f65adc9774e92c1b3a89c2c48f0b22236a"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "1cadf79611e50b222fdcb7fc9a70296cc1df5ee3745b820f702e997803f8bf57"
    sha256 arm64_monterey: "6919e482a6d3119f8ee652629c16704206ca32fef7da9603b98877e490eff8c5"
    sha256 arm64_big_sur:  "1688cf5177c4b6c22c496b3dd170dbf4b2d7b181bc8ef5214e54bab41bed5acb"
    sha256 ventura:        "5a3bce51e8af833b1ad7db104f05ad0dcec318ae3a1b062d7d141243701b0cba"
    sha256 monterey:       "64d15c712c7da9c8aba8f42bb25c4830a6a4d6159ae3291f85f98d061abad58d"
    sha256 big_sur:        "23cbc91aba395cef7909f431c926482a94d872adfdf2ccfa5f6591cf86ec0a9f"
    sha256 x86_64_linux:   "e02b77ad14c29f596925df3fd6f7198a38a95372b64fe3f5011e32fb549dfd8f"
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
