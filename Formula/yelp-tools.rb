class YelpTools < Formula
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/40/yelp-tools-40.0.tar.xz"
  sha256 "664bacf2f3dd65ef00a43f79487351ab64a6c4c629c56ac0ceb1723c2eb66aae"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "287755e74068f82a9dd94e60e6ae8fc0a3d38f04c2df3ee44d8f427d403d89bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ecac26d055284b58e3b6220a719d20e3e0e5d4fd6c091bb649945b76df6ca69"
    sha256 cellar: :any_skip_relocation, catalina:      "c4dde1e77132df114dfd4b19faeae2b8604a3557ac97a0f2caf47954fcfc0def"
    sha256 cellar: :any_skip_relocation, mojave:        "4eec970808d0b15187fc1bfb976999b52ae0f13b6ae004f7ca9d65d15e6b07a8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "906e221bce54f03db236aee3738c047e3d836a4f124aa3460b9d224a9d0c547b"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libxml2"
  depends_on "python@3.9"

  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/40/yelp-xsl-40.0.tar.xz"
    sha256 "361ecd4d33fccdb3bb08a687f60e5c3e909d2e9e3b022d844e049820d0cf62b0"
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
