class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.11-fix-fix-fix.tar.gz"
  sha256 "7ac29b50492ece1d3d47db040219488a120f6cd613110b1e4c5d5d79790b1139"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e851b78047927db8fef64911fdb6df9bc046ee304e6af9d78f52c9cdd20e9d85" => :catalina
    sha256 "e1440068792536cf0c902e190b395d9075d22872370c14f6f7062e7e3bf7bf30" => :mojave
    sha256 "34c0184ae1a71bd11365f42bcb44627ea6d3f91b8f4e83aec8ab4d4b5f15964f" => :high_sierra
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
