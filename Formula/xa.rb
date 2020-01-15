class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.10.tar.gz"
  sha256 "867b5b26b6524be8bcfbad8820ab3efe422b3e0cc9775dcb743284778868ba78"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7ca86ebe05ac3c1ef9d7bc913f1739bd59785881648a087bd370e5e4ecb924e" => :catalina
    sha256 "91e6b38512dffcf6461b1efc4991741d810b2e8f2c9769e1bf1e924b4c521a74" => :mojave
    sha256 "87a75218bf44a6a8ea52a38ad28b6585499b970eea0e11624232c083667446c2" => :high_sierra
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end
