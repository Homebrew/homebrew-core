class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/93/d9/1f9b9129b722fe4127b3749d427ec0f2e0966858e204743c068446b532f0/sigma_cli-1.0.1.tar.gz"
  sha256 "a65dd949dd9812a4380332bacd6cf0c229647404fa31b766fae1596b6bf5e208"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0d9bdc62888f4d50c29816698a6565546450bcadf6c294695c49f9ba151a5a8"
    sha256 cellar: :any,                 arm64_ventura:  "d036f02863f21dbc7efa6d9ea6185aad63a56ef8cf6fcb6893e3d26b882fbe6b"
    sha256 cellar: :any,                 arm64_monterey: "4fd562dc13c9380f75c04cafa6742d32ab774082415d1775b3803a0c3b50408f"
    sha256 cellar: :any,                 sonoma:         "9a84b200e4b8441f1b463714961a4b038c45dfce26b6a893c86408ab34d32ebe"
    sha256 cellar: :any,                 ventura:        "d752a866c8d5b2bcb915ffdb671e877d4fd438f3c059660afbe1cc6cd18a2c9f"
    sha256 cellar: :any,                 monterey:       "92383fa0bce9204ad7ff102649e806d714292981cb17af9b0870795676b30c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c16a132c6d928bfa472f5e57f55546693288fc86e707fbe9f6d35ae84124484"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/19/d3/7cb826e085a254888d8afb4ae3f8d43859b13149ac8450b221120d4964c9/prettytable-3.10.0.tar.gz"
    sha256 "9665594d137fb08a1117518c25551e0ede1687197cf353a4fdc78d27e1073568"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/94/75/aec3ebd2f369040b1de41e7453fad58ed3bf51343f3cc3356a6c09fc7619/pysigma-0.11.4.tar.gz"
    sha256 "1e09b32e195f56d6afd2bd0e97f2d360f3d5ad99c2fe48b92012a935e52babdd"
  end

  resource "pysigma-backend-sqlite" do
    url "https://files.pythonhosted.org/packages/f9/a7/44f3af755fc30d693c9c1242b8f3e52507ffaed34c4847329c3eb0ba62f3/pysigma_backend_sqlite-0.1.2.tar.gz"
    sha256 "9a57a4f89689f980c4cd53cdfb2f8fbfc49ea301b9446f39659e9a84f688302f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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
