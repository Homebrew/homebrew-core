class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.7.tar.gz"
  sha256 "22d544ab9f596df7f4141c26bec9735de790213d22e18d11c9b4bd12253e1420"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d0dfce3510dbeb60d876cfa9d470453c7e2a48e49d691683e5b03def051a788" => :mojave
    sha256 "227175578a34d7e37a67c7a1d54f578880b9d433168f2863e8550ea0e8b4dfd5" => :high_sierra
    sha256 "831b9f5f6b67d9f51ee41d6b9b582506c93a5a677631ca8c996401bffb58961a" => :sierra
    sha256 "f9f5a3c5e03f4145b30f09b42d8d247aae1f13b86dceee53efeb9f2b16ec0b00" => :el_capitan
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
