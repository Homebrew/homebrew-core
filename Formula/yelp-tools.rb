class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation."
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.18/yelp-tools-3.18.0.tar.xz"
  sha256 "c6c1d65f802397267cdc47aafd5398c4b60766e0a7ad2190426af6c0d0716932"

  bottle do
    cellar :any_skip_relocation
    sha256 "351d7f302ede30c4f836c20a055178c73e1a3e7cda7de06dd40392b94d69fc81" => :sierra
    sha256 "8191df226586af990aaf4be1cacc3e3a5b26091c138bd7d3e0e595e1792151dd" => :el_capitan
    sha256 "93dd1e36f80961f722bf2b1ec18b66dab947984858ba3aa084e852dcdafa92bc" => :yosemite
    sha256 "66721baa2d6c6978cceac29f35e8112e96804b6ae0197d89175867f17caca2cd" => :mavericks
  end

  depends_on "gettext" => :build
  depends_on "gtk+3"
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "pkg-config" => :build

  yelp_tools_version = version

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/3.18/yelp-xsl-#{yelp_tools_version}.tar.xz"
    sha256 "893620857b72b3b43ee3b462281240b7ca4d80292f469552827f0597bf60d2b2"
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
