class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/ad/71/849f1bb4d11d5d47756e76e3d0d41970dc5134b3d6e02af224d56a4913b8/rich-10.2.0.tar.gz"
  sha256 "a30429d82363d42e7c64e324c2c8735c045f190cba609feee91a7b9f563a64b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a6ef79909a8463e2db2d3f3b800104734b5c002d86dac4918d6cfc22bfe3b82"
    sha256 cellar: :any_skip_relocation, big_sur:       "cefeeb084ce48edb68ced8884a155441ca443bd57ac4ab7f23b88c93b4f9a11e"
    sha256 cellar: :any_skip_relocation, catalina:      "3044a6025b1d7c390acda35a760460b00705b3c48e52f92494dfe69eb8f74536"
    sha256 cellar: :any_skip_relocation, mojave:        "8c5cac466d3362cb6c49c9fe62d725b71a6c7ead4527e41807db7783de91869d"
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
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
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
