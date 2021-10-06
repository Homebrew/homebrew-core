class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/57/3f/a8ba181148dcb9184cb0afac66d075fce60f06f926ce9cdab3dc61fd6497/rich-10.11.0.tar.gz"
  sha256 "016fa105f34b69c434e7f908bb5bd7fefa9616efdb218a2917117683a6394ce5"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84b0b7effcabf0da687498d844ed3f57c3149eb510732a08b71391f1888d3dea"
    sha256 cellar: :any_skip_relocation, big_sur:       "492a44887bb591e7f70b94486019eaac108de1ecfcfd57eaa1a05fa2748529ef"
    sha256 cellar: :any_skip_relocation, catalina:      "c62b52ce6464a2a8a543ee5c07308ca6c8beeba738d8311e9c55ce201ce6d886"
    sha256 cellar: :any_skip_relocation, mojave:        "caa768c8e228d20919186690efd3327b14f65d4f96abc7792a0037f903dbd905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69313cfad19790a4eb0905b3e5a22168aef1aca7ba06e5930b758645bd2de912"
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
