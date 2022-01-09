class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/eb/be/bd5d6c37f5de55f31cb9432e0d926ceeab1b2ee774bd696557b53bc15012/rich-11.0.0.tar.gz"
  sha256 "c32a8340b21c75931f157466fefe81ae10b92c36a5ea34524dff3767238774a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6975bdae226d8b96e5275cdd90ba45f730a0cfc539d106ccde9134f83388b7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4bfdfaf3926ba529958bfb93f1885b4200253b58b85ab11493b97bf8496a811"
    sha256 cellar: :any_skip_relocation, monterey:       "8bd1b7528d34bf68884fd327415fc96088247642984ccdba45b2276dfe6e651a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6995017d3d5ddd963bb9374ebed03c7c470f1c9e43cd7703e2bb8c336f6c0492"
    sha256 cellar: :any_skip_relocation, catalina:       "d07d6e8d4792c9a6bb4c071270067478d8a42413b4b07d6dba55c411e70eff76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec29286568d78062d4e97feb057074492fbc8f3f20fdc4ab8f966c0bce9502eb"
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
