class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.10.tar.gz"
  sha256 "a04eb7b0bdc314ba7cefd5ed1f8529ecc1b18ef524e8f7446e1a2cbf76fdcc4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c5a8c948703a0ac4b10a50b01fba6b175b412512afa49b0ca06bd5470fe95ae" => :catalina
    sha256 "bae03cdacfcbb537e7ee12fb419f87133d9554122994e297fe20daf4b54148bf" => :mojave
    sha256 "5a317d40754e1387fffe605ed373d03d1acd43247e49cae4e6bc80e9e909c3b7" => :high_sierra
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
