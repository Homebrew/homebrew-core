class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.32/yelp-tools-3.32.0.tar.xz"
  sha256 "bfdd40d10d837d1a170c7fe70b3436d30e6698db809d5be459ea0f7fbb69ee0c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3f99713403a1529bad9dde8936073d9a28c42a5b1e37d0cd4bf11d5c28257c0" => :mojave
    sha256 "10a1f9d0412ea9371a10fe0d8a792e57c345a7ec732c6b6662469ddd57325fc1" => :high_sierra
    sha256 "10a1f9d0412ea9371a10fe0d8a792e57c345a7ec732c6b6662469ddd57325fc1" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.32/yelp-xsl-3.32.0.tar.xz"
    sha256 "9b196f713a88578375889ca1620dc5b2b5d2a40e31f1320942d423d5a588ba66"
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
