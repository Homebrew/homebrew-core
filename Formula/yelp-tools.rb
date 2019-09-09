class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.32/yelp-tools-3.32.2.tar.xz"
  sha256 "183856b5ed0b0bb2c05dd1204af023946ed436943e35e789afb0295e5e71e8f9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "11a07c006a88df5efa908f28109dbc2efb809e82a8f1c3c65ab1811ff57a3132" => :mojave
    sha256 "11a07c006a88df5efa908f28109dbc2efb809e82a8f1c3c65ab1811ff57a3132" => :high_sierra
    sha256 "fafe15c9c7a41f4115d0f56646e173944f54f07b8baf01bb4b9a1eb06337749b" => :sierra
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
    url "https://download.gnome.org/sources/yelp-xsl/3.34/yelp-xsl-3.34.0.tar.xz"
    sha256 "e8063aee67d1df634f3d062f1c28130b2dabb3c0c66396b1af90388f34e14ee2"
  end

  def install
    resource("yelp-xsl").stage do
      system "autoreconf", "-fi"
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
