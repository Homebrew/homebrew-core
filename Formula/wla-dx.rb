class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.8.tar.gz"
  sha256 "5acc4ba687bdc5ff0473e9481f19caa3295c775ae41fcbe17a943b9242f5e573"

  bottle do
    cellar :any_skip_relocation
    sha256 "821ba59838a21aba2902d6f4009bff8f3ee271bb4ffed059c7a62408c1b5d7c8" => :mojave
    sha256 "258a0adc9acc3b6f35da707668dc57e8cb23d83f364b3338483a882d3b54e41b" => :high_sierra
    sha256 "e338576a6ce16f0d6382303100326ab2dc2adb91a74e01e0e7bf5557bb355d8d" => :sierra
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
