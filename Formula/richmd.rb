class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/dc/b4/ad6cac44c9978787cc73d8dd36373665ad3b8613be9120a893e87b99e134/rich-10.13.0.tar.gz"
  sha256 "d80fc76f34d819c481a48f73ec9ac396bed3bd6a16ecd57f9e0654cd89a8fb56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9471fdd6f3f550d43ae6ae973994b8f4171e59d6f06f5f7e59b6ef75470fe29a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f861a0156158a2f7c91264ae4d787d1ab5674c6f7dd265424736dae0286ba16"
    sha256 cellar: :any_skip_relocation, monterey:       "767ea68393a514770980a47576e3bbc1ca4899e6e3cd7f6c78bc88983a0bf15e"
    sha256 cellar: :any_skip_relocation, big_sur:        "32424e4da82e24c585f7703f635718ac36392684798b24188e2f63b1c7448470"
    sha256 cellar: :any_skip_relocation, catalina:       "4032b0e891e1e9ec0d54100b6d09aefebe5366f64aae2fb357c4502ad0b36adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e740ac45534c920c7b55432e4b820e91d5a61d2f5f3c9542fae327f4368275f3"
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
