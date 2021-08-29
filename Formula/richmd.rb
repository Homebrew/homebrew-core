class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/55/84/7edede78686a4ca67a1bb9d8eba31a99d4a2a0a670e80c9febbbc18a7076/rich-10.9.0.tar.gz"
  sha256 "ba285f1c519519490034284e6a9d2e6e3f16dc7690f2de3d9140737d81304d22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "909292feafb5b3db002e5e7ed50a60cf405f815458e5b302a7f4438d8bb98a51"
    sha256 cellar: :any_skip_relocation, big_sur:       "79d0759fbf0286f632b6e0973c8f2ed6518a57119908b3a7e7ac5d2b2519d852"
    sha256 cellar: :any_skip_relocation, catalina:      "fdd4528db70f2f7e33f8ef7da5c2f59f53611f770eded805502e5856c1ff0573"
    sha256 cellar: :any_skip_relocation, mojave:        "65d1c727070cd17ef80a2cdf9eb2f7d4073695bdb5758beb460a19e6448ac398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a413d6a88a366df75ca6df07c4c45d72471d9f2954072a8d72a921a61cc116f"
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
