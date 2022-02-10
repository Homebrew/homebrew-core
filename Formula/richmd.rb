class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/72/de/b3a53cf1dfdbdc124e8110a60d6c6da8e39d4610c82491fc862383960552/rich-11.2.0.tar.gz"
  sha256 "1a6266a5738115017bb64a66c59c717e7aa047b3ae49a011ede4abdeffc6536e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dadbf6e89b0315a4491e2ff0231b445b40b1fb4c1c9596ec0abba53c64bda85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f788089ec5b2be4bfa4b4fe02e043e7276d46eff1c35b7720ce2fcb8a11cf5f9"
    sha256 cellar: :any_skip_relocation, monterey:       "286906bfc29e8be78d0ff57a697822183229e7f4a2efbc5a9f8f5107901c5c88"
    sha256 cellar: :any_skip_relocation, big_sur:        "17e312a52b6fd5e113b7e3bcd7d905e2af3a5fa4bccd7916d12cbe72acffb9d7"
    sha256 cellar: :any_skip_relocation, catalina:       "8df3bc4aa94376d809832d6078e13e508259ca357ce3ff7daa5d75e734916c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe69c0c2ca3aa757c39b8b004d831b2211da0e87dfcd637b5484d2ca3ba586a"
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
