class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.11-fix-fix-fix.tar.gz"
  sha256 "7ac29b50492ece1d3d47db040219488a120f6cd613110b1e4c5d5d79790b1139"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8f0d4747eb9ef0885ddf6c08b3d4ac980bd2b6dbaaa9f5048ea7aa4bc6f681b8" => :catalina
    sha256 "b515cc9b31fd4d978143c518555b02873fabff5ef390d369575c3d3e99606326" => :mojave
    sha256 "0ed73304d947e4ea44431c06df38bb6887a7551f575ade25a6b63ce7b27187c7" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test-gb-asm.s").write <<~EOS
      .MEMORYMAP
       DEFAULTSLOT 1.01
       SLOT 0.001 $0000 $2000
       SLOT 1.2 STArT $2000 sIzE $6000
       .ENDME

       .ROMBANKMAP
       BANKSTOTAL 2
       BANKSIZE $2000
       BANKS 1
       BANKSIZE $6000
       BANKS 1
       .ENDRO

       .BANK 1 SLOT 1

       .ORGA $2000


       ld hl, sp+127
       ld hl, sp-128
       add sp, -128
       add sp, 127
       adc 200
       jr -128
       jr 127
       jr nc, 127
    EOS
    system bin/"wla-gb", "-o", testpath/"test-gb-asm.s"
  end
end
