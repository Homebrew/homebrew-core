class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint/"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.3/ttfautohint-1.8.3.tar.gz"
  sha256 "87bb4932571ad57536a7cc20b31fd15bc68cb5429977eb43d903fa61617cf87e"

  bottle do
    cellar :any
    sha256 "5a56efdcfabb79895db80fd244c6578f5042e1aa30196a48fa51e530a9586899" => :mojave
    sha256 "d44712b0e6a341fad7a535ab42f9f131994528352ce98bd838697110d7cfd67a" => :high_sierra
    sha256 "754ef442537be790bc6e1fea4723cf007ba5a9bb78a56e5933c9c7026ff38fec" => :sierra
    sha256 "f94c3bd7520d4af65b157c124957e3fbe765c55e2b316c45d761f4e441c3a273" => :el_capitan
  end

  head do
    url "https://repo.or.cz/ttfautohint.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-doc",
                          "--without-qt"
    system "make", "install"
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system "#{bin}/ttfautohint", "Arial.ttf", "output.ttf"
    assert_predicate testpath/"output.ttf", :exist?
  end
end
