class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.54.1900-src.zip"
  sha256 "5bf28dfcc7631a20a3ed7e308a50fe219d8a6417ad59d1d1162836ec3a1506ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c519f6bca815c5ef0726a59b7c6bef323a3ab9c62af8339e52bec41784d402f" => :catalina
    sha256 "a50a7694850bb4da92edf5aa79e509935ae16951f1e362c31ffe22f2c15e9858" => :mojave
    sha256 "db03b63e4f453c52de9b9b22c9596e8f3b45b71c1fcab8a039a71def6186906f" => :high_sierra
    sha256 "ec0c831022ccc4446820bc73076dbb3c1f17c80cdcb3af8c21a62b801f27561b" => :sierra
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
