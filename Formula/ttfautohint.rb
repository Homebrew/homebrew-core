class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint/"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.3/ttfautohint-1.8.3.tar.gz"
  sha256 "87bb4932571ad57536a7cc20b31fd15bc68cb5429977eb43d903fa61617cf87e"

  bottle do
    cellar :any
    sha256 "542ada8a8e7deaa7fc3f14f2fec704b2570bec6baa07396a37ac7b6d280cfab6" => :catalina
    sha256 "04ca530843887602e80fde17d24f4ed8e19d1248bd71c81c925c161770dbdf56" => :mojave
    sha256 "a6573ae816a7555d62308759c2d64f9fb955ba056d856d904a522996ba0a0c83" => :high_sierra
    sha256 "d45d8d85d3ffa162326ea8e2f63778f4fe583c41bc316c15c5a63b3625beb0ff" => :sierra
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
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    cp "/Library/Fonts/#{font_name}", testpath
    system "#{bin}/ttfautohint", font_name, "output.ttf"
    assert_predicate testpath/"output.ttf", :exist?
  end
end
