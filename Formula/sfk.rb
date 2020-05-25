class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.7.0/sfk-1.9.7.tar.gz"
  version "1.9.7.0"
  sha256 "67009fd73d53c800302de58067dee2ceb64c5a43c10d32de30ab886efdd59399"

  bottle do
    cellar :any_skip_relocation
    sha256 "97a2cef96b012dfb2ea0bfd2857d511b247e97ec6f896039b4346c8193f2fc8c" => :catalina
    sha256 "6e7b7ab770ba172a975ae850bb30a39b906d572c1faa76759d4008448db50bc9" => :mojave
    sha256 "e71d19592ef095cc5bcf742c5f195d1266dc3ba2cd57a028aa2a7f03345b3ea0" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
