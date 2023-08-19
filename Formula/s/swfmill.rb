class Swfmill < Formula
  desc "Processor of xml2swf and swf2xml"
  homepage "https://www.swfmill.org/"
  url "https://www.swfmill.org/releases/swfmill-0.3.6.tar.gz"
  sha256 "db24f63963957faec02bb14b8b61cdaf7096774f8cfdeb9d3573e2e19231548e"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?swfmill[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0963f879f2401a1174f2d1536a1dbbec0cfea0ca85978943f5f00e9d98c7b62e"
    sha256 cellar: :any,                 arm64_monterey: "dde3958952f7a8f233e56a4a623f133ba07fd8f5fb06d5832d013f4e0ef59ffe"
    sha256 cellar: :any,                 arm64_big_sur:  "be6e61f096ab129607f537e0bc37fd87214f01cfbfa097ab4bfb348614ffa83c"
    sha256 cellar: :any,                 ventura:        "68a4a9c1038067e60dffeaac7b18e40ab2c623cb8dda217b7f91a9a06436b3c3"
    sha256 cellar: :any,                 monterey:       "1409bea1e846cda18e4206dc39027d195acb9fe0cae14f9a49842b945ba4befc"
    sha256 cellar: :any,                 big_sur:        "61d884a0d8fda68458267311da138851688cf5574f3d17152f7227c120653115"
    sha256 cellar: :any,                 catalina:       "be2f7f3666c78c37775bd41e2adb640f290bb3e73d8a0b4b04bae0f08e140fac"
    sha256 cellar: :any,                 mojave:         "4eb93babe47a07ccb946b87a7e5515eef651b376c590231920a5acdcc6023aea"
    sha256 cellar: :any,                 high_sierra:    "2516e0ca300458f626e1311673643e1cad03131fb77717fb4f6d10e5f7c6e522"
    sha256 cellar: :any,                 sierra:         "f8f7530eb3697993d145bd67fcb44122319f3dadbd5a15535ae23ce33c1991fc"
    sha256 cellar: :any,                 el_capitan:     "10165ef551225423c4d0b98b734aa112854bb836b6dcca675a0d2dd2adcee75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e86fcc5ea5d803ac5f8f4bfe33090c4ceec8369bd8c026db34fdfd1b6aa997b"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"

  uses_from_macos "libxslt"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
