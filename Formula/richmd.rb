class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/8c/65/8743a4b98585dbebf943aa8d8d30421606b492decfde9b8ffc3d5812a791/rich-9.10.0.tar.gz"
  sha256 "e0f2db62a52536ee32f6f584a47536465872cae2b94887cf1f080fb9eaa13eb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83baad0dc632e88e958a46ec79aafa450b5883559723194a1f4dc029188bfadd"
    sha256 cellar: :any_skip_relocation, big_sur:       "dfe47dd1a2c5a9b5d61a3861ffff479e509cecd51c47689cc33efb536376ee66"
    sha256 cellar: :any_skip_relocation, catalina:      "99a2f8f782020512b12b4dc06a591a5beb8e651ae2a664fba44c491f54d24429"
    sha256 cellar: :any_skip_relocation, mojave:        "c7163cd9489c481f047b3527e9d296ece88c655900464fc7134ccfb3a83fccdf"
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
