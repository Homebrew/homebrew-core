class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/93/41/79e947ce1e2e6132afcc13e617b2c1bcce90f481cf78e652f8c986b19162/rich-10.5.0.tar.gz"
  sha256 "f8a16484b3d70708bdafd04f659f9ca0e2c0129b33a343c10c734838d361777f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36eb2b0d1a88fd863743f6884f8dde70d9f71776bf2742c3f0997a2ba02b12bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4060d04755187497020d049ddc94a2f3bcbd81d697933a8a70861d33cfa50d2"
    sha256 cellar: :any_skip_relocation, catalina:      "bca84a8f63b9b3eb51e4c4d6154714c63c4040044b5ab4289c9501fd4e447b4e"
    sha256 cellar: :any_skip_relocation, mojave:        "87390aad5c17f895d115d83d21491204843fdcb89c44d0f5e4e7b1c16dd9eafc"
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
