class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://gitlab.gnome.org/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e7cc6e200f40714f724c9404263bea7fac8c755009bd1c746fe8276030964fc7"
    sha256 cellar: :any,                 arm64_monterey: "affcfae3eb27ae13708420d35449ebe13697fda1beb688ecbfffd3761c7b330b"
    sha256 cellar: :any,                 arm64_big_sur:  "a79aa15319cb78c0fedc81fe45863c59cad4734950943a0ae5bc6461ac6fbcd5"
    sha256 cellar: :any,                 ventura:        "cdcf7bd0cb3ed98cf17066b36ec67556046bc766c529f7a3d8728a9d41ec9710"
    sha256 cellar: :any,                 monterey:       "6745f5e8df7512be08e32ecaa78a9dedcfbaa5be651217c6a943dee9c96bec83"
    sha256 cellar: :any,                 big_sur:        "ec25c2e18a31003a341426372ce29f6e40cbd4fea755d576a6973db900b0e6bb"
    sha256 cellar: :any,                 catalina:       "22baf7a21bf5e4555b78d0662c93078c8d51e5eb5c0b7c651c15118f8f28c6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3b19081095b30311a3c48a0dd8ab7a5d8dba19045f6297e47c96de798c5bb5"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.11"

  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/42/yelp-xsl-42.0.tar.xz"
    sha256 "29b273cc0bd16efb6e983443803f1e9fdc03511e5c4ff6348fd30a604d4dc846"
  end

  def install
    python = "python3.11"

    venv = virtualenv_create(libexec, python)
    venv.pip_install resource("lxml")
    ENV.prepend_path "PATH", libexec/"bin"

    resource("yelp-xsl").stage do
      system "./configure", *std_configure_args, "--disable-silent-rules"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", share/"pkgconfig"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Replace shebang with virtualenv python
    rewrite_shebang python_shebang_rewrite_info("#{libexec}/bin/#{python}"), *bin.children
  end

  test do
    system bin/"yelp-new", "task", "ducksinarow"
    system bin/"yelp-build", "html", "ducksinarow.page"
    system bin/"yelp-check", "validate", "ducksinarow.page"
  end
end
