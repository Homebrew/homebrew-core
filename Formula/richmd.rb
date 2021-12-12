class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/9e/bc/259729e8f8e2f4046284d14d6f3197b537e7c8ef5f1dafd384a7cddc70ef/rich-10.16.0.tar.gz"
  sha256 "06a1355131feda5eba4511dd749e9187ac0fb42209e189845d81e94505fc268e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cbdd5d3158995de4b394e643c1ed843750170170bd8b0c2d6051653504c5bbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30e5a2b33a774ca9d3fae88808b81f4d84d2a1ad09ee241916aa371260810f29"
    sha256 cellar: :any_skip_relocation, monterey:       "94a13a6c8fea6f4a2243e19fe07a21cd18f9a22f467ea9b7d4b28c32584ebfa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "35734e665ef4cd8fd39bbd8d9c79c30689668a500261e2c2f020deab008a2da0"
    sha256 cellar: :any_skip_relocation, catalina:       "f4e4523e3379349351003db663a02fa031005dd8a73d0bfd9a24c279b608d96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e54fd669e59f99764a09ac359a0d9075f4347d3eaba04fc0260b44aa874aa9"
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
