class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.1.3/sfk-1.9.1.tar.gz"
  version "1.9.1.3"
  sha256 "d60626cbcc3d0aa76126d1a0c3a59ba504fdfbc4b1c4b77e80f1870cc6b2e1d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d0476dadc5528c725772800a2569c03f03857fda36ac4f8d2f82e9b48e3764e" => :high_sierra
    sha256 "3e59160ec9d6d6fadff784ceb28cc330799e8495d33639bde31889ec5defba97" => :sierra
    sha256 "89720ff487ac0d29dbeb29bfe69315775f5c350a5c1fee2f8adb03b8ad419db6" => :el_capitan
  end

  def install
    ENV.libstdcxx

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
