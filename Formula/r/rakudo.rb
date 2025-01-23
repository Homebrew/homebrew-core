class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2024.12/rakudo-2024.12.tar.gz"
  sha256 "15d1ba405ea5cd74bde7c2a7e51546b74394ba0b01b23c9d215362cfc718c96a"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "f7473c8d62a7f552668679cd32acfeaffa66e550555443e8cccf34a31c833fa7"
    sha256 arm64_sonoma:  "b750c763232be865a4c0b65c88090c9a7375e9ab2059f56ded70b75382dbf4d5"
    sha256 arm64_ventura: "70daf3bd0127a20ccc7818909a65fc593e97ff454a1bb14095de607d9c361c9c"
    sha256 sonoma:        "eb28e95a442cd5d7457e12567429820903439953096f9a981b5eae59638bccbc"
    sha256 ventura:       "bc18bf1fc019c4e7d9dc1019be9a12f70e5afeb759aa012f3669e13c0e4781dc"
    sha256 x86_64_linux:  "13d529274a9972da1986f66c5a25a9ca5159f5e0deb65ac222ad9b983bfe9b6f"
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
