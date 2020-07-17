class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.11.tar.gz"
  sha256 "ab7c5f70920199fe69993ae48e1000b7ee8e56644a1612a2aa0ad70f15600672"
  license "GPL-2.0"

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
