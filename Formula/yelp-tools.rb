class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.32/yelp-tools-3.32.2.tar.xz"
  sha256 "183856b5ed0b0bb2c05dd1204af023946ed436943e35e789afb0295e5e71e8f9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "90d2555a7d0084b4cfa6bdb0ab3ef919133a6ba79f0de468b4890dfb884ce677" => :catalina
    sha256 "eaa2cd04e93ccbb9a549f0c54592e4937e51fc074e78673bd5d82a71d826234b" => :mojave
    sha256 "eaa2cd04e93ccbb9a549f0c54592e4937e51fc074e78673bd5d82a71d826234b" => :high_sierra
    sha256 "4ca84a03cda695aa70e06c160c65c1961eaef0315b6ff8e42747df421703f6b1" => :sierra
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
