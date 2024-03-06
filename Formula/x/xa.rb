class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.4.1.tar.gz"
  sha256 "63c12a6a32a8e364f34f049d8b2477f4656021418f08b8d6b462be0ed3be3ac3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href\s*?=.*?xa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3676a4ef6ea7df3826dd5b38050f0da10a026fff52e66f715ffcf180bebc08f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9866e46ff2c3b2b588dec46249bc974b8ee96d09477bfcbc01434630c17a8aa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "017f53d4c1d680c62834d2b06e2d9cbb14f5af3ef75fd99fc6c0949213f223fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "799440d08e0c7fd00f5f35520f63e26953554e0dc18ad9e251e44d75f6b70f83"
    sha256 cellar: :any_skip_relocation, ventura:        "e7dec3ed5103475661dcf521b0f053218e4928a08f8897d6c4697cba83c2dde0"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1e416b5b8a45d5cbb0b8d9058ce20f8294111a76c36de6a995964b01988286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1026432ac3c0b0778e2bac60cee9a8ba3a94f7c2dd80e27906a5e43ef7acee6"
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
