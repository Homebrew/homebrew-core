class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.12.tar.gz"
  sha256 "c5e2b1825cfb88d593379d48bd4971764a83124429e6ecb85ff1150dcf7b78f8"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)(?:-fix)*["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b6cd5053d923d270c9f0b7bb742c38365ce4c919bc79a96a85f11c79b6f327dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "a729e8e4d469169c6fc95061319c2ec671559ed4be526e2d18e86294f76e6baa"
    sha256 cellar: :any_skip_relocation, catalina:      "4946b7b021ec97dde39a00d445d4d9a0aecec69f6b7b7f69495a9e00ab99130a"
    sha256 cellar: :any_skip_relocation, mojave:        "b77b237add5437bb0f4ee190fa07f267d46837bf1ffa924bc1c5f2cdc536d747"
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
