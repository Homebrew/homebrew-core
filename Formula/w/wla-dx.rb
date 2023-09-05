class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v10.5.tar.gz"
  sha256 "b2d093c3c46caa399ed3a8e5f18f1f0eb7aefa958755bec752f2806bad3af802"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)(?:-fix)*/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a57579303e021b9166138b11fcf0491ad8c87bcaea0d5f0dd8d498468b685d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7e70e4cc97cdecd269d28f3e59516e85d4a86c3fa523555d4c5bc2c9e486c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ffdf36dc32cc35cca6f7ba63f60457fb6fcca206394f8aeb757f20bb259a2e6"
    sha256 cellar: :any_skip_relocation, ventura:        "24a9223c1db8e91d1955700d3c7a1bca0884f840ff3f5c544decdccedf340bd9"
    sha256 cellar: :any_skip_relocation, monterey:       "d14bedd366731a95c1c6cc97bef89948dd480cc5406325137c9e32f9c540db40"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0ac6385b89dc578b155af3aac5eff0c135a64b4def3b679a33c44e6e3ea5e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ecc3e3dcc4955bc7245365bf0836acd7498eead3549061e57fae55c27df48ca"
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
