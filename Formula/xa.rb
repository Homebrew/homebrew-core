class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.11.tar.gz"
  sha256 "32f2164c99e305218e992970856dd8e2309b5cb6ac4758d7b2afe3bfebc9012d"

  bottle do
    cellar :any_skip_relocation
    sha256 "82ac5a005305bb5fd7ff181e2f9aae95ad5f865574ed4cb8f936948cce406a72" => :catalina
    sha256 "6dfd866eea2c29d98aabbe4b9a0821ad9b808b0d2b7754b3400f5bb4f4cb4184" => :mojave
    sha256 "40334865dd2af12409a5c52ed9a8d3a5bd6b781da28375509e2481bd885c87e4" => :high_sierra
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
