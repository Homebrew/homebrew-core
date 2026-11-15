class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://gitlab.gnome.org/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"
  revision 4
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "77c8c92eb99e889b03952f2b35927d6f805401e1e3bfda3aa289a689b9c8cb04"
    sha256 cellar: :any, arm64_tahoe:       "5ca8695e886e3b296dd0a1ee3f973a62233fadadc255b9539a1b5e7b7051b03e"
    sha256 cellar: :any, arm64_sequoia:     "2b431b1444438b813deca46ec0f2f4c66da0b4696e8726b6e202bed041d993b6"
    sha256 cellar: :any, arm64_linux:       "6302ece25c5dd450e92c56e50585c5fea8060e4c2b6ec6d14484b4325c40d402"
    sha256 cellar: :any, x86_64_linux:      "b86655ba248297b4ac871f29139fe17f8b78cbcdddced7a1ac48fb74d14d009d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.15"
  depends_on "yelp-xsl" => :no_linkage

  uses_from_macos "libxslt"

  pypi_packages package_name:   "",
                extra_packages: "lxml"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "mallard-rng" do
    url "https://github.com/projectmallard/projectmallard.org/raw/refs/tags/mallard-rng-1.1.0/download/mallard-rng-1.1.0.tar.bz2"
    mirror "https://deb.debian.org/debian/pool/main/m/mallard-rng/mallard-rng_1.1.0.orig.tar.bz2"
    sha256 "66bc8c38758801d5a1330588589b6e81f4d7272a6fbdad0cd4cfcd266848e160"

    livecheck do
      url :url
      regex(/^mallard-rng[._-]v?(\d+(?:\.\d+)+)$/i)
    end
  end

  deny_network_access!

  def install
    resource("mallard-rng").stage do
      system "./configure", "--disable-silent-rules", *std_configure_args(prefix: libexec)
      system "make", "install"
    end

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "mallard-rng" }, build_isolation: false
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
