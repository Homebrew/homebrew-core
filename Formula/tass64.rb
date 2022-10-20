class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.56.2625-src.zip"
  sha256 "c4e570c717c9500f3af61a3ad5d536f22415e2b29ed1eb09b1a955d310c9f3d3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "LGPL-2.1-only", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a728bdf4efe32d5cfd7a15d502cd13d65e1ddec15998dd569d6fa94a7f4fd2f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7468a371a0c4627bf592d4e6fe36b9c854def7caa2b7270faa20ff97ca2cc7df"
    sha256 cellar: :any_skip_relocation, monterey:       "878ae43e115b1248160fbc7652f8024705162aa3263660a7e62382e14806b4e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "70f966e5974c671aac1c1209c2273325be29b5d56de851416344d0559c8b8c34"
    sha256 cellar: :any_skip_relocation, catalina:       "e59c0c91030879fbc49cd205a1e5e0e5c0026434d1bff86a9742b4d00139824c"
    sha256 cellar: :any_skip_relocation, mojave:         "a5be46e97063271c7bc9ddadc88e4b318193ee0f0556489593c3db9aed5ef03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5d380c36fde7617c613b0da5854de0f8b73150a3370f0f8b4d281191a67ed60"
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
