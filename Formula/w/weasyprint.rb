class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/2b/f0/1ac7d241b8cabaaf047278ef67b64869473a4e0a2218a1cbc0a6ffb0d8fd/weasyprint-63.1.tar.gz"
  sha256 "cb424e63e8dd3f14195bfe5f203527646aa40a2f00ac819f9d39b8304cec0044"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b012f713e519add08e47b4f909a31efacc420a4c31c6c66571a4f48e50c22d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63cf630515a874763c0bb9c551a3f4ddf26ac08b2aa9cfe6109ad53586157cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "391cf932d971125cd7d57ad322a0b0960c33ed5972472db10c1913a60bd15cc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "61beff592575c38786320e8e8867c528f65a0e1a6e7cf30f84c1b5f7e075d39d"
    sha256 cellar: :any_skip_relocation, ventura:       "87ccf0b4f7df1615889ff91fa35192e612104eb5edf665567edea63b44e2baa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22042851994d5b41f6110f065ae4b3996ed1c2016d9a15a51ea23a497d4b937a"
  end

  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e7/fc/326cb6f988905998f09bb54a3f5d98d4462ba119363c0dfad29750d48c09/cssselect2-0.7.0.tar.gz"
    sha256 "1ccd984dab89fc68955043aca4e1b03e0cf29cad9880f6e28e3ba7a74b14aa5a"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/f4/3a/6ab28db8f90c99e6b502436fb642912b590c352d5ba83e0b22b46db209da/fonttools-4.55.2.tar.gz"
    sha256 "45947e7b3f9673f91df125d375eb57b9a23f2a603f438a1aebf3171bffa7a205"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/2e/c2/97fc6ce4ce0045080dc99446def812081b57750ed8aa67bfdfafa4561fe5/pydyf-0.11.0.tar.gz"
    sha256 "394dddf619cca9d0c55715e3c55ea121a9bf9cbc780cdc1201a2427917b86b64"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/66/46/3dd0ae4b52016496069af6c4fca3b5918b0281fc92678f739edb8f3eb377/pyphen-0.17.0.tar.gz"
    sha256 "1d13acd1ce37a384d7612954ae6c7801bb4c5316da0e2b937b2127ba702a3da4"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/7a/fd/7a5ee21fd08ff70d3d33a5781c255cbe779659bd03278feb98b19ee550f4/tinycss2-1.4.0.tar.gz"
    sha256 "10c0972f6fc0fbee87c3edb76549357415e94548c1ae10ebccdea16fb404a9b7"
  end

  resource "tinyhtml5" do
    url "https://files.pythonhosted.org/packages/fd/03/6111ed99e9bf7dfa1c30baeef0e0fb7e0bd387bd07f8e5b270776fe1de3f/tinyhtml5-2.0.0.tar.gz"
    sha256 "086f998833da24c300c414d9fe81d9b368fd04cb9d2596a008421cbc705fcfcc"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/5e/7c/a8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62/zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.html").write <<~HTML
      <p>This is a PDF</p>
    HTML
    system bin/"weasyprint", "example.html", "example.pdf"
    assert_predicate testpath/"example.pdf", :exist?
    File.open(testpath/"example.pdf", encoding: "iso-8859-1") do |f|
      contents = f.read
      assert_match(/^%PDF-1.7\n/, contents)
    end
  end
end
