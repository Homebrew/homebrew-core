class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.6/ttfautohint-1.6.tar.gz"
  sha256 "e41013f710c306538ff5b2f1b4d9a5b24bda031fb73fabcaf02a21b8edd71be5"

  bottle do
    cellar :any
    sha256 "197bdbe7aa06aed36b16589e200c02ecc774f36881920e65befa3f50fa6b5276" => :sierra
    sha256 "97e64ed4c50b3caf57446c2040f65e0b4055eb38f741e4e9bf56d61babda7054" => :el_capitan
    sha256 "e0ac2b0caba3aef14d7a1feb119559daebfe74fa7b49b6f2cf249d0f878beca5" => :yosemite
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
