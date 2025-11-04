class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://gitlab.gnome.org/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 6
    sha256 cellar: :any,                 arm64_tahoe:   "7cc5521c969220f384b20411deb90d5e05f1d178d8203a52303ce5a89d38ab82"
    sha256 cellar: :any,                 arm64_sequoia: "772ad45116fc15ae25475b985b6248b4c3c18c78116f012864c62aec91fca64f"
    sha256 cellar: :any,                 arm64_sonoma:  "5a3a6c2a52bbae96adc5eaebe69181fd4b4451d2626deca6008dd012b1e54ca8"
    sha256 cellar: :any,                 sonoma:        "2afea63853c934f240b83e6a48e83a107259c812a13e2725b033cc98ae0618f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8186b8958c98951dade64261639e1964cd136c2e806bd9eebce23fd6d0bef8a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d7a219224a7171620bf7f88e571a7c2af1bf887601012691817c420f2f7361"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.14"

  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
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

    venv = virtualenv_create(libexec, "python3.14")
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
