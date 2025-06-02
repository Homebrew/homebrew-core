class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://gitlab.gnome.org/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_sequoia: "b7fdc8113c53b2269004863275eb727529213a7306fe048195c6d772d068f9a7"
    sha256 cellar: :any,                 arm64_sonoma:  "fecff16b031b801b36674d3ce40d9076a53d50a588874b6c1c003d2a53dd8c65"
    sha256 cellar: :any,                 arm64_ventura: "552d5b45480d56d8c411142fdd7f7a425e63d84869d1f5bf67f1cc16fbea0ce7"
    sha256 cellar: :any,                 sonoma:        "eb9926b85d1ba6364f317753ef6bbff66e60935d6acebbe0dbf760a2773357ab"
    sha256 cellar: :any,                 ventura:       "9d91490539a030c77b1110b8c0a66a5a82ba7f904c958a3eff9b436e56f5f10c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aa4c8857c9df493063cd25472fa61289d177b1834471590f041b4cd93837cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59435fcac44fa0fb975fe0f65fbc6a2d93649c97b004fff1decd049dbc43517"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.13"

  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/42/yelp-xsl-42.1.tar.xz"
    sha256 "238be150b1653080ce139971330fd36d3a26595e0d6a040a2c030bf3d2005bcd"
  end

  resource "mallard-rng" do
    url "https://deb.debian.org/debian/pool/main/m/mallard-rng/mallard-rng_1.1.0.orig.tar.bz2"
    sha256 "66bc8c38758801d5a1330588589b6e81f4d7272a6fbdad0cd4cfcd266848e160"
  end

  def install
    resource("mallard-rng").stage do
      system "./configure", "--disable-silent-rules", *std_configure_args(prefix: libexec)
      system "make", "install"
    end

    resource("yelp-xsl").stage do
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", share/"pkgconfig"
    end

    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resource("lxml")
    ENV.prepend_path "PATH", venv.root/"bin"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children

    xml_catalog_files = libexec/"etc/xml/mallard/catalog"
    bin.env_script_all_files(libexec/"bin", XML_CATALOG_FILES: "${XML_CATALOG_FILES:-#{xml_catalog_files}}")
  end

  test do
    system bin/"yelp-new", "task", "ducksinarow"
    system bin/"yelp-build", "html", "ducksinarow.page"
    system bin/"yelp-check", "validate", "ducksinarow.page"
  end
end
