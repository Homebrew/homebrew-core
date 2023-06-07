class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/1d/69/11343bbb46d4f2a311677058e19cc2f7bc55a769b64c547a64ea1e2b6045/weasyprint-59.0.tar.gz"
  sha256 "223a76636b3744eaa4ab8a2885f50cf46cf8ebb1acb99b5276d02feccf507492"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e07c7e43b5a6d6377571f2baae8cd1e731c839be6e1624a2aac9584bacda820b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f31ce3decb3a0bc6632cde103c077e807202c48cd51807f134635cccc8f4a47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4677be412952f475ee73a2a68600ab32b0583c97245a47398d7da8e104a0271"
    sha256 cellar: :any_skip_relocation, ventura:        "c77cedcce2d7386f968ea26f3d1c6612d41488f3a68bc4a863d8702b55f98e69"
    sha256 cellar: :any_skip_relocation, monterey:       "b3588484443b1d9882c860653861c02a9d9e42f6120c46f85fefdd097a25c6d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "34f7c47c180bdbe9ddca0fa57c42bb5824cfde0637a61bc127b6185b4bdfe737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "095a11d0f1207d4eb89952e5cdfe66fac5f3f87bfaf357b734e8c8d412d78873"
  end

  depends_on "fonttools"
  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e7/fc/326cb6f988905998f09bb54a3f5d98d4462ba119363c0dfad29750d48c09/cssselect2-0.7.0.tar.gz"
    sha256 "1ccd984dab89fc68955043aca4e1b03e0cf29cad9880f6e28e3ba7a74b14aa5a"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/9d/c5/d5e4536968c36c0838459b5c482b9228e9aae839847837623d0d04576ba0/pydyf-0.6.0.tar.gz"
    sha256 "b44a38855d7e47b740b3cd31ab63a2f5b9b2793931d50b0ccaed3bb7b86912fc"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/4b/52/46b119f94b3f68e4193ada36941606d8e26852b67bb6e099b0e310540b41/pyphen-0.14.0.tar.gz"
    sha256 "596c8b3be1c1a70411ba5f6517d9ccfe3083c758ae2b94a45f2707346d8e66fa"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/9a/ed/d004d5737f9546167eecf0ecd995ee1a796703e512deb2f2ea26cdbe4b3e/zopfli-0.2.2.zip"
    sha256 "2d49db7540d9991976af464ebc1b9ed12988c04d90691bcb51dc4a373a9e2afc"
  end

  def install
    virtualenv_install_with_resources
    # we depend on fonttools, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    fonttools = Formula["fonttools"].opt_libexec
    (libexec/site_packages/"homebrew-fonttools.pth").write fonttools/site_packages
  end

  test do
    (testpath/"example.html").write <<~EOS
      <p>This is a PDF</p>
    EOS
    system bin/"weasyprint", "example.html", "example.pdf"
    assert_predicate testpath/"example.pdf", :exist?
    File.open(testpath/"example.pdf", encoding: "iso-8859-1") do |f|
      contents = f.read
      assert_match(/^%PDF-1.7\n/, contents)
    end
  end
end
