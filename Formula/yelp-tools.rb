class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.28/yelp-tools-3.28.0.tar.xz"
  sha256 "82dbfeea2359dfef8ee92c7580c7f03768d12f9bf67d839f03a5e9b0686dc1ac"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "802f1d1ab7968c718d16182e2a1926f0cd31fb25f7d1740d4cb872b477236a14" => :mojave
    sha256 "628fc21556d7cade65245e204db567ba929307a91637391a583698d3c281b129" => :high_sierra
    sha256 "628fc21556d7cade65245e204db567ba929307a91637391a583698d3c281b129" => :sierra
    sha256 "628fc21556d7cade65245e204db567ba929307a91637391a583698d3c281b129" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "gtk+3"
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.30/yelp-xsl-3.30.0.tar.xz"
    sha256 "976c4436d2b0189ced004e52af6321bf9d00fe82187df0eb0e81ce732c3806cd"
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
