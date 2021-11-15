class YelpTools < Formula
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/41/yelp-tools-41.0.tar.xz"
  sha256 "37f1acc02bcbe68a31b86e07c129a839bd3276e656dc89eb7fc0a92746eff272"
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
