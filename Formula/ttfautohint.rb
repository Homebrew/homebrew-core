class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.6/ttfautohint-1.6.tar.gz"
  sha256 "e41013f710c306538ff5b2f1b4d9a5b24bda031fb73fabcaf02a21b8edd71be5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9acbfeffd3e0b978dc9d6905398035155fff3012b17741b5d822afd06ad80318" => :sierra
    sha256 "10fd60dde2cae31a861ce8dab53e49cab7237f93a7c1646d751d6bed9b7fa9f2" => :el_capitan
    sha256 "2252e5b636d885d613a3cc4ee831777218124039132c5a3ba4ea1c3b96778f18" => :yosemite
  end

  head do
    url "http://repo.or.cz/ttfautohint.git"
    depends_on "bison" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-qt", "Build ttfautohintGUI also"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "harfbuzz"
  depends_on "qt" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-doc
    ]

    args << "--without-qt" if build.without? "qt"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    if build.with? "qt"
      system "#{bin}/ttfautohintGUI", "-V"
    else
      system "#{bin}/ttfautohint", "-V"
    end
  end
end
