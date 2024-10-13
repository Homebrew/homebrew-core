class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/fd/22/2d76310cd2ea5bbf03c691a08d48626f49853b7261a51bbdc0f834d746ca/weasyprint-62.3.tar.gz"
  sha256 "8d8680d732f7fa0fcbc587692a5a5cb095c3525627066918d6e203cbf42b7fcd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "664b691a814c2c32277adc3b6f5c79a479c48ef2d39b86ae2b797bdc59e3a266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c673fc341ddd0b6c77472204f0fbece9dccd1875aa145cff73725ca4b3456937"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e502ab307d6e5c6d8b736fe8d68d8fef8bfb65009044493a69676473ea05691"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b70956809a87fc94fe386ddcdbf536db293a9ecf61d5fc4db349695ceee42959"
    sha256 cellar: :any_skip_relocation, sonoma:         "67ec881fb796087cbeed85d0aaf28fc1f23df86b5ad9e155c35e7c620c47a07c"
    sha256 cellar: :any_skip_relocation, ventura:        "be59ff232b1a0d10a91d5b6151c1dec11c26959c0b6455b4f7a7258a9f0b4ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "f9fde52e0ee7963f652f516af14aba49bd0785be3d734c0f368bd5e17ed28d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b53402900a8fab244e00fb1147045bda5a8dd6759ad29ebf9f75990c4cb432a5"
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
    url "https://files.pythonhosted.org/packages/a4/6e/681d39b71d5f0d6a1b1dc87d7333331f9961b5ab6a2ad6372d6cf3f8b04c/fonttools-4.53.0.tar.gz"
    sha256 "c93ed66d32de1559b6fc348838c7572d5c0ac1e4a258e76763a5caddd8944002"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/59/0b/389051bbc9decfa057a617c0a676883a674c2ecc2c0cef875e5502e35b77/pydyf-0.10.0.tar.gz"
    sha256 "357194593efaf61d7b48ab97c3d59722114934967c3df3d7878ca6dd25b04c30"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/4c/d1/f6bc803daa4c1cfe5b1176427f46dfe3ffee524bea1dee8bdde532e17c41/pyphen-0.15.0.tar.gz"
    sha256 "a430623decac53dc3691241253263cba36b9dd7a44ffd2680b706af368cda2f2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/44/6f/38d2335a2b70b9982d112bb177e3dbe169746423e33f718bf5e9c7b3ddd3/tinycss2-1.3.0.tar.gz"
    sha256 "152f9acabd296a8375fbca5b84c961ff95971fcfc32e79550c8df8e29118c54d"
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
