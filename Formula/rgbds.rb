class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.3.9.tar.gz"
  sha256 "218d5456807f390fd80276f418fdd884c9077aa9d8ab1784819e5fd62d524587"
  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any
    sha256 "d86c28d1967d8e083b2e7df6242d9cfb478d999b043791e24c1b00fdbb27d20f" => :catalina
    sha256 "d7d532c845f927504f24ba9426fa04a8f63c883a10feddddbb2c58a7d7f9d65d" => :mojave
    sha256 "b39350c4b40fc65a10dbdcd6577577bf639aec9ba386443e0b94062a82b9ed7f" => :high_sierra
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
