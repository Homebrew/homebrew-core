class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a5b6c2e519d8b7a88a932180534bbc9ca78d1abe209ef95783e4c7bd669a18c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b4c81d02982f89530951fbffffe03933a93d9a9e0493ef2e4d5ab02194990d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b23021a426a469efa2b299696387a94cec60dabc97be977af76d239d9231ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fb24a112322b091a4bad5468b276b53602d5d11b664c1eb101dc6bdef3be434"
    sha256 cellar: :any_skip_relocation, ventura:        "ff71470d24536ce9b49d4f3709ed45cd00ed8dcded7df3c5b3c0292faeb4edcb"
    sha256 cellar: :any_skip_relocation, monterey:       "221b9a4696b4bfd3f0b5ec3eaf43311a5025f894b8d340960d78f9ad5cd4d139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7cbd7b8cdc15cad1c2aaf7ad0d2f67933a3dccaca372129a20074177452b3f"
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
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
