class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.55.2200-src.zip"
  sha256 "067d0a54cb3c473b26aa5d69ea3f1f956be7cccc9044f1117fc20cb84aa63880"

  bottle do
    cellar :any_skip_relocation
    sha256 "afefda676ae81f3340850d132e17fa408505d79da25fd50c42c3042ca3b4f7f2" => :catalina
    sha256 "4a1a224e806b0f9827ffe1f4e5e8ce792e616e6b2e829c278fad5c8a5ee958af" => :mojave
    sha256 "1aa51c3d25cf651f7d4725d89a022ab2510963684dc3b3ebe4845b488b3bb5d7" => :high_sierra
  end

  def install
    system "make", "install", "CPPFLAGS=-D_XOPEN_SOURCE", "prefix=#{prefix}"

    # `make install` does not install syntax highlighting defintions
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
