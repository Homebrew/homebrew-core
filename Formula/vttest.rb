class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20200303.tgz"
  sha256 "49aa5828f8827f22fdae8c49cbc4fc78e9abb46d7670167985a7c079c6f547bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9d893afeefe1997a5419152ce4182bf68f70cdfbc55c3dad5d9b473a06ba906" => :catalina
    sha256 "237cb61899805abac4a990f714150afa74f4f5a5e7c0d28fd5f01442c275b699" => :mojave
    sha256 "2c5cc23ef56bcdd29f6168d0759065e4a1eb9738cd263d1bc83500e08c703efa" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
