class Z80asm < Formula
  desc "Assembler for the Zilog Z80 microprcessor and compatibles"
  homepage "https://www.nongnu.org/z80asm/"
  url "https://download.savannah.gnu.org/releases/z80asm/z80asm-1.8.tar.gz"
  sha256 "67fba9940582cddfa70113235818fb52d81e5be3db483dfb0816acb330515f64"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/z80asm/"
    regex(/href=.*?z80asm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "196ce6ca6e3dc40b4cc7a96be32fd22c7addc3d411eb227bb8a67407f749810f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ce392c70bff0caa5fd981cb09caca7a54d579c4e1f12c4f4e5644d2934e199fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84f96f8b6e4797f885d8922150ff0faeb5994bf37e851d81941c0070a38aaada"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea09a44bb614b9dd6ed3ccdafc33b517a745a7f51274d2e557ad3f9dc5f2a034"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b34635e2c41ccbd32935bc104c11a9899a49d9e235c96cfe50ea58ae4423671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6640cd351024a204230edd8cdb5746ab3ff9aa8c325a5e9515380fa07d8ced84"
    sha256 cellar: :any_skip_relocation, sonoma:         "e85b48f45856da17f20fdecd98d28067bc6734788615ed640aa55c17fcc53627"
    sha256 cellar: :any_skip_relocation, ventura:        "b4b724e61c1a4ac3f1d9067635de307fc16ae9a6f2ac0cc3939603a1c0b9ab21"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9bd7e0dfbbdad344386a242b47e72e67c820d90925c59a600770704416a71f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca1a1ffc5104cdbb1914469122c38ecc13ebe60222bab9a3b57d926cf1c68743"
    sha256 cellar: :any_skip_relocation, catalina:       "0e7b29aa5927fcf70d1f704cdc4d0b73477c39d2f624fff4264ab08a6675959d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eee5efb31003cfb93f245c5135ab4d22e8172474051397733327a942908240e5"
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
