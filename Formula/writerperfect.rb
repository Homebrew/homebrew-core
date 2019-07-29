class Writerperfect < Formula
  desc "Library for importing WordPerfect documents"
  homepage "https://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.6/writerperfect-0.9.6.tar.xz"
  sha256 "1fe162145013a9786b201cb69724b2d55ff2bf2354c3cd188fd4466e7fc324e6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5e8658459f44238800ff490331d50aa6a71b48115157893c78901a4441a34dd3" => :mojave
    sha256 "12f30a1f15f5887da7675026656f59dd74b7fbffdf4129a2c1778578dbf4cc4a" => :high_sierra
    sha256 "36981e968c146d8aeca47d96327b3f3e909a3f58ca15bed17202e93fef6e17db" => :sierra
    sha256 "549f41525d1a5cf4cad493650ea0f8daae0208246f36984d6a56a4af533fc881" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "libodfgen"
  depends_on "libwpd"
  depends_on "libwpg"
  depends_on "libwps"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
