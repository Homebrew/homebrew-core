class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v10.0.tar.gz"
  sha256 "0ccc2b9a43b9ae9f6a95a6df6032e15d0815132476ec176e5759b9d14d0077d4"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)(?:-fix)*["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "723085318854f1bdbb5c58446a858841d1e276e3f6179584643a21a0d3abce9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d3ae6b8ecb78d43c5d475c3e12a2ab139608682ac50205541aa2792738121a8"
    sha256 cellar: :any_skip_relocation, monterey:       "8528e631fd44a87cf339284fbd73232772d5ceeaa26682e3be4ce1c7d06d4fc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5f923d5b2868582fb46f23ed340246d921fd6f58e4119cb65172eb76f5156f7"
    sha256 cellar: :any_skip_relocation, catalina:       "5158594f32b15295a50814c6108800d7f689371e39a5a363e035f3be49e18be9"
    sha256 cellar: :any_skip_relocation, mojave:         "a01d1aab6f7380a4fa44facf9aeb31a9578d25acc093c2cb8743cbec7ecacf10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0dc2d2cc7aaa6f84b5795290bb7404ed0e95786d2ad89a58230dfe7bed705d6"
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
