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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fb014b2c342621cd1b03b8202f632ae9a0690d286fc78fb8dce1556844bbb2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc6dab8458fcfa009b122fc631afc3b90113790bc873c8d7b7f2bbae458fa845"
    sha256 cellar: :any_skip_relocation, monterey:       "0360a63f87c0e768d48dda3649870445a91972e671af9b3a9fdf1694f6518f3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7667b17bbb8ef5cfbe9863aaaff0ab4044569ee1ef8a822a316ba4180762a7f"
    sha256 cellar: :any_skip_relocation, catalina:       "a76d073421afe9f5116e663d310ff86207aacefe4e9192b2bf3c3fb827e1429a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b0a9263e591ffc61b1a0e781c258a3a9446d0003267914769cd4d5c1d02b308"
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
