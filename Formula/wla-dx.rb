class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v10.4.tar.gz"
  sha256 "421af537097f4afef4b1b2357a28072dba392597d97572ad751250b98d7ea62d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)(?:-fix)*["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be3cdd93a0f78c02acc8ac279afa23a0d075b7d4139f86838333dfbccc21395b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a7e583aa16af9fa4a98ea1f655b8f5572ca24822919f0ac591cbbf9c1e08c10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fd6821a07e38ef4ccb90410bbcddb3344f4fd8c6641bd0eeda7f749c33de69b"
    sha256 cellar: :any_skip_relocation, ventura:        "6dda1329ee7ac4d58cc260c972c1cce92d3f4fa0b649bec13e30c229510fc2c6"
    sha256 cellar: :any_skip_relocation, monterey:       "68c89844890eba4f05779678572e095e02e6747f1189c5906918f2c0975070f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "52e9230b232698ef8cf0737848b62cdc7b76da8c4d675e427e1d6dd91e0a25c9"
    sha256 cellar: :any_skip_relocation, catalina:       "3ef932aee92aaeaf5655ee785ab28a926b0b276b8aefab293d5c11248bb7d84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908498831e2ce6f1ecf36bb83122ee986f479440fe760d1470f2dc574fdee3be"
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
