class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.53.1515-src.zip"
  sha256 "f18e5d3f7f27231c1f8ce781eee8b585fe5aaec186eccdbdb820c1b8c323eb6c"

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
