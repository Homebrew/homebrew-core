class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/f9/4b/f57f3d4c8d66370a7405b656aa459551fcbdfb5f974f069fae135c4db5c1/rich-10.10.0.tar.gz"
  sha256 "bacf58b25fea6b920446fe4e7abdc6c7664c4530c4098e7a1bc79b16b8551dfa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb832e9071bc1f4899df98a7f4bcd560c6fe63cb3d3fa9a0936b4aa2827eb918"
    sha256 cellar: :any_skip_relocation, big_sur:       "fcb069cbad9d9cf874b39d88e60a5a8810b4807915d3440ecdb949a9e7b70f07"
    sha256 cellar: :any_skip_relocation, catalina:      "3ce5b82d7d1690c28ee7ba7c07464bf3f1da2ff43eba52504aaf67749703bd70"
    sha256 cellar: :any_skip_relocation, mojave:        "a43cfc5684c948262eafe6fe2606247317636b1ea7c10f335a9db8d96705c528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed386880a35d559aabef226e84d9a9ab9cb7ff578c8f323bba72d8c92134f421"
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
