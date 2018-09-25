class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.28/yelp-tools-3.28.0.tar.xz"
  sha256 "82dbfeea2359dfef8ee92c7580c7f03768d12f9bf67d839f03a5e9b0686dc1ac"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "18bd2e5756ffa915d495b9ea9b1e9b27d1aac708a4cbc806a85a8347e0db3a42" => :mojave
    sha256 "ba38994c3d0955d097a9b2ca2b374908caf672ef6bb1443467b7b74800bb9d3e" => :high_sierra
    sha256 "ba38994c3d0955d097a9b2ca2b374908caf672ef6bb1443467b7b74800bb9d3e" => :sierra
    sha256 "ba38994c3d0955d097a9b2ca2b374908caf672ef6bb1443467b7b74800bb9d3e" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.30/yelp-xsl-3.30.1.tar.xz"
    sha256 "fcef31c5938c6654976bbabb8b5d0d9e49fa2ce79136db74ca213056fdb8cf39"
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
