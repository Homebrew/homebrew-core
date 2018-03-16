class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.5.tar.gz"
  sha256 "f1c5d986624573522b289d166d417a840b7d8fc311c1c4d5e97b1343b737b464"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "b1287b2b3f9613f0cafd154dc7e32e1804da97096b6ee4a38f0219daf9ec84a8" => :high_sierra
    sha256 "8317e8389aecd39ae3fdd8b28d93b153ceb39abd9231bb20edd2b6caedf8e03b" => :sierra
    sha256 "d4afe4f7e88f6392c45a8c7e7e0d64e710e66dd4caf1d3894f54f4bafc4c966b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
  end

  test do
    (testpath/"source.asm").write <<~EOS
      SECTION "Org $100",HOME[$100]
      nop
      jp begin
      begin:
        ld sp, $ffff
        ld a, $1
        ld b, a
        add a, b
    EOS
    system "#{bin}/rgbasm", "source.asm"
  end
end
