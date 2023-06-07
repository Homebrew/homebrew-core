class Shodan < Formula
  include Language::Python::Virtualenv

  desc "Python library and command-line utility for Shodan"
  homepage "https://cli.shodan.io"
  url "https://files.pythonhosted.org/packages/91/a9/693d63433cd3ab659862a05d439f420fae5aee1e1dc9bce03c659122b3f8/shodan-1.29.1.tar.gz"
  sha256 "e2af6254e19d2a8fa4e929738be551e25dc7aafc394732e776e7e30fa44ce339"
  license "MIT"
  head "https://github.com/achillean/shodan-python.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b41ebfd443fe1fd2f0b0d4b7d02783338c65e14a3dfa3463a549d806aba4e2a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e770568f5e5eee2061d88d22863fb4811ce7d4b50928199aa2e275de1b1f976f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "190e3aabb56346d8492c835f4ccf565cb80edb3814bae046c2185736ef90baf8"
    sha256 cellar: :any_skip_relocation, ventura:        "2bbf981ec55f53696776fa7bf106077ecc7680f0d9d5a7956481d83497a99f82"
    sha256 cellar: :any_skip_relocation, monterey:       "227d25bbdad24fc25b4d2457128cc149ec6be8ee6fcfb94dc41aca200d43f747"
    sha256 cellar: :any_skip_relocation, big_sur:        "4eaaf8be65132a8b0263aa6c7ad99100b9849113af386f74d9b8ad1dec8062a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191fe010f23249dcbf13996f37dd51809f38800cb5523d0208f451ce811f7c84"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/e1/6e/954f509c86b65706c0eb7b6d26723a993c84c8ca5e1ee482c77adeaa8b9e/XlsxWriter-3.1.1.tar.gz"
    sha256 "03459ee76f664470c4c63a8977cab624fb259d0fc1faac64dc9cc6f3cc08f945"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shodan version")

    output = shell_output("#{bin}/shodan init 2>&1", 2)
    assert_match "Error: Missing argument '<api key>'.", output
  end
end
