class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/93/d9/1f9b9129b722fe4127b3749d427ec0f2e0966858e204743c068446b532f0/sigma_cli-1.0.1.tar.gz"
  sha256 "a65dd949dd9812a4380332bacd6cf0c229647404fa31b766fae1596b6bf5e208"
  license "LGPL-2.1-or-later"
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d72fd0d1c0db13dba204ca3a9f2eb956aa500c6a8f36ef3c239c85ae29ce151"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d49619b63c140a8045c6c4a7918fbd9eaf0c7be669d38b9913a989111580a80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e66be3b298c28c3f77b93e1999ed3dec38a09b36e13aec0acf99ba5a55a2653"
    sha256 cellar: :any_skip_relocation, sonoma:         "5da929b925255c3ba95c85e52ae28093a95bc24e4e99c6e491ef9b7bd147d77a"
    sha256 cellar: :any_skip_relocation, ventura:        "fe7fde8dd17da1c4a2fb250cb35a94a6207a863de0ac70f22e344e5979d6b7cf"
    sha256 cellar: :any_skip_relocation, monterey:       "3c7393191bd32b70680de2ab48cb52483bd3b00b96a1d8a93b4e47ee26e901ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9fcdd578eabcee1e72623b902ffe764b955e43213c5f40f970c5fe02b3951a"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/39/5b/0605372257fde328cba8d65c0030a2bc2a71bd2ad65fca57c03cc840b626/pysigma-0.11.3.tar.gz"
    sha256 "ed68af1c4150fdd55d0bc1f228fb512088162530a0410f9239deca09ec06942b"
  end

  resource "pysigma-backend-sqlite" do
    url "https://files.pythonhosted.org/packages/f9/a7/44f3af755fc30d693c9c1242b8f3e52507ffaed34c4847329c3eb0ba62f3/pysigma_backend_sqlite-0.1.2.tar.gz"
    sha256 "9a57a4f89689f980c4cd53cdfb2f8fbfc49ea301b9446f39659e9a84f688302f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigma version")

    output = shell_output("#{bin}/sigma plugin list")
    assert_match "SQLite and Zircolite backend", output

    # Only show compatible plugins
    output = shell_output("#{bin}/sigma plugin list --compatible")
    refute_match "Datadog Cloud SIEM backend", output
  end
end
