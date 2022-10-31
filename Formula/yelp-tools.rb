class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "53171a90e1b64b2b3a734b989077f99f22cb7efbe8ae219cca160c2c518f87dd"
    sha256 cellar: :any,                 arm64_big_sur:  "d01829cdbf30f61a4a512509a8bc4116783a2f96e3d08215ecab636e7082c6af"
    sha256 cellar: :any,                 monterey:       "587118242a1905c0b8f829123b8664fd1650bd880dfb73b75e5c452023065904"
    sha256 cellar: :any,                 big_sur:        "28d17429734792f78f6dffd87adaa2653a378c2d65ba0ca7f58ece8f33b70448"
    sha256 cellar: :any,                 catalina:       "10845d8f444caae8f0d90448be7fa81dc7044c727be0f3324658cbeb5db7d8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9107878838c287671ab73e70d766f13cc431f478427a0bc03e0bfad56e4b8213"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
      ENV.append_path "PKG_CONFIG_PATH", share/"pkgconfig"
    end

    system "meson", *std_meson_args, "build"
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
