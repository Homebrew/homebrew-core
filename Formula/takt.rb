class Takt < Formula
  desc "text-based music programming language"
  homepage "http://takt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/takt/takt-0.310-src.tar.gz"
  sha256 "eb2947eb49ef84b6b3644f9cf6f1ea204283016c4abcd1f7c57b24b896cc638f"
  revision 1

  bottle do
    sha256 "d69f489e47d47dba63edc7defeb8829272093e47fea263ba54054f21557131e4" => :sierra
    sha256 "7862cdfe9f54eba4d4263558669d852a6a87d01be3d1f5ad56439e5bfc893b64" => :el_capitan
    sha256 "46f0c0e3b50840d54601615db699ff0e77a3a891e3928a013939f94ecf66b78b" => :yosemite
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
