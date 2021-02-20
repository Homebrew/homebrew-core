class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/7b/5a/5ade9c4713b1745970b6276b6c7d5ae37d0cafd453c6c4f1a4b44833980a/rich-9.11.0.tar.gz"
  sha256 "f8f08fdac6bd67dc2dd7fe976da702d748487aa9eb5d050c48b2321bc67ed659"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9e2113be2ae15dd4e44b0d284eed34ba17de4ba9e0b4e4218c908f71a3d5f18"
    sha256 cellar: :any_skip_relocation, big_sur:       "4da01d2d652b315d5fb8bea47857625793febc34bd02eb728dd4394ef3b818b2"
    sha256 cellar: :any_skip_relocation, catalina:      "406da9ff1f21c4ca3c80e21efbe79a5d84f1341754f2de7fcaecba1302ccd7a4"
    sha256 cellar: :any_skip_relocation, mojave:        "32f8ea1ddd88a690fe5cc0feefb13d259f35a608e4fc755bdb992e3ddcb33111"
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
    url "https://files.pythonhosted.org/packages/19/d0/dec5604a275b19b0ebd2b9c43730ce39549c8cd8602043eaf40c541a7256/Pygments-2.8.0.tar.gz"
    sha256 "37a13ba168a02ac54cc5891a42b1caec333e59b66addb7fa633ea8a6d73445c0"
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
