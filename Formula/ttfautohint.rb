class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.2/ttfautohint-1.8.2.tar.gz"
  sha256 "386741701596a8b2d5fb744901922ed2bd740490f7e6c81e5d7e83ac677889a7"

  bottle do
    cellar :any
    sha256 "7f2882b40456aa63032c9cc0cc605867fe1b57b483f67ee755aa2be6a93908ea" => :high_sierra
    sha256 "538f6817293c6f4db3068aec0b946e27af6b2a74a8bae8e738d0f7ece568ed6f" => :sierra
    sha256 "2123fde31eaeb430de611383e8107862f135e3feeaba5b2e2e2c99fd0292e61c" => :el_capitan
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
