class Xshogi < Formula
  desc "X11 interface for GNU Shogi"
  homepage "https://www.gnu.org/software/gnushogi/"
  url "https://ftp.gnu.org/gnu/gnushogi/xshogi-1.4.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnushogi/xshogi-1.4.2.tar.gz"

  bottle do
    cellar :any_skip_relocation
    sha256 "4877493db0e9536a1282b9aa79d3cd38357a4b8e767533cfb6c4dce941faed23" => :sierra
    sha256 "a4bfc78e6d2f10e6bf4c813a2e847963d6dd6d939a522934717ff6d35acafcc9" => :el_capitan
    sha256 "62c11f796225f439e5698ad87abafbfe55d2184d895b86fd13abe3dc924b2030" => :yosemite
  end

  depends_on :x11
  depends_on "gnu-shogi"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
