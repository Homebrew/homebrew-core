class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.38/yelp-tools-3.38.0.tar.xz"
  sha256 "607ce4b3ee8517c42db924a01a78660a03317595c75825731ea86a920e2b04b0"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9ecac26d055284b58e3b6220a719d20e3e0e5d4fd6c091bb649945b76df6ca69" => :big_sur
    sha256 "287755e74068f82a9dd94e60e6ae8fc0a3d38f04c2df3ee44d8f427d403d89bc" => :arm64_big_sur
    sha256 "c4dde1e77132df114dfd4b19faeae2b8604a3557ac97a0f2caf47954fcfc0def" => :catalina
    sha256 "4eec970808d0b15187fc1bfb976999b52ae0f13b6ae004f7ca9d65d15e6b07a8" => :mojave
    sha256 "906e221bce54f03db236aee3738c047e3d836a4f124aa3460b9d224a9d0c547b" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.38/yelp-xsl-3.38.1.tar.xz"
    sha256 "b321563da6ab7fa8b989adaf1a91262059696316b4ddca2288fddcfed8dcdf67"
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
