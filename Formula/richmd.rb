class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/5a/2d/5e92c69f971cb2a373a5203fe2ff0a06751b3eea918c709318e19f7caf62/rich-9.9.0.tar.gz"
  sha256 "0bd8f42c3a03b7ef5e311d5e37f47bea9d268f541981c169072be5869c007957"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2b706385f4e2d05fa0275272a5df22f3cf03eccab587e8ded1c631f0e871bc4" => :big_sur
    sha256 "0bfa7ab40783d2350d6eb6f6c02a00cf3e111a4e43c19ebc525731367059060d" => :arm64_big_sur
    sha256 "409bf41731fab5fc5cab592c9ac118166d4f4ca0609961f3f92f98e6cfbb28c2" => :catalina
    sha256 "1e0956960255ccff0de3d9bb369723792fda96226ef171f488a128b2072f9460" => :mojave
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
    url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
    sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  def install
    virtualenv_install_with_resources

    (bin/"richmd").write <<~SH
      #!/bin/bash
      #{libexec/"bin/python"} -m rich.markdown $@
    SH
  end

  test do
    assert_equal "• Hello, World", shell_output("echo '- Hello, World' | #{bin}/richmd").strip
  end
end
