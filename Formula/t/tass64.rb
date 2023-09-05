class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.58.2974-src.zip"
  sha256 "3f3e2b1867664cb3b64d315fea11938f1666d79d11ea705a6937310257ef0a67"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "LGPL-2.1-only", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9e804611c1a03eb3c563ad9c60cea21498d375e706d96931d3eec2b2d1bfc89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12e08b68f976a919f927579f3e9d7768dd497aa5cd02337cc42dd95586956f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e819ad2bf701f18a362c4343b464f954bc3fac63b8f410bf97fefc12c787dcaa"
    sha256 cellar: :any_skip_relocation, ventura:        "f597f8a0ce9f9cad1506bb1424e3209e66d5549ecb529a39d10cea90120a77b3"
    sha256 cellar: :any_skip_relocation, monterey:       "7cbee14fd0c68c2f9e42fd7f5541f2d83054b893e4d82822f5cc7afaabad3cd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f1372d00208565abf8d92fdb50f8011e8f21b778f214f073118516d54f0028a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e38f72df0f40c5c0d38a2e44ee29b77d07e41f3289bf73439ef6531014979f94"
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
