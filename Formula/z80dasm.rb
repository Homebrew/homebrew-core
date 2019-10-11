class Z80dasm < Formula
  desc "Disassembler for the Zilog Z80 microprocessor and compatibles"
  homepage "https://www.tablix.org/~avian/blog/articles/z80dasm/"
  url "https://www.tablix.org/~avian/z80dasm/z80dasm-1.1.5.tar.gz"
  sha256 "91ecbfa43e5a9c15665560668fb1a9e3f0455f28a6f7478450bd61ff56d6b96e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f743b105a40263316f44b6d0437ea71c1ac35d8e2d5887090b9b1c4b8ca45e15" => :catalina
    sha256 "5342a99e093cf751afa8a79420999b21e5c63440a77acf7b485cbab2b4ab567c" => :mojave
    sha256 "aa3f2ab337305b4dcbb37e868fcc537e04cac5fd4a2af7c8548347965f26a226" => :high_sierra
    sha256 "527e7f1cd02531e634745086a7b74eafa57fa8e1f676c3ad60d552f0d6d9ef20" => :sierra
    sha256 "35be0cbdb1c9abc7277c740d7da130bb8b8f7bc50f744ae8a8ea3965a228b9ed" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"a.bin"
    path.binwrite [0xcd, 0x34, 0x12].pack("c*")
    assert_match /call 01234h/, shell_output("#{bin}/z80dasm #{path}")
  end
end
