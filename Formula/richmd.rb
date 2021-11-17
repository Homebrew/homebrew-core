class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/d3/09/e30866c844516d4f15e5b0c436250aaa17a94cc41cf33df2eac78af4243f/rich-10.14.0.tar.gz"
  sha256 "8bfe4546d56b4131298d3a9e571a0742de342f1593770bd0d4707299f772a0af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e1e92b09d4763554fd6abe1cdce13c4aa941f2841aa536b8c21a4eff682934"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "929b3b7466b1f89a7bf9f8c9d8e6adeba3c26289fed5c4d2fc0eac194e839564"
    sha256 cellar: :any_skip_relocation, monterey:       "9d0239622c4b1af434586b5fec394b5879cbddf6d85b6cece2b7b379fe5242a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d6e9a6cc93c83f47ad19f648184a68089cd521ce7f0acdecec61ad094160500"
    sha256 cellar: :any_skip_relocation, catalina:       "6a310239a9e7b37d0ae564e6013a51cbb0fc58f99d6631c4d203ff60c8fb3a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18cb5258bc66d92d49507b8b1055e58a06a76a729a1ec4bb1a4556d161c53d4c"
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
