class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/72/de/b3a53cf1dfdbdc124e8110a60d6c6da8e39d4610c82491fc862383960552/rich-11.2.0.tar.gz"
  sha256 "1a6266a5738115017bb64a66c59c717e7aa047b3ae49a011ede4abdeffc6536e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b01e8692cee9acd403a954070a23cd56e094ed82142773b86f719f4923cc35e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05ac5bbe0c55a43b754ee980875c621f5397c1cfd4305ca627b0be7b37361ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "89ed3838ecbeebe65ca4a08a0f3daabf48408d302ba019250d9196e4b8ffd114"
    sha256 cellar: :any_skip_relocation, big_sur:        "c733a7d0f8b287b1aadf217e0b29777197a03221a5244bc724bcde3d3a8eb912"
    sha256 cellar: :any_skip_relocation, catalina:       "dc9ebfb2cea5d5e59644899cdc15d9618c70974ec39e46f87736a4c0213a79f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e810c3eaf3430768e27e76c492df20bfbb78d2a924428e5598ffbd1bd0e20e2"
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
