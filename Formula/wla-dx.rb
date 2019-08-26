class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.9.tar.gz"
  sha256 "cacf7afef2563531cbe48c4254eb167b0857b517be43084cf5a21099157566d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea1179e52f2e6ff8ba5ce43cff8e8e4bdc3d050950e3745c82ebaa8ef56ed5ba" => :mojave
    sha256 "b74e16e919cfc93bbabfa5d6b9590f84b887888eefc57f077c622f55243d7d14" => :high_sierra
    sha256 "7e4e07701cd206f2d88e63a6b88f0e1c299589e9f2737b67ec15e64e557b78e9" => :sierra
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
