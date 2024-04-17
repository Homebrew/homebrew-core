class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "165c7576d713878d6d90437837807854b5335ba1eda387ba7201c24f4d409403"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "165c7576d713878d6d90437837807854b5335ba1eda387ba7201c24f4d409403"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "165c7576d713878d6d90437837807854b5335ba1eda387ba7201c24f4d409403"
    sha256 cellar: :any_skip_relocation, sonoma:         "165c7576d713878d6d90437837807854b5335ba1eda387ba7201c24f4d409403"
    sha256 cellar: :any_skip_relocation, ventura:        "165c7576d713878d6d90437837807854b5335ba1eda387ba7201c24f4d409403"
    sha256 cellar: :any_skip_relocation, monterey:       "165c7576d713878d6d90437837807854b5335ba1eda387ba7201c24f4d409403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5241c1dccedc457c95b101762f582249c60bff05463bc9920f044501c59b04c6"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end
