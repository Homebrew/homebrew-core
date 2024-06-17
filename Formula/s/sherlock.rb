class Sherlock < Formula
  include Language::Python::Virtualenv

  desc "Hunt down social media accounts by username"
  homepage "https://sherlock-project.github.io"
  url "https://files.pythonhosted.org/packages/eb/57/0ac8fcde9e2dbdacb20f48e8c20f3049972a59839d8bccbef0799b944140/sherlock_project-0.14.4.tar.gz"
  sha256 "3c0edc4ebbcdb8eae03d5ce2e377e1c6839d73b8e77388b70125120537917022"
  license "MIT"
  head "https://github.com/sherlock-project/sherlock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c9aa8b48768ebdb3a1f75d57dbb1b5494e328cb960442d151dfe61d19af290c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2313da93e039f071360a265ec9405e0c7ff99a24e3623908cfa1807e5b6d073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55b06aab82e51d750745088c8fc21c63c2c0544a7b7fe27198db418ece12bee7"
    sha256 cellar: :any_skip_relocation, sonoma:         "962fb08052f1cef920bbfe7a7c7f3642f7b9c84a7037818f0f6f538b3dd42fee"
    sha256 cellar: :any_skip_relocation, ventura:        "90db2f5ecac6ed021485664b2a477dea8e9c4e53c98063c83516521d1ca40386"
    sha256 cellar: :any_skip_relocation, monterey:       "01e31530d3c0e54a1e6a255fb4d2640821e1b3a2a064371ae7bf9d8a64a86a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aab9b488bfd11364f1b6e3a94f2ae2acfbb293e605bce48fb2b87815ccb0cbc"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "numpy"
  depends_on "python@3.12"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/3d/5d/0413a31d184a20c763ad741cc7852a659bf15094c24840c5bdd1754765cd/et_xmlfile-1.1.0.tar.gz"
    sha256 "8eb9e2bc2f8c97e37a2dc85a09ecdcdec9d8a396530a6d5a33b30b9a92da0c5c"
  end

  resource "exrex" do
    url "https://files.pythonhosted.org/packages/21/39/8f143f76fa9f6048cb42fa0594fc1a57fd143e69a7d42a35d4e16cabc7d9/exrex-0.11.0.tar.gz"
    sha256 "59912f0234567a5966b10d963c37ca9fe07f1640fd158e77c0dc7c3aee780489"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/42/e8/af028681d493814ca9c2ff8106fc62a4a32e4e0ae14602c2a98fc7b741c8/openpyxl-3.1.2.tar.gz"
    sha256 "a6f5977418eff3b2d5500d54d9db50c8277a368436f4e4f8ddb1be3422870184"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/88/d9/ecf715f34c73ccb1d8ceb82fc01cd1028a65a5f6dbc57bfa6ea155119058/pandas-2.2.2.tar.gz"
    sha256 "9e79019aba43cb4fda9e4d983f8e88ca0373adbb697ae9c6c43093218de28b54"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "requests-futures" do
    url "https://files.pythonhosted.org/packages/f3/07/9140eb28a74f5ee0f256b8c99981f6d21f9f60af5721ca694176fd080687/requests-futures-1.0.1.tar.gz"
    sha256 "f55a4ef80070e2858e7d1e73123d2bfaeaf25b93fd34384d8ddf148e2b676373"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "torrequest" do
    url "https://files.pythonhosted.org/packages/a3/d2/00538e47a2c80979231313c346a0abc3927c7b230d69eb923bb5b221ec62/torrequest-0.1.0.tar.gz"
    sha256 "3745d4ea3ffda98d7a034363c787adb37aab77bdab40094a4d937392cd4dae82"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin/"sherlock --version")

    assert_match "Search completed with 1 results", shell_output(bin/"sherlock --site github homebrew")
  end
end
