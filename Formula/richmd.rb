class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/09/a4/4d197cad5b8e85085e6593628131bd0fec903c1f61e158326d80cd6c1c6b/rich-10.15.1.tar.gz"
  sha256 "93d0ea3c35ecfd8703dbe52b76885e224ad8d68c7766c921c726b14b22a57b7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c3a6c3c1626ce817c00f1313d9a39be7b6681b2c74d5c7e415e586de7ffec36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2faffe00c8245e5e557388633ca8ce4baced76f900c8ae8e40b17b888f62f534"
    sha256 cellar: :any_skip_relocation, monterey:       "85308c3de7398e6775288f32369e84416d8c0e6d0a8ec98179660336f9ea77a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a693840000242b207ba45e3128116793d75f535ad4d6a5d5d6911ca892c466b"
    sha256 cellar: :any_skip_relocation, catalina:       "9e925288a01fbf52273e97d5054ac457f0769223ed0d9197c65038a6dd7cf0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de9ca9d750c1d9ad6b2c244b5926b2dfa16e833306e32ada00dfa506194919b2"
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
