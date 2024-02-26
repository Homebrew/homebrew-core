class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/da/d9/a74474c18eb4d5aa87e6da82e98a93e4fbdc826c3434e352a423a389a0b4/weasyprint-61.0.tar.gz"
  sha256 "d91b11a05426fef1d63de826f30a80521d48c6a356455d338c2c429989fa586d"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f4c6ac9fab47dc3ddd9a191b64df543df7ca6c820bccc3ce762d910a3fa3054"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2f182d48423216e0c67649bb45f761a8b755f79b24284a74e458e95d1e0a272"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "103012dd84f14677c66d6858a1e47e614f8ab2106a3c9869e69d6497ff94ebef"
    sha256 cellar: :any_skip_relocation, sonoma:         "29b4f2fd3724f70242f92a08ddd55cf4b4e702df8ebbbbf21e19ce4ca9f40336"
    sha256 cellar: :any_skip_relocation, ventura:        "5d1fe69d56c236fac451e05817868c35474fa33b154ac2ca04a576399d889433"
    sha256 cellar: :any_skip_relocation, monterey:       "1d30fb624be33774e58c5e17027751825b53bf1026071dfce4b55887ae7c653e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f5d956bfbb1d376dd745e2dbb889b65f6d6ba36af9f14456fb2ab02fb76b5a"
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
    url "https://files.pythonhosted.org/packages/18/dc/b607bbc7c15327c5d5ec25681a3707c847906134925d21a26ec6e7416a4a/pydyf-0.8.0.tar.gz"
    sha256 "b22b1ef016141b54941ad66ed4e036a7bdff39c0b360993b283875c3f854dd9a"
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
