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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd0d8e647041706963447aa6b70fd385bde5b13b29ce925207959b3e09d52ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbc3401b65ebeca507ecb491cc05b420c596085ddab9963acf1ae2e0e8db8abd"
    sha256 cellar: :any_skip_relocation, monterey:       "e6a585c2eb86f50a02ee9400e7b82a9b37ee239d1d4407290e8e3754b3a8979a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a6066360b0528114e08d32d351aed73d2174942c113e0df2afcb72f2de3d1b7"
    sha256 cellar: :any_skip_relocation, catalina:       "8376b0ac8abbc1d064aea081c5075f6efac6a7495d66c014fcc10b972a5a53e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79f4a7da2db6adb1277e2d4d9c7566694a26e0000a76de8264eb8b93fc09dbf2"
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
