class YelpXsl < Formula
  desc "Yelp's universal stylesheets for Mallard and DocBook"
  homepage "https://github.com/GNOME/yelp-xsl"
  url "https://download.gnome.org/sources/yelp-xsl/3.20/yelp-xsl-3.20.1.tar.xz"
  sha256 "dc61849e5dca473573d32e28c6c4e3cf9c1b6afe241f8c26e29539c415f97ba0"

  bottle do
    cellar :any_skip_relocation
    sha256 "efe44d4aff341789627222362d37ead81012b8326a371da7f11a1b038495e883" => :sierra
    sha256 "aeb96fe4c29ceebad023ef93a537d112eb4c49fc0de581e96a74d158350b201c" => :el_capitan
    sha256 "c19c5c3c3476d24c33e234b93df7532f2f9b15a8d213750463716edc087cd7a6" => :yosemite
    sha256 "641d4b336701a5e82cfea2c349b14d012e1f2579b42b2f7a3cd1c72d18aac364" => :mavericks
  end

  depends_on "itstool" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "libxslt"
  depends_on "libxml2"
  depends_on "gtk+3" => :run

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert (pkgshare/"xslt/mallard/html/mal2html-links.xsl").exist?
    assert (pkgshare/"js/jquery.syntax.brush.smalltalk.js").exist?
    assert (pkgshare/"icons/hicolor/24x24/status/yelp-note-warning.png").exist?
    assert (share/"pkgconfig/yelp-xsl.pc").exist?
  end
end
