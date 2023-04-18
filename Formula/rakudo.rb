class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2023.02/rakudo-2023.02.tar.gz"
  sha256 "fd1686aa2cf32eb9f0eb7d0d6f96dfc897cf53ccf89eda7d225b68738093aa11"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "f784bc463b9b84d74fa23e55b1bd00045207600d3946db955059e599f9b582c2"
    sha256 arm64_monterey: "c77bf91095221aaaecc6a4dc00260c1ed57eca47a54eac43a61e04d01eece50d"
    sha256 arm64_big_sur:  "a38552ffcd1498e2442e7b225969ec1895d1ca9f2dafee2d4b7880e05ebe0697"
    sha256 ventura:        "007938ae1348e4b18f751d7caa2aa4484a8c6f0f9d9ce9b8b550e820a4d50fbf"
    sha256 monterey:       "581def6d9f8da2a3fef04af2a3e65c97131470dbee4035dbec748663d78f9b79"
    sha256 big_sur:        "c0578dda4212a90ac1f369d1a0604fd19fd98dcaf079fe273ecca17f0f7bcc9b"
    sha256 x86_64_linux:   "053bb23f56e4a463ad7c7aade284c1736e22c2e164b8b99c735d83c78322a198"
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
