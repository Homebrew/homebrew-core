class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.32/yelp-tools-3.32.0.tar.xz"
  sha256 "bfdd40d10d837d1a170c7fe70b3436d30e6698db809d5be459ea0f7fbb69ee0c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4f47c6d9828e28b9135d7b99c7d5ecab1dd44b247a05e849abd1c02edbdfa38f" => :mojave
    sha256 "1ccfac8c04c1049d1f03c538bc43a525874c8db74298e8c67025dab2910015c8" => :high_sierra
    sha256 "e3aa9c7a280f00c63e91c385807155b3c50ac7a6877db4d2420fd35b3acfcd8c" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
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
