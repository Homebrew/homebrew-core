class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.32/yelp-tools-3.32.2.tar.xz"
  sha256 "183856b5ed0b0bb2c05dd1204af023946ed436943e35e789afb0295e5e71e8f9"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fd04fbc43832ca6a6e75ffcd928794c866153c7cf04d4f366e79d15a14a317b6" => :catalina
    sha256 "fd04fbc43832ca6a6e75ffcd928794c866153c7cf04d4f366e79d15a14a317b6" => :mojave
    sha256 "fd04fbc43832ca6a6e75ffcd928794c866153c7cf04d4f366e79d15a14a317b6" => :high_sierra
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
    url "https://download.gnome.org/sources/yelp-xsl/3.34/yelp-xsl-3.34.2.tar.xz"
    sha256 "0c3fe6146113df26fb1295901b1c7baed9f0fe67a87f4345e11543aefe7cb7ad"
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
