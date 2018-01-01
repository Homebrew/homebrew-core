class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.1/ttfautohint-1.8.1.tar.gz"
  sha256 "12df5120be194d2731e2a3c596892aa218681614c4f924e24279baf69bb7d4f9"

  bottle do
    cellar :any
    sha256 "38656e34a51e8cbd668bec8b87fe79f438259937ca699b36865b93802596c9f6" => :high_sierra
    sha256 "f33224ef2971fca34e8b765ca78b956cc0de3ddcaa2d2fe6c9dc789abe043803" => :sierra
    sha256 "b3fadc4f292ddbfea133a4359a18d349970fc794415b2aeb774b38ccc021b641" => :el_capitan
    sha256 "3c336390fbb0221d491e3d341e666259ed68fce7a8d147ef7b33b6eef0b8a9c2" => :yosemite
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
