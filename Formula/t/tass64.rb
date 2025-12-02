class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.60.3243-src.zip"
  sha256 "9d83be3d23a2c55e085b7c7a7856c2f96080447ea120a6a8c21a217ed76427f0"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "LGPL-2.1-only", "MIT"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03b1af6642d7196b136bc4b001706670f3c390c8b20c241b257a2d3b06f750be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d23f98e527d005deb40dd737df7e79ddcaa192953a55effa2fbaa9907b0ce9cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ba4c9a64c5b1d8aaba7e1c56d886471187bfb5a7bc07a96f1b07c6959a6489"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bf1f29a383055486a8cdd26b701e4a82b05a948a9416d1547fee27ff1b42377"
    sha256 cellar: :any_skip_relocation, sonoma:        "507d0e2c74ee13cfdb580822c62d9cd5954b817bb5900e337ea64607c5e1dab1"
    sha256 cellar: :any_skip_relocation, ventura:       "1a174fd0558e49d58a058ba6359b261bce98721d85d0cac0e212196151cb1f31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc863e3da3c692f65b8aaa4e941d6b65c70192b2b7f065b2bc4df9011ae69e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78bccbf88389de622f3d3aaee67eb4c065904c84aa87bc74b62a8ae17aa53012"
  end

  def install
    system "make", "install", "CPPFLAGS=-D_XOPEN_SOURCE", "prefix=#{prefix}"

    # `make install` does not install syntax highlighting definitions
    pkgshare.install "syntax"
  end

  test do
    (testpath/"hello.asm").write <<~'ASM'
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
    ASM

    system bin/"64tass", "-a", "hello.asm", "-o", "hello.prg"
    assert_path_exists testpath/"hello.prg"
  end
end
