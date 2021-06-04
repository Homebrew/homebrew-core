class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/1e/cc/ced09195051b5384e9a82d6de7fc1a3917017fe214d30d41a9935cea465d/rich-10.2.2.tar.gz"
  sha256 "17b3f486c38e79cc219d8848974b277ef532a82d12b3ad6eb37bb8c6f22ab5fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa90489ac1e439879689bcd1ae425b6582e1ffe8acd798ceb4dd4282b13d46c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "c65e1689fd0082d084f7cd61f64bcf01c14e00115a34629960c6250511d1decc"
    sha256 cellar: :any_skip_relocation, catalina:      "8e9368a939e173b68205c6ee3abe06760d34e08f6a27ec94a6985244a4b811fd"
    sha256 cellar: :any_skip_relocation, mojave:        "a077ebd8564c5716a532e2f560147857d9885441d7fc13bf09244ce1312004ff"
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
