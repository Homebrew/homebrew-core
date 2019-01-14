class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.53.1515-src.zip"
  sha256 "f18e5d3f7f27231c1f8ce781eee8b585fe5aaec186eccdbdb820c1b8c323eb6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "662059bcfe282b613ebf0bb9e0e6f0ce4dacd447fdab932ac3b184f45895977c" => :mojave
    sha256 "3726bb4afcd89279e27bcabd10a662b93c7da52732eca84343240913689f6b75" => :high_sierra
    sha256 "43a54d0b972b0173af35552d5e6fc497ae09c9ad181ef3f544aed38e50152633" => :sierra
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
