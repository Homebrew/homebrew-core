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
    sha256 arm64_ventura:  "085640832724a98add766b9a42cc03948154cf707ddeef46d67ccb1d20d799eb"
    sha256 arm64_monterey: "e471cef0702a0f38f090cad88c071e4a88e6eeef355278f7542760cdc942d24a"
    sha256 arm64_big_sur:  "5917c2fde50b20002eaaadbbd301a8e926463dd69ef0a456e80e179ec8bebaa8"
    sha256 ventura:        "da7593c192709ace8c1e8ecae54d54d8c25639e0114ba7c18d51d5ec2f703160"
    sha256 monterey:       "c797d1b9314cb79ab21fbcbd10b7e996df43a9f8d21410dc82c19b8970e84e71"
    sha256 big_sur:        "e5db77f4cc28a4b749d9e7e96d5b179b9b7a113c1fdd691f4fa819424a2b6b1d"
    sha256 x86_64_linux:   "f3827940afb9b1df7077efc41d200acea850cf2f8d85094074dd902fb5cebcdb"
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
