class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2024.07/rakudo-2024.07.tar.gz"
  sha256 "e1a92f19c3e987c84bf089947e5f17b498069949bcad1163cff516586764ae3c"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bf674ff78bc0e67ea81b619558f9e37f3c40c85cefb5513ef4a7b4a91132d281"
    sha256 arm64_ventura:  "36b8040d02621b92a1297f4d5ec73d4efc3366919489705b604d5747d7e3063c"
    sha256 arm64_monterey: "8aaee88b521cd66923302d86423c9dfdf727d752bcd503a2e41016c9352059b7"
    sha256 sonoma:         "a656039ba9e84c794b9ba68034f86fcd4925efc9cde9517fb9fab979850d7b67"
    sha256 ventura:        "a10b30af6116db1313c1a9eec224f8116b9d78b8ce71d357b19688c4449e3183"
    sha256 monterey:       "c14514e784b16c73e74624f14d35b1f36cc4178fa2cefb4e7c9ee0cd52e081ac"
    sha256 x86_64_linux:   "545c259e30378006cc3068e69312e6bc000ef37f01bf8cba12a276f70a6989ee"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"
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
