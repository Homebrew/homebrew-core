class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.13.tar.gz"
  sha256 "a9477af150b6c8a91cd3d41e1cf8c9df552d383326495576830271ca4467bd86"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href\s*?=.*?xa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "687e89ab608aeccce2daaf92b1d3310d4972a3b7119d5b532fc43675b42bf70a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51bb4da669873d151714aced3994391e2c1442bdf8d2f6288a273cc9d6dde3d4"
    sha256 cellar: :any_skip_relocation, monterey:       "9f92a04dc6f464f62ab5656f06b24493ecea8eb24aed541bc8c26597c8fbf5a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6833bbb16557cdfdb1356a5b0fb848b017250a1730e67b2b52530373ced44f8"
    sha256 cellar: :any_skip_relocation, catalina:       "78e256701c504ea351845e31ae035445e4fd318344aa413882b3e40f5103db75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82ed28676962237aeb258d348db80f60559f56d11aa52609f2c0a9445e3419c4"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end
