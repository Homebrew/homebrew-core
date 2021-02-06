class Takt < Formula
  desc "Text-based music programming language"
  homepage "https://takt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/takt/takt-0.310-src.tar.gz"
  sha256 "eb2947eb49ef84b6b3644f9cf6f1ea204283016c4abcd1f7c57b24b896cc638f"
  revision 2

  bottle do
    sha256 arm64_big_sur: "910a1325ce07065c113c1efd53e8295a10b8db613ef6fa1e5bfda1abc8fa922d"
    sha256 big_sur:       "fd9dec43c0d9d5634d3bf23f8c6112090429d279243c5c0acd4dbfff8025fdbc"
    sha256 catalina:      "b5f6d5891f4955b26be88358c37199d9f9b1ebd66eaaa519ccbcfddbfa615780"
    sha256 mojave:        "c45509b2d6828c514a0397f9c57284f7c4efcca766deddc762ef69cac715d3df"
    sha256 high_sierra:   "d90177e40185259de89cc259c5cfde419f65161c52571dfeccb18fe52ffeab8f"
    sha256 sierra:        "d0fd3808c9d7266cd16de123c0f8cc434d594b63b6e2d7d67425f155f1c9d582"
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
