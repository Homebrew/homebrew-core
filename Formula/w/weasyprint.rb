class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/f8/1a/32a7de6916ead1bd5b5ed6a5f4431d5011426850566d7ba2947f896cdd19/weasyprint-61.2.tar.gz"
  sha256 "47df6cfeeff8c6c28cf2e4caf837cde17715efe462708ada74baa2eb391b6059"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05012d61dc6d23fc5a31f3539309dd04fc3f41b8a701d4db3a374bd6d23360df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "289fe58220cc07e42a040a2c974d1740cd3818e15502c3e4e5c42cb6f22f04f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a124234ddd1df065fed989f9c111fdb0536837a97fd5672dd58fe06bbae9e7fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5628b6328d477b0aa52cae46b372dbf910236d8f8b8aa321b312c9afabc2c92"
    sha256 cellar: :any_skip_relocation, ventura:        "7660c3bea62053948a7384c52dab872a10e8fbccdef2a0487dc3bee2b974b895"
    sha256 cellar: :any_skip_relocation, monterey:       "5be59e6cf25749d5d78f86e800a4b446e39c63aa607a03bf60cbcec4e46f68ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a89fa75edd5fa63b6a599047d65bbc3083f7ac2d5e266e92e559488947ec4f"
  end

  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e7/fc/326cb6f988905998f09bb54a3f5d98d4462ba119363c0dfad29750d48c09/cssselect2-0.7.0.tar.gz"
    sha256 "1ccd984dab89fc68955043aca4e1b03e0cf29cad9880f6e28e3ba7a74b14aa5a"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/52/c0/b117fe560be1c7bf889e341d1437c207dace4380b10c14f9c7a047df945b/fonttools-4.49.0.tar.gz"
    sha256 "ebf46e7f01b7af7861310417d7c49591a85d99146fc23a5ba82fdb28af156321"
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
    url "https://files.pythonhosted.org/packages/b5/f1/bf85e09977a5c98799337272e3675894bfb71c391f617911eca83ef2937e/pydyf-0.9.0.tar.gz"
    sha256 "d5b244e8fc24119ce7bd5d51ea2d6773c0ff88aa81597db556bc440c6b880610"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/4b/52/46b119f94b3f68e4193ada36941606d8e26852b67bb6e099b0e310540b41/pyphen-0.14.0.tar.gz"
    sha256 "596c8b3be1c1a70411ba5f6517d9ccfe3083c758ae2b94a45f2707346d8e66fa"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
