class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/af/69/0bb9f0807085ce91ad0847d191567257aac180a5960c75c17f43d9ede060/rich-10.2.1.tar.gz"
  sha256 "34865558d322f7151a3012357caa3622df966e51d7a639e4b1fd1b3675b302fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "78ed8538c5ec4caf29edc20fd98c359d669f5ceb3bb84f3037b19e93c952651f"
    sha256 cellar: :any_skip_relocation, big_sur:       "87c04538a0aa52f0b47bd1e21fa51850c89001f6d3f8d81e876846d406003fb2"
    sha256 cellar: :any_skip_relocation, catalina:      "bb3bd2b1b7da1b2147bad75f90a1e72346cf7ce2b3e86f12aea064f88237eccb"
    sha256 cellar: :any_skip_relocation, mojave:        "e9a733dc7a2f0aa375e0eeddada1991db280079766e289fdd91e9459af666a64"
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
