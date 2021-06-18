class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/42/6e/549283c6f8b9fff54ee8bd35558eb51d3796b1f71509d3385011d9a8c857/rich-10.3.0.tar.gz"
  sha256 "a83bff83309687e1859c75b499879738b135d700738dd2721c22965497af05bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fa21f85e7509e74dfc0b3522fdc056be1aede4bd01ca5859e7944d438e2da40c"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9c2debfc7f1b85ed396ef8312e958891d58c652bf3b7722121fc6a9c3b9001a"
    sha256 cellar: :any_skip_relocation, catalina:      "43e252214edd0ee8f61b42127b8ac65b1fca76519a96576425a91bbec1a1436d"
    sha256 cellar: :any_skip_relocation, mojave:        "c191fe36798ba7e02584f4ae98740540dc2e304703952b0ef5009a4e64e45773"
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
