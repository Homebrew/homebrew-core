class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/fb/96/b268c7ac622597f8660e14e01d8b66b84a34fbbaed3b920bfca440f742fe/rich-9.8.2.tar.gz"
  sha256 "c0d5903b463f015b254d6f52da82af3821d266fe516ae05fdc266e6abba5c3a8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d28e18afeb12971dc69848c6509464b93addc289ef1f17058c40a1f984605b7" => :big_sur
    sha256 "ea4f0dd51f1b9a819114fca48d3a55865eea2530773433657364c64d0caf1473" => :arm64_big_sur
    sha256 "91fdb6277709ec5f6ae59424ec3c37fd47b442cc0663bbeb9286dac1aa3bf49d" => :catalina
    sha256 "b11246f5d9fb7ae84ed76285211f6e41a67eb2ba4469fab98d5aa80565049b36" => :mojave
  end

  depends_on "python@3.9"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
    sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  def install
    virtualenv_install_with_resources

    (bin/"richmd").write <<~SH
      #!/bin/bash
      #{libexec/"bin/python"} -m rich.markdown $@
    SH
  end

  test do
    assert_equal "• Hello, World", shell_output("echo '- Hello, World' | #{bin}/richmd").strip
  end
end
