class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/32/3f/d305dc714c119e5b11c0ea1ecff9741407b6da90d6b684859d3b3e586692/weasyprint-57.1.tar.gz"
  sha256 "397a9d11298f94485ec3b7b68aeef1c6106fb638350126d9d4a64109b73508a0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "466244a171b97a80fa0f4cd401a0ad232a007847f8cd0f1f6ea50fa1b66faea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "899fa0f8cbde19fda5930378eccce1b5e1266cc43f561faeec5a9f6d12b5d75d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1980034b618869237405fb1b5eae667ec7d0a3691e11dd64827709a84658dcfb"
    sha256 cellar: :any_skip_relocation, ventura:        "a05290b9569300111f945e286feeb4c577ba247490d2ccea163e3e9435a2aa1c"
    sha256 cellar: :any_skip_relocation, monterey:       "258262bd1b246b2532ae085158e3225079f874d09ad30982ac7bffae54f6b579"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbf8a42ff240743bc71ee8406212b42ff2f7b16af4c30c8257e4a32e48005786"
    sha256 cellar: :any_skip_relocation, catalina:       "a2a047df728552b1448827b48e5dc4e409695d4e1e8621397b22558956ee643e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef6c7af41626c449c08394bedf5a70ac580f563f50c8fb6017c5f6260033afc"
  end

  depends_on "fonttools"
  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.10"
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
    url "https://files.pythonhosted.org/packages/f4/4c/6d31b36a46714d8206b8ca84b8dc9aaf42093415b1f50471538552abe501/pydyf-0.5.0.tar.gz"
    sha256 "51e751ae1504037c1fc1f4815119137b011802cd5f6c3539db066c455b14a7e1"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/9a/53/e7f212c87f91aab928bbf0de95ebc319c4d935e59bd5ed868f2c2bfc9465/pyphen-0.13.0.tar.gz"
    sha256 "06873cebffd65a8fca7c20c0e3dc032655c7ee8de0f552205cad3b574265c293"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
    # we depend on fonttools, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
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
