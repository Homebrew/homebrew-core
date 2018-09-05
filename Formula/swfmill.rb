class Swfmill < Formula
  desc "xml2swf and swf2xml processor"
  homepage "https://swfmill.org"
  url "https://www.swfmill.org/releases/swfmill-0.3.6.tar.gz"
  sha256 "db24f63963957faec02bb14b8b61cdaf7096774f8cfdeb9d3573e2e19231548e"

  bottle do
    cellar :any
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
