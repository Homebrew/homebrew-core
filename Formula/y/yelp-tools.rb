class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://gitlab.gnome.org/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sequoia: "19cea9b4aea4306c27cf8670b72009111acd01359e9896850231cc6a4c13ccdb"
    sha256 cellar: :any,                 arm64_sonoma:  "8e94caafb0c2920ce1e46bc4d4499033e1ad366e240c8e9aed59cade7e18feef"
    sha256 cellar: :any,                 arm64_ventura: "f7b601e215e171c88e066bc78dcb06238ecc8fe0c23b38ef97c852546a07a953"
    sha256 cellar: :any,                 sonoma:        "b5a88a52c0e06460d402f94f56eb2afc2faefb1dfc256f01d8ec2bcb03482390"
    sha256 cellar: :any,                 ventura:       "85810d052d35bb12a405a1b6d2411db345980b8fdb848b9cc46215face0631e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f2e4140b9a219e6c08455422ea64ee0dbd07907cf457707f469f778db0083ad"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.13"

  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/42/yelp-xsl-42.0.tar.xz"
    sha256 "29b273cc0bd16efb6e983443803f1e9fdc03511e5c4ff6348fd30a604d4dc846"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resource("lxml")
    ENV.prepend_path "PATH", venv.root/"bin"

    resource("yelp-xsl").stage do
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", share/"pkgconfig"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    system bin/"yelp-new", "task", "ducksinarow"
    system bin/"yelp-build", "html", "ducksinarow.page"
    system bin/"yelp-check", "validate", "ducksinarow.page"
  end
end
