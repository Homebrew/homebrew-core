class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v10.2.tar.gz"
  sha256 "c02045c70a26c224f1921dde67acd38eb570d2fb3fc4d5c19119cce7f62114db"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)(?:-fix)*["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d8ca0ef1d076a6ad9751fd83d2cb9b4136bfc475552984c81cc0f739c5a92ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f92f501f3e3a9183a0475fde4c0fbecb295ac3ad0b2fb9c57b86889591f9490e"
    sha256 cellar: :any_skip_relocation, monterey:       "615f48ed20c08134f6b9179dcbc309f3efb087d6649b4e9bcee5a62d64ac585f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc6db662561786b69914c0b6b980659c9769f383d3d8af8573aa85059735a607"
    sha256 cellar: :any_skip_relocation, catalina:       "e2c8be4e613ca7c010cb7143ce3bc79d6360eb2f6fb39940bc798dc3de8a790a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4259a83b65704eff0133136d667e97bdab8d322034aa9cb40c09aac0e6deb80b"
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
