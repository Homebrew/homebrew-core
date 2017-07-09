class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.2.tar.gz"
  sha256 "82a96be0ab18d847f189f79e932b10d6fd47213868cd8c282e3523395c01999b"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "92eaf4a84c12a39bacb64f4e01ccf431798822a432a8215f69ebbaab924823fc" => :sierra
    sha256 "b5afb551e61a709eb6333276e0d5b16dced5ec7e08c138e5f702582caa03347b" => :el_capitan
    sha256 "38f4d8ce78bf285e753f7bfc43cf222ecc40471f34bb7672b4ac35be9f85e0a7" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
  end

  test do
    (testpath/"source.asm").write <<-EOS.undent
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
