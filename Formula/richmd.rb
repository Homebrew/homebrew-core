class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/8f/22/6241daa2750061ef726ff6b4ebdb9b774166f241997b256620cf20b14da5/rich-10.15.2.tar.gz"
  sha256 "1dded089b79dd042b3ab5cd63439a338e16652001f0c16e73acdcf4997ad772d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d66364b1285971dc3e7cad2fa0f975e994c0cfab8a7718d9a605a966b3eb890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9793a229615ab73ab6aa238b079bcc74e2262ff0490787e80d281b280207d984"
    sha256 cellar: :any_skip_relocation, monterey:       "7cfa0ffaeef4d1bbecccd4a69026590cc7a17ad07d1a7117424dd771de7b78a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd0ced2dcd349d3cfbacf8c0ab654685de8c7531f710bf0287c2be15450e1fb9"
    sha256 cellar: :any_skip_relocation, catalina:       "fcae852a0ad4ae49e8a4a72e86a1bfc1135360c89f49b750b5c0daf3742f953d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d3cf49b2b3b49420072862f0b4d3d4ab01c950940a69c84cae3d1602910f40c"
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
