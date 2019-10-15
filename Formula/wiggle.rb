class Wiggle < Formula
  desc "Program for applying patches with conflicting changes"
  homepage "https://neil.brown.name/blog/20100324064620"
  url "https://neil.brown.name/wiggle/wiggle-1.1.tar.gz"
  sha256 "3da3cf6a456dd1415d2644e345f9831eb2912c6fa8dfa5d63d9bf49d744abff3"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eeefae127f3a53c099d279ee815ae491537cae9067bd652cf77e251bd22314e" => :catalina
    sha256 "df5814acd5dac0b0acaa7b6f19234c44187f3d3026f31bf1785c54bf0471d4d1" => :mojave
    sha256 "e9b7905c9b7cf53030b67255642b58bdf671702783278409a7c6059eb88ed9b5" => :high_sierra
    sha256 "38ae96a5c3bb1ce68376f8e17ddf915fc7d667bbbd973db54a385085946da16b" => :sierra
    sha256 "f2b73f0db1e85e3ac79e06eb6407fd1fcd63ca6dbf34b707db78207bcfc59e7a" => :el_capitan
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end

  test do
    system "#{bin}/wiggle", "--version"
  end
end
