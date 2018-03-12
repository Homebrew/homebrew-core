class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.28/yelp-tools-3.28.0.tar.xz"
  sha256 "82dbfeea2359dfef8ee92c7580c7f03768d12f9bf67d839f03a5e9b0686dc1ac"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "362bd3f0673ad7e44f9d37b37f46989512823d218d06aa27e452c47faf589b41" => :high_sierra
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
    url "https://download.gnome.org/sources/yelp-xsl/3.28/yelp-xsl-3.28.0.tar.xz"
    sha256 "8ccdf47b31acbdd26a7380b3bc6700742a7aff91a54dab279fd5ea8b43b53f93"
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
  end
end
