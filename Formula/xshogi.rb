class Xshogi < Formula
  desc "X11 interface for GNU Shogi"
  homepage "https://www.gnu.org/software/gnushogi/"
  url "https://ftpmirror.gnu.org/gnushogi/xshogi-1.4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnushogi/xshogi-1.4.2.tar.gz"

  bottle do
    cellar :any
    sha256 "896d7fd6f2ee9171fdc61017b6ca32ae28b8e0b43d5242dad5a9e7a01de0f5c9" => :yosemite
    sha256 "ef3e719f3c7677d3017fdf771e580316d87db7bee8d260509e49a32666768e4b" => :mavericks
    sha256 "d05d49dc5001f6b2f51070c33e2ebbb30aadc07c461fcff817973d99f1b1fde0" => :mountain_lion
  end

  depends_on :x11
  depends_on "gnu-shogi"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
