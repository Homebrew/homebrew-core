class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/6b/ea/af2a2218d57cc52dc7f14e4350ee9647fa79c6c820cfc05c438795fb13b4/rich-10.7.0.tar.gz"
  sha256 "13ac80676e12cf528dc4228dc682c8402f82577c2aa67191e294350fa2c3c4e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f63a3759bb14625fa81abadbd803fc938a947f67f317210ae6e4c37c2cdd2f99"
    sha256 cellar: :any_skip_relocation, big_sur:       "61a4d1802bfde9baf093ed35e37453deb0007a2505b1af64a7c0c261285a95d2"
    sha256 cellar: :any_skip_relocation, catalina:      "11085a32bcf262e6f77dcc4dad7697081a8716e78caf2a4f2d0d7ae7421c2ed0"
    sha256 cellar: :any_skip_relocation, mojave:        "0eb26d9e1fc65318ee437ca7a721a5e6aa9d7778aad9d854aa0d75fdfd4d166a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eb388445ea1b57bf78f708dca0a3dce841446374283c1ea6e597e895f9af7eb"
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
