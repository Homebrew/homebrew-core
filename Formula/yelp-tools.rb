class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.32/yelp-tools-3.32.1.tar.xz"
  sha256 "99a7c312a5fcb427870dc198af02801eb0f8ea63317e20110fc0303eb44636e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ac8c83a70c72d104f3b6ce093ccd989dacaa1ab4de9b895adeebdffa50b6663" => :mojave
    sha256 "2ac8c83a70c72d104f3b6ce093ccd989dacaa1ab4de9b895adeebdffa50b6663" => :high_sierra
    sha256 "2c11165b029ef8e8aa56ff802ccbf8d6cc1409187b42bee33a4e972bd60094f0" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libtool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.32/yelp-xsl-3.32.1.tar.xz"
    sha256 "cac31bc150545d6aa0de15dce04560cbf591008d17a783a1d1d9cdd47b147f04"
  end

  def install
    resource("yelp-xsl").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{share}/pkgconfig"
    end

    system "autoreconf", "-fi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache",
           "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/yelp-new", "task", "ducksinarow"
    system "#{bin}/yelp-build", "html", "ducksinarow.page"
    system "#{bin}/yelp-check", "validate", "ducksinarow.page"
  end
end
