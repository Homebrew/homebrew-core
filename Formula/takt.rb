class Takt < Formula
  desc "text-based music programming language"
  homepage "http://takt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/takt/takt-0.310-src.tar.gz"
  sha256 "eb2947eb49ef84b6b3644f9cf6f1ea204283016c4abcd1f7c57b24b896cc638f"
  revision 1

  bottle do
    sha256 "52bf9d849eeaced86b6dd6986f702c81a947e1bb0a7a8d0f4bef71340a7c4595" => :sierra
    sha256 "385063726c0a6a5a962ea3312c7172c37c2ef71f6a84cc662a0c18341285068f" => :el_capitan
    sha256 "adaf06a7467e3ccf50f36c427bf436c2e3352dec2b83934f1e2031bdff798d70" => :yosemite
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
