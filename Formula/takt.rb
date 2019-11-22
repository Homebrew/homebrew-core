class Takt < Formula
  desc "Text-based music programming language"
  homepage "https://takt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/takt/takt-0.310-src.tar.gz"
  sha256 "eb2947eb49ef84b6b3644f9cf6f1ea204283016c4abcd1f7c57b24b896cc638f"
  revision 2

  bottle do
    sha256 "b5f6d5891f4955b26be88358c37199d9f9b1ebd66eaaa519ccbcfddbfa615780" => :catalina
    sha256 "c45509b2d6828c514a0397f9c57284f7c4efcca766deddc762ef69cac715d3df" => :mojave
    sha256 "d90177e40185259de89cc259c5cfde419f65161c52571dfeccb18fe52ffeab8f" => :high_sierra
    sha256 "d0fd3808c9d7266cd16de123c0f8cc434d594b63b6e2d7d67425f155f1c9d582" => :sierra
  end

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    system bin/"takt", "-o etude1.mid", pkgshare/"examples/etude1.takt"
  end
end
