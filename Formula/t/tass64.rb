class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.59.3120-src.zip"
  sha256 "a89a7b79ad234c6ea51a1c9d6c472d0f3827d01b2501b3f30cd0af9541423eef"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "LGPL-2.1-only", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "486369e3e99fbd90b74d4db304c6a817af75affb2bb4f2dceae3fc72a0e942e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9ab17c0cf37a48c51e51973648c4bf753512e1eccaa58c384d1d9329466977f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48e41ebee6b426610d59bfd3e89e2eb8204cfeabe63c7eb6375c04ac5388e6a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e91e45d0c55cd2072eb2889604bcfd11ec41fb10671f496ae156bc3c4904f67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec1bcc71132e8154a294e50addb333794d81ad7eec1cab561528a03d9a9c5ae0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6ee486f80e6f446267b23f318762f652420854e45449a120bcf936bf737a71e"
    sha256 cellar: :any_skip_relocation, ventura:        "b07344cbe03d5b5915e20ac2cde5c9b616f798e5b3589af1bbbad1cb41a6c414"
    sha256 cellar: :any_skip_relocation, monterey:       "ec7db292d9285cced213210e4f158879caaf401589ecdf8c5f194f936ae2578c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa71a39e484f20215d6e016a3a1347d88680e342d808b25acc66fd940ff1b0e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68e1053e5cf4f9509b8de27497354e8640573e12a31fa265c048272e9aa539a0"
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

    system bin/"64tass", "-a", "hello.asm", "-o", "hello.prg"
    assert_predicate testpath/"hello.prg", :exist?
  end
end
