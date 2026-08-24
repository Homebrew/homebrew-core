class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/refs/tags/v10.7.tar.gz"
  sha256 "38296a96bc20be873d17e0e88be0c5b20a15ef2ec4da5279600e56af30ad925a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)(?:-fix)*/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14835aed5364771805901495fdeca30f6f7c9f56835dbadea59173639a949abd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda35cea50a7e7f1149d1ef1e38ea8a5b97992bb06a6dff615e47c0440366373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe78c5b54142ff1711ec529839332910b15036262b5602b4190afec9e785aa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc58862171d224ff6f482a2e966c9ca83d7d71ee58c14babbdaaca8aa0867642"
    sha256 cellar: :any,                 arm64_linux:   "9e90004ff3e66541a4bf3545900877008cb582bf7a9df7707bdf31e810cca33b"
    sha256 cellar: :any,                 x86_64_linux:  "61f7c89346e1f7b70980388e89fea7babf8c53aa78af5012e876090d2ce193f4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test-gb-asm.s").write <<~ASM
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
    ASM

    system bin/"wla-gb", "-o", testpath/"test-gb-asm.s"
  end
end
