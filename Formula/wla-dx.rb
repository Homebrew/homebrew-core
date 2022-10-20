class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v10.3.tar.gz"
  sha256 "e07d157746f43ceba97c1706c4fc86db2e7e0345e94cd2e3eadd7cf8c6d2f8a7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)(?:-fix)*["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9cfd12fe7a6235a880b05a72458a294029b84b6b5d6ff75f900ee8eff058fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a9bf5846a782156e6bc56288943a75cfc720298f202a74d84e3559d76bfb65c"
    sha256 cellar: :any_skip_relocation, monterey:       "2a4df07050385b6531f279147d6932795789f926e749272a4e5936baffbf2a18"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed6b08b3ded0c5a6bfe641d859a76d155fffb29d2c4c7af323ba85361b67cdce"
    sha256 cellar: :any_skip_relocation, catalina:       "29622f09c7ffb595b98f5ff093bbd54723e07c1de84b69b1c84a67c9b54a576b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e9ff33f0ea416231ddfb5d01e2ac8387a075570fa8cd3fcfe68614e581c289"
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
