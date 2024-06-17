class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://gitlab.gnome.org/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "fbae1e97dd9800a69ea65c94ce2344358543be53546bef33033e15ac820892da"
    sha256 cellar: :any,                 arm64_ventura:  "b9aaee8bdd73c94f40d388b2a71d440cb3af6b94a4232547d73221c342647fdb"
    sha256 cellar: :any,                 arm64_monterey: "fc21e8eaa199474b8995401cb18602da05b93f621aeb04e4275206aa7717eb71"
    sha256 cellar: :any,                 sonoma:         "b8c8fade4e54ceb8404e7752d231f1067e4a158f7ba0111f35cc16faeef2a39e"
    sha256 cellar: :any,                 ventura:        "2dd792141d0defb21675d6033c943fb688f2c7de6a2b8aedd524e34de8b20696"
    sha256 cellar: :any,                 monterey:       "57497f6983883ffcef9a672347ab3a414ea496626448936874681c9d100d8b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673a9997e83219618a3b26a5c80944ab0f4c96417a2cd97242a97710590ee030"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "itstool"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
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
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("lxml")
    ENV.prepend_path "PATH", venv.root/"bin"

    resource("yelp-xsl").stage do
      system "./configure", *std_configure_args, "--disable-silent-rules"
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
