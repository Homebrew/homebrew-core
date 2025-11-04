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
    sha256 cellar: :any,                 arm64_tahoe:   "aadb2689c5b993d7f4905f462f40ef9f83c2460e35122d580da4e7fd5303b3db"
    sha256 cellar: :any,                 arm64_sequoia: "194d205a98e507aa391c1ee0df60a573a1f208cf18c44a8818de61fbe2cfea0c"
    sha256 cellar: :any,                 arm64_sonoma:  "f9ae800d882b00715a2dc569a206ae2023db271190f6e638e674e90e1fe0e5ac"
    sha256 cellar: :any,                 sonoma:        "80c6a766ea856ce7c3bc6350687e7d2462ad9ee068bde3aa7cb9c7595c77f3b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c81f1d642b3dcb2ba87061c787c8bc93836b1b82d572b5cc188283c2912db85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "116324ef6b430649dec205fb66c33adc09ba9f719cadf7f33cf9d32e54c48de1"
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
