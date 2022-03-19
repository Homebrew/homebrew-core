class YelpTools < Formula
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.0.tar.xz"
  sha256 "2cd43063ffa7262df15dd8d379aa3ea3999d42661f07563f4802daa1149f7df4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cda13a749f9817f2e856178fda8ac72ad0104fca14a48bdb8abc26085610f051"
    sha256 cellar: :any,                 arm64_big_sur:  "7023c23ea27f57ff8a89a378643ecdbb643f5350126ce1971bb575d9d773f739"
    sha256 cellar: :any,                 monterey:       "0085d535d7f8a428012e1d9ed188abeb8859b8f67804d7f970b6afd25a795cb4"
    sha256 cellar: :any,                 big_sur:        "1102fbc8573c51525f22bfc069c2cad50402012c80699d958130c6ddf153c924"
    sha256 cellar: :any,                 catalina:       "7ed33af3a9d9c7256c06357b30f9f1ef577ae7409c376e60f8c9e10ff5d0b55d"
    sha256 cellar: :any,                 mojave:         "533c8b568d6390cf108b222ec3334a048c5b038a59d29b53cf17e55b0191d734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cab7be797b38e41c06681e07624a044dc4d75f837649e244062b9795e773b3a3"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.9"

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
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("lxml")
    ENV.prepend_path "PATH", libexec/"bin"

    resource("yelp-xsl").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{share}/pkgconfig"
    end

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # Replace shebang with virtualenv python
    inreplace Dir[bin/"*"], "#!/usr/bin/python3", "#!#{libexec}/bin/python"
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
