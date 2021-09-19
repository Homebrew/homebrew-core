class YelpTools < Formula
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/41/yelp-tools-41.0.tar.xz"
  sha256 "37f1acc02bcbe68a31b86e07c129a839bd3276e656dc89eb7fc0a92746eff272"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "b226bcfda6e2cea725cbc95a9ee19d017ac300a032aeb1efa227ea8454164b41"
    sha256 cellar: :any,                 big_sur:       "10ba9813e3d96f6a4350b4d0fe92bde1ab9be7f871cca7a9b45139027e02cc05"
    sha256 cellar: :any,                 catalina:      "1fee7bdc0cb753d08c14bf9e0136f5088532345e093fb7ede23db66ffadfe9af"
    sha256 cellar: :any,                 mojave:        "194957f1bf5b821459ba59d5f2df603c2e0da4afcd491b1154f861681bd17b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8b94b048a17e0d5b9641ee47935ee05d8b6b781998d6b60c955ea7b8edf3662"
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
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/41/yelp-xsl-41.0.tar.xz"
    sha256 "c8cd64c093bbd8c5d5e47fd38864e90831b5f9cf7403530870206fa96636a4a5"
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
