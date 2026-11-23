class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/refs/tags/v10.8.tar.gz"
  sha256 "61b1b41b2fa2350c811b9aff4b04a2ef087926642d796ec50bf7a6f5f44c7619"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)(?:-fix)*/i)
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "ed66fd59ceefce76863dcc3a160dbeed9d864eeb50538daae3209b65123d44be"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7230f5650cac652adaca7fb136ce59fc971b990d57df21dad0a83ad8f24fca00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4adc4db22f13df61bc519a47b7aa988c79ebc2bafb33b2da5921f0adecc80a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2aba608f95d91e16331e2b435a12f32672e80996fae0f12f298d8db8d69f176d"
    sha256 cellar: :any,                 arm64_linux:       "efb043bba8643d279c1032ca415d53894f0d3e6dcd8228444cc44ffc869d3331"
    sha256 cellar: :any,                 x86_64_linux:      "fef90611aa527277f0454bd1b47ddc8be785f3fd4f0ad6cc33d6178faa39c109"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
