class Z80asm < Formula
  desc "Assembler for the Zilog Z80 microprcessor and compatibles"
  homepage "https://www.nongnu.org/z80asm/"
  url "https://download.savannah.gnu.org/releases/z80asm/z80asm-1.8.tar.gz"
  sha256 "67fba9940582cddfa70113235818fb52d81e5be3db483dfb0816acb330515f64"

  livecheck do
    url "https://download.savannah.gnu.org/releases/z80asm/"
    regex(/href=.*?z80asm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b34635e2c41ccbd32935bc104c11a9899a49d9e235c96cfe50ea58ae4423671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6640cd351024a204230edd8cdb5746ab3ff9aa8c325a5e9515380fa07d8ced84"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9bd7e0dfbbdad344386a242b47e72e67c820d90925c59a600770704416a71f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca1a1ffc5104cdbb1914469122c38ecc13ebe60222bab9a3b57d926cf1c68743"
    sha256 cellar: :any_skip_relocation, catalina:       "0e7b29aa5927fcf70d1f704cdc4d0b73477c39d2f624fff4264ab08a6675959d"
    sha256 cellar: :any_skip_relocation, mojave:         "564990d37a17d2fe91472212de5f0cff30990e47275a29e69f1061177c2b1fea"
    sha256 cellar: :any_skip_relocation, high_sierra:    "183abd9c47e5050aa9a3fb4f9ddbd8806f0154aedcc239e2d2b716e234e91ce5"
    sha256 cellar: :any_skip_relocation, sierra:         "2bf9a1b8ebae970b16ad7d4644a028ddcb21d8069f2f5d73d18d69881d7eca27"
    sha256 cellar: :any_skip_relocation, el_capitan:     "46446e7c3644dc58e1c5cc80b904863298f818d15c4aaad721e36cabae75207c"
    sha256 cellar: :any_skip_relocation, yosemite:       "f52e469f9e8ab4c30c6cce5cde41a52bfbdb06e8db88b8be80fb7c54cbb73a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17f78a08a62f5d5c322080e89ad6fb0d2887c5479b481e816c5253a5898df62d"
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
