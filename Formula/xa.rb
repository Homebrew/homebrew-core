class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.8.tar.gz"
  sha256 "3b97d2fe8891336676ca28ff127b69e997f0b5accf2c7009b4517496929b462a"

  bottle do
    cellar :any_skip_relocation
    sha256 "3efcb7fa86b3cf417f239ad749d5a3c6ec5d7c12aac08f5619917fb8e7c24335" => :mojave
    sha256 "8b72ad60db64443a0f7a821059221573e258e4a3e99621e5defebe71bda1d322" => :high_sierra
    sha256 "c3148f1d7318b3e1757bdae5c7cca5d0f5cd15d1dbb3fbf33880c0b22ee525f1" => :sierra
    sha256 "937cdf0951ddd716ff654d3d959f862bb838c830a5194de220c3c60c118895c5" => :el_capitan
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
