class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.57.2900-src.zip"
  sha256 "e4f0dcb1b00d5206ccb391eb5b8b43f4d95f064d63af739a71f5c822bbfc56a4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "LGPL-2.1-only", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29936927064468f75aebd39e957f53c2aadf47369ae10a191612a2a326ac4bdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81dffbc4d2dea6237c3392b97a6834bbd584827bf6fc16066a8cee8ab15862ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01af2b2679d30efd3a934617ed618432fba9d307386b38fc3c299233132f03c1"
    sha256 cellar: :any_skip_relocation, ventura:        "c906770fb3e1465f449359bb19c946f4be23b1e67fa3ed0123f633d749c9b9c4"
    sha256 cellar: :any_skip_relocation, monterey:       "804fe305806f3d3db3db8bacbe64482c98c99696b91bdd80eb4b476ade9ffb68"
    sha256 cellar: :any_skip_relocation, big_sur:        "39cf8c55e040f0d21534f08db3107e61ca519006c7ddbfe2137655e113998afe"
    sha256 cellar: :any_skip_relocation, catalina:       "65e1411ca3dbecc6885d71edf2c68c49b0180bc1b39a7373539150bf0469db22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ff210040282ac6888c25cf193e72f399fb32e514cca8d1701a269c386a2270"
  end

  def install
    system "make", "install", "CPPFLAGS=-D_XOPEN_SOURCE", "prefix=#{prefix}"

    # `make install` does not install syntax highlighting definitions
    pkgshare.install "syntax"
  end

  test do
    (testpath/"hello.asm").write <<~'EOS'
      ;; Simple "Hello World" program for C64
      *=$c000
        LDY #$00
      L0
        LDA L1,Y
        CMP #0
        BEQ L2
        JSR $FFD2
        INY
        JMP L0
      L1
        .text "HELLO WORLD",0
      L2
        RTS
    EOS

    system "#{bin}/64tass", "-a", "hello.asm", "-o", "hello.prg"
    assert_predicate testpath/"hello.prg", :exist?
  end
end
