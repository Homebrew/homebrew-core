class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/b3/3b/5a90d0f197087896472757ebd9ac29d802ccc4f6953d99a535b1a8db2bf6/rich-10.16.1.tar.gz"
  sha256 "4949e73de321784ef6664ebbc854ac82b20ff60b2865097b93f3b9b41e30da27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e70071a9581facc9db6a79b67bcdfb75a962b22489aa795288e0c67cc183c9b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb03418d01cca80233bad656435592a7fde0a33674b4a7055f8ea53a2c744cea"
    sha256 cellar: :any_skip_relocation, monterey:       "28ecc7eb9b3fe4c6391ed8629702571bd4d781ef0ec18e33a7b5055a0d4b93fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e20d1e35d6370bc2332c17f88508342b4953dc2bc082663014654cdbd70a3c3d"
    sha256 cellar: :any_skip_relocation, catalina:       "19a647c5b6d47f6ade95d41dd424669ae25f9fc52d4d6bda0564500bc9474d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105883c07c6732f9412518d3155657a0e73ac7b255eab1583e7b3f699253a429"
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
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
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
