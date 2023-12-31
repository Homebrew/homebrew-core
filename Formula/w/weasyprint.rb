class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/a6/b8/c6f092e67d00c2e5d6e6cccd30a6dfa4a047a283a3a0e3bfaa534c60ff8d/weasyprint-60.2.tar.gz"
  sha256 "0c0cdd617a78699262b80026e67fa1692e3802cfa966395436eeaf6f787dd126"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8cf39aeec2abf244d126d75086d29e2fe8e7bb37fb6a47a98dcea7581609b36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a096399ae040dc01e353b6a223563df3e414839b80b06c3c7ab49b2232a393f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f77687d4d3becd0aa9644b2e7553d4250f88018150f45479e5f19d42fac72d"
    sha256 cellar: :any_skip_relocation, sonoma:         "925b8d7921d80fb3ea7809e4349cc27315198d5c88d1b3b40174c2bd5f512d80"
    sha256 cellar: :any_skip_relocation, ventura:        "b60ae3f519eae6259c7e5e4e3ce989a93df83a7b9eb391fd33ce8cba97d95c04"
    sha256 cellar: :any_skip_relocation, monterey:       "ba575683866ad0a1dd4fcc0737393c049280d342ca628e7c28ac91b2bfafb421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c0ff19d330bb95caa7b2a95c49e94abe7405c4903760263f99ca335f91207d"
  end

  depends_on "cffi"
  depends_on "fonttools"
  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e7/fc/326cb6f988905998f09bb54a3f5d98d4462ba119363c0dfad29750d48c09/cssselect2-0.7.0.tar.gz"
    sha256 "1ccd984dab89fc68955043aca4e1b03e0cf29cad9880f6e28e3ba7a74b14aa5a"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/18/dc/b607bbc7c15327c5d5ec25681a3707c847906134925d21a26ec6e7416a4a/pydyf-0.8.0.tar.gz"
    sha256 "b22b1ef016141b54941ad66ed4e036a7bdff39c0b360993b283875c3f854dd9a"
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
    url "https://files.pythonhosted.org/packages/92/d8/71230eb25ede499401a9a39ddf66fab4e4dab149bf75ed2ecea51a662d9e/zopfli-0.2.3.zip"
    sha256 "dbc9841bedd736041eb5e6982cd92da93bee145745f5422f3795f6f258cdc6ef"
  end

  def install
    virtualenv_install_with_resources
    # we depend on fonttools, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
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
