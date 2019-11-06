class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.9.tar.gz"
  sha256 "8d3097d3b75adf4305d7d5c8e8f2568a7176cb348bcc50006cfc58378540c555"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d0d90da2fd47164ebd040576077653818cde1596e6772b2a8dde81a139c974f" => :catalina
    sha256 "c158ac34c430221611c8fec3144c7b489ed65e99e459325a528e14a2cd727489" => :mojave
    sha256 "b9b214c757c86617774275ea57f8191e7ca46b21ce3f879387cce5e388eb285f" => :high_sierra
    sha256 "9a16e276c370a5afb7ae4379e10318660d15375a0baa86550c6f16e662559ee1" => :sierra
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
