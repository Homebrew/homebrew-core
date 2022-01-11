class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/eb/be/bd5d6c37f5de55f31cb9432e0d926ceeab1b2ee774bd696557b53bc15012/rich-11.0.0.tar.gz"
  sha256 "c32a8340b21c75931f157466fefe81ae10b92c36a5ea34524dff3767238774a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c8f4f76cec64c5aff9776a64b4c76afe2a4f566dc51091911ede79f44c34f51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0ce11b360500d245d3afd5b5acbca4ae319d65523cea7b5a6a25db492fcf464"
    sha256 cellar: :any_skip_relocation, monterey:       "664a5e5e7919791a60a0661d09869771c9df81c23797e2070a107d444a7af8c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c573471a88e2ed89d3e5d9fe2efda1cb5bce25375d1150321c25dbd6c290450"
    sha256 cellar: :any_skip_relocation, catalina:       "26a12225bf72172f20ded603f7eac0184e8a56a00c16c13fdf2a7a9fc83cd235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc79ef4d30872acc06e04c3b6f2dc705463c0c0eae8b52cce88bc75bf531f47"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  def install
    virtualenv_install_with_resources

    (bin/"richmd").write <<~SH
      #!/bin/bash
      #{libexec/"bin/python"} -m rich.markdown $@
    SH
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/richmd foo.md").strip
  end
end
