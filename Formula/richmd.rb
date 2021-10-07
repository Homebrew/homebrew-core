class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/4e/fd/5d40b0363467f8c87d5f5f551b7b431e234bff2becf959daab453f9d7795/rich-10.12.0.tar.gz"
  sha256 "83fb3eff778beec3c55201455c17cccde1ccdf66d5b4dade8ef28f56b50c4bd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df702c08a5aca056fea99356bf60c6de0b855144bb7d5f68d84eb795c27bc2cd"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ca92ddcbca02aa64b739b42c4003a1be0bb1c4d4cae82272fc6d1335e105e5c"
    sha256 cellar: :any_skip_relocation, catalina:      "92ff405d451f98e019371f3448debc0822d3a14497340184271f47097683a097"
    sha256 cellar: :any_skip_relocation, mojave:        "c04c36c6bb943f7d300284506788d2e262f0e19e7a855327a6dde17ea435b715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0fd7ce184e1958e82d873ad584f6bff4db98ce010ad8ca3f68df70fa6698075"
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
