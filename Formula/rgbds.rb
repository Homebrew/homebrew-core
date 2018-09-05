class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.7.tar.gz"
  sha256 "5ddd8b9d57e91c798f464e83fa723cdbab45376958a56a554fbfb3c417844bfc"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "b450ab98422628d5f2aef362abffce54907bff681d6ecb29bfce3cf94fea6f73" => :mojave
    sha256 "814d8937cc9e989f7a69eb4df68a1b26e1863287ef45eaab40f4fb99717392f8" => :high_sierra
    sha256 "f526669d5a58a35c04ee3eff2ddea03ab1af7b58ed1f035319ce0385280ab08b" => :sierra
    sha256 "d7440703be2002305b713672f4bd5dacfdbcdc84ed5d7a06b9d579b9195055eb" => :el_capitan
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
