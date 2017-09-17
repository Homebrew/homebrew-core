class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.3.tar.gz"
  sha256 "593c69e9a6a6eb79fca0b452e89b72b549a16eb2d2a4278c3de4aa5cdaeb7ca5"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "e5fafa169196604eacf34fd51f6a28236a2a9ce1fea6f7cad8512f2d372f9f6a" => :sierra
    sha256 "3c537be61217d128f08d7d19a10ac00a2c2561dc826a9583ab0110ef131acbbb" => :el_capitan
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
