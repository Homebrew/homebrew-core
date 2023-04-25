class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2023.04/rakudo-2023.04.tar.gz"
  sha256 "810b12bd7ef45178fa92371c593094fa731a94e6e4894596bf542222fedd983d"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "b4e0b405d88f3449b82df1080557e34f4cde2a4d316859aae1902c481735575a"
    sha256 arm64_monterey: "f7fa9859025bb3b83683353c4b76444242302575d14f0e76d8e0afd54c654e3d"
    sha256 arm64_big_sur:  "39382dc475c3d5378dadef3d89cd142b9cd415d5e1653f51640d4a420b407cb4"
    sha256 ventura:        "84075898f36ad6f8fd6d7d66c82d3bb01c3c87db022da9102cf52d08d84ff2da"
    sha256 monterey:       "27809ccc97fed82fed84784d880cdce2288e9e5f7d9df513ea22c0a66293d2a5"
    sha256 big_sur:        "b24a467985dec403242008cbc36b77ef3d2c7df44c4dc7e53082f2ce9300099b"
    sha256 x86_64_linux:   "525e141039625c1f5a2b918f220afd1002d3f3ed44db0563dc789ffd30ac4ae9"
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
