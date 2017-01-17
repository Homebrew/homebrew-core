class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation."
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.18/yelp-tools-3.18.0.tar.xz"
  sha256 "c6c1d65f802397267cdc47aafd5398c4b60766e0a7ad2190426af6c0d0716932"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "b0ea184a43def810986761f163243688d08e1f891ddfdb104793b5dcb7c9155c" => :sierra
    sha256 "b0ea184a43def810986761f163243688d08e1f891ddfdb104793b5dcb7c9155c" => :el_capitan
    sha256 "b0ea184a43def810986761f163243688d08e1f891ddfdb104793b5dcb7c9155c" => :yosemite
  end

  depends_on "gettext" => :build
  depends_on "gtk+3"
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.20/yelp-xsl-3.20.1.tar.xz"
    sha256 "dc61849e5dca473573d32e28c6c4e3cf9c1b6afe241f8c26e29539c415f97ba0"
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
    [
      prefix/"share/yelp-xsl/icons/hicolor/24x24/status/yelp-note-warning.png",
      prefix/"share/yelp-xsl/js/jquery.syntax.brush.smalltalk.js",
      prefix/"share/yelp-xsl/xslt/mallard/html/mal2html-links.xsl",
      share/"pkgconfig/yelp-xsl.pc",
    ].each do |filename|
      assert filename.exist?, "#{filename} doesn't exist"
    end
  end
end
