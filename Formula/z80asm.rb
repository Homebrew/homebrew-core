class Z80asm < Formula
  desc "Assembler for the Zilog Z80 microprcessor and compatibles"
  homepage "https://www.nongnu.org/z80asm/"
  url "https://download.savannah.gnu.org/releases/z80asm/z80asm-1.8.tar.gz"
  sha256 "67fba9940582cddfa70113235818fb52d81e5be3db483dfb0816acb330515f64"

  bottle do
    cellar :any_skip_relocation
    sha256 "564990d37a17d2fe91472212de5f0cff30990e47275a29e69f1061177c2b1fea" => :mojave
    sha256 "183abd9c47e5050aa9a3fb4f9ddbd8806f0154aedcc239e2d2b716e234e91ce5" => :high_sierra
    sha256 "2bf9a1b8ebae970b16ad7d4644a028ddcb21d8069f2f5d73d18d69881d7eca27" => :sierra
    sha256 "46446e7c3644dc58e1c5cc80b904863298f818d15c4aaad721e36cabae75207c" => :el_capitan
    sha256 "f52e469f9e8ab4c30c6cce5cde41a52bfbdb06e8db88b8be80fb7c54cbb73a21" => :yosemite
    sha256 "ed0e94c25d70c23f537ffbf8440b909b5d652e6000ebacd89be024c7ceee0e3d" => :mavericks
  end

  def install
    system "make"

    bin.install "z80asm"
    man1.install "z80asm.1"
  end

  test do
    path = testpath/"a.asm"
    path.write "call 1234h\n"

    system bin/"z80asm", path
    code = File.open(testpath/"a.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0xcd, 0x34, 0x12], code
  end
end
