class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/8d/0e/461aeb736762862b511034933d5b98d68f812431b7393b026d9ace5f6b42/weasyprint-70.0.tar.gz"
  sha256 "c263abf0e86c747b12af678b67f85f4abbfb97d18a20503031e7ba94e4b8cf8c"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2f3ca5ef535806e5ff5cb05d601129d9ae0220d4e09554ca3e0b8493ee3e4e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b386a8eeb59a00ee8f9025edcd8fe156baf4d6461f5feac859bf758d16be6ca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c93b1e4548b86ef1c555682303956111f13775e4effa7ca9b4b27fdca72cd042"
    sha256 cellar: :any,                 arm64_linux:       "7655055d9a1aec93a24eb9d46e92b997b99ff3d288e3dce9b0327ec0de06c6ea"
    sha256 cellar: :any,                 x86_64_linux:      "4f2b0bdbffb02c1cb15de9df4cddb9789ff1ebfc2a9848751514d415dc59e22d"
  end

  depends_on "cffi" => :no_linkage
  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.15"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[cffi pillow]

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/06/00/2456b6b664c7a770989cbe3c352aac4eb962c938486f03a2e1255ae963c6/cssselect2-0.10.1.tar.gz"
    sha256 "83b0d820ef589dabaf693289b647c2f5b410f76d285f56deba911ffa75a7b9d1"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/94/36/102e180f8f5dbaee88b26595b01ca8aa80bf4e62128d9aa94265b3996c96/fonttools-4.67.0.tar.gz"
    sha256 "3cb57e6600ca77c0b1729cf8adc23bc0652633a37f18cfa934d9c7bc3de25519"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/67/1f/3a10f8d2d106bb68330c43a5cd0faf922d1816f65a1581f35015ac654a79/pydyf-0.13.0.tar.gz"
    sha256 "3c1bd536c7161d9f472b82a8aaa27d3359a9058ec12de15302d92b3690dae7f5"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/94/47/8430452269cd28863d73b903d07d329d058cf762527ff211b3864ba61fc7/pyphen-0.18.1.tar.gz"
    sha256 "dbae6fbbe4f01cb206108b43573d857c67107be9d0e38eb1b08d6fa2210634a7"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/a3/ae/2ca4913e5c0f09781d75482874c3a95db9105462a92ddd303c7d285d3df2/tinycss2-1.5.1.tar.gz"
    sha256 "d339d2b616ba90ccce58da8495a78f46e55d4d25f9fd71dfd526f07e7d53f957"
  end

  resource "tinyhtml5" do
    url "https://files.pythonhosted.org/packages/b1/1f/cfe2f6b30557c92b3f31d41707e09cef5c1efbd87392bc6c0430c46b0e4d/tinyhtml5-2.1.0.tar.gz"
    sha256 "60a50ec3d938a37e491efa01af895853060943dcebb5627de5b10d188b338a67"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/74/21/3b6af43a663b22b00e738bb0642931a2579e15da6852613d56c6aa535d28/zopfli-0.4.3.tar.gz"
    sha256 "d3a50f91a13cea9bafe025de8fd87a005eb26de02a4f0c193127ddbf23ac8ebe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.html").write <<~HTML
      <p>This is a PDF</p>
    HTML
    system bin/"weasyprint", "example.html", "example.pdf"
    assert_path_exists testpath/"example.pdf"
    File.open(testpath/"example.pdf", encoding: "iso-8859-1") do |f|
      contents = f.read
      assert_match(/^%PDF-1.7\n/, contents)
    end
  end
end
