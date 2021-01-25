class Swfmill < Formula
  desc "Processor of xml2swf and swf2xml"
  homepage "https://swfmill.org"
  url "https://www.swfmill.org/releases/swfmill-0.3.6.tar.gz"
  sha256 "db24f63963957faec02bb14b8b61cdaf7096774f8cfdeb9d3573e2e19231548e"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "61d884a0d8fda68458267311da138851688cf5574f3d17152f7227c120653115" => :big_sur
    sha256 "be6e61f096ab129607f537e0bc37fd87214f01cfbfa097ab4bfb348614ffa83c" => :arm64_big_sur
    sha256 "be2f7f3666c78c37775bd41e2adb640f290bb3e73d8a0b4b04bae0f08e140fac" => :catalina
    sha256 "4eb93babe47a07ccb946b87a7e5515eef651b376c590231920a5acdcc6023aea" => :mojave
    sha256 "2516e0ca300458f626e1311673643e1cad03131fb77717fb4f6d10e5f7c6e522" => :high_sierra
    sha256 "f8f7530eb3697993d145bd67fcb44122319f3dadbd5a15535ae23ce33c1991fc" => :sierra
    sha256 "10165ef551225423c4d0b98b734aa112854bb836b6dcca675a0d2dd2adcee75a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
