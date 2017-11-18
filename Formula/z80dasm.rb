class Z80dasm < Formula
  desc "Disassembler for the Zilog Z80 microprocessor and compatibles"
  homepage "https://www.tablix.org/~avian/blog/articles/z80dasm/"
  url "https://www.tablix.org/~avian/z80dasm/z80dasm-1.1.5.tar.gz"
  sha256 "91ecbfa43e5a9c15665560668fb1a9e3f0455f28a6f7478450bd61ff56d6b96e"

  bottle do
    cellar :any_skip_relocation
    sha256 "df2612812e22db187eb9fcb2a4cb1fd918e20a991bc478fae18493e9e7eb142d" => :high_sierra
    sha256 "de8792d3309324500758a7c173091573835308e0b4715b0e1ea48dd7a9c7c135" => :sierra
    sha256 "0309ecd2137730b8e756f3f3cdb364a16df1a03aa454684922706b0c6d705567" => :el_capitan
    sha256 "3219de661b1355cd130687c0f547bacf030dd1b2e499c5817b20bc5dbd8f1b54" => :yosemite
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
