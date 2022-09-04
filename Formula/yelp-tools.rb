class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.0.tar.xz"
  sha256 "2cd43063ffa7262df15dd8d379aa3ea3999d42661f07563f4802daa1149f7df4"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6352c9b27ee153a88bbee62774b528212ac995e4215d38c7e60cd7bbcad121e6"
    sha256 cellar: :any,                 arm64_big_sur:  "9c612a4df8148542782af73ee387053f1f4e3eebba60bc22a20df626d3affe3b"
    sha256 cellar: :any,                 monterey:       "a3d5357411916548318c49d320b5ffbd5cc026f7927e8a9111a71a36befbb9bd"
    sha256 cellar: :any,                 big_sur:        "24ef07e15b762e04e0324871f4b9e14a5515edc273417da62b29ec5c92c32827"
    sha256 cellar: :any,                 catalina:       "49ce7d96da12121a1efe9b121d43629b7ddc4c64c3e36259773cafcd1fe1e28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73569a8bdaa94ad9be25a9eaa23c47d62b2e9e69995058f595e78cafae69ab98"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.10"

  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/42/yelp-xsl-42.0.tar.xz"
    sha256 "29b273cc0bd16efb6e983443803f1e9fdc03511e5c4ff6348fd30a604d4dc846"
  end

  def install
    python = "python3.10"

    venv = virtualenv_create(libexec, python)
    venv.pip_install resource("lxml")
    ENV.prepend_path "PATH", libexec/"bin"

    resource("yelp-xsl").stage do
      system "./configure", *std_configure_args, "--disable-silent-rules"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{share}/pkgconfig"
    end

    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"

    # Replace shebang with virtualenv python
    rewrite_shebang python_shebang_rewrite_info("#{libexec}/bin/#{python}"), *bin.children
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
