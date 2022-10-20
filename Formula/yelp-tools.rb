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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "2c06e737298663389451031e99302c3d144fe763ebfd4691620e4c7fe3c73a68"
    sha256 cellar: :any,                 arm64_big_sur:  "de6c67e003dddf654a105d57191c0a0553ef11a016170dbe8c4c40768a06b32a"
    sha256 cellar: :any,                 monterey:       "36e34b081bd07206e309ab7baf6a987810e1154daffb6f74d198dac811d3ec11"
    sha256 cellar: :any,                 big_sur:        "2e93f10304af95f6fed6e727167b2ef29a6f1347a66b9c8720abe0ed5569c60f"
    sha256 cellar: :any,                 catalina:       "39e6bca77bda55c5fe0f753f29a7cc29321502b349c169e79d4725520350b64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09fbd09af2168eb1efcfb6870f7cb9231ec0a3a42c8d5f26f7a6184a5075d1fc"
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
