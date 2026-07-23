class Raven < Formula
  include Language::Python::Virtualenv

  desc "Risk Analysis and Vulnerability Enumeration for CI/CD"
  homepage "https://github.com/CycodeLabs/raven"
  url "https://files.pythonhosted.org/packages/d8/b6/4bc5aecae28382720fca4e9492a623e3d821d96e8f4d06e4335c77779ebd/raven_cycode-1.0.9.tar.gz"
  sha256 "a7cb02102b43dbaad3b50970f92090b86a3b3bb65aae9976a3887f4c8c935238"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "d3e905633eb1f0d3d7e5fc048e8fe2fa6a5790243c0181db8e2c190705fe8a80"
    sha256 cellar: :any,                 arm64_sequoia: "01217a819e571872f899fa5d9c6ceb79618c31e6a837936457c241a1ea555b2b"
    sha256 cellar: :any,                 arm64_sonoma:  "7aa0a40d4446df2aad0c7d8db6e29701607ab32335e4a70101b77d9c1ea99ce2"
    sha256 cellar: :any,                 sonoma:        "ce38a5aedcd289f909feea97abe3d5b0c7e1226832d7035561aafac30ba8b688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b2a4dc459ba3a8920aabae6e35d660a72c5db180028a16234e9f9cada84be28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bfe3e68919eef6de9f572601c59174431425ba393bc5a9b7b8a84a59a757123"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  # `pyyaml` is manually updated to support Python 3.14

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "interchange" do
    url "https://files.pythonhosted.org/packages/ca/10/055c9f411105acd277465a356f4d8c1c2a8d266b87ce68148c47ad54eebf/interchange-2021.0.4.tar.gz"
    sha256 "6791d1b34621e990035fe75d808523172340d80ade1b50412226820184199550"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/9e/30/d87a423766b24db416a46e9335b9602b054a72b96a88a241f2b09b560fa8/loguru-0.7.2.tar.gz"
    sha256 "e671a53522515f34fd406340ee968cb9ecafbc4b36c679da03c18fd8d0bd51ac"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/ea/ca/8e91948b782ddfbd194f323e7e7d9ba12e5877addf04fb2bf8fca38e86ac/monotonic-1.6.tar.gz"
    sha256 "3a55207bcfed53ddd5c5bae174524062935efed17792e9de2ad0205ce9ad63f7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pansi" do
    url "https://files.pythonhosted.org/packages/22/0d/2c19187e820cbad87e73619fe2450d2698eb003eb0a0137551bd687a9676/pansi-2020.7.3.tar.gz"
    sha256 "bd182d504528f870601acb0282aded411ad00a0148427b0e53a12162f4e74dcf"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "py2neo" do
    url "https://files.pythonhosted.org/packages/96/bb/fd298b06181fc4aace4838d91e6b511184ad1f3e5fe9cffee7878c66f14a/py2neo-2021.2.4.tar.gz"
    sha256 "4b2737fcd9fd8d82b57e856de4eda005281c9cf0741c989e5252678f0503f77e"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/30/b7/7d44bbc04c531dcc753056920e0988032e5871ac674b5a84cb979de6e7af/pytest-8.1.1.tar.gz"
    sha256 "ac978141a75948948817d360297b7aae0fcb9d6ff6bc9ec6d514b85d5a65c044"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/69/4f/7bf883f12ad496ecc9514cd9e267b29a68b3e9629661a2bbc24f80eff168/pytz-2023.3.post1.tar.gz"
    sha256 "7b4fddbeb94a1eba4b557da24f19fdf9db575192544270a9101d8509f9f43d7b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/eb/fc/8e822fd1e0a023c5ff80ca8c469b1d854c905ebb526ba38a90e7487c9897/redis-5.0.3.tar.gz"
    sha256 "4973bae7444c0fbed64a06b87446f79361cb7e4ec1538c022d696ed7a5015580"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/f8/77/e567bfc892a352ea2c6bc7e29830bed763b4a14681e7fefaf82974a9f775/slack_sdk-3.27.1.tar.gz"
    sha256 "85d86b34d807c26c8bb33c1569ec0985876f06ae4a2692afba765b7a5490d28c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "brewtest" do
      output = shell_output("#{bin}/raven report 2>&1", 1)
      assert_match "[Errno 2] No such file or directory: 'library'", output

      output = shell_output("#{bin}/raven report slack 2>&1", 2)
      assert_match "the following arguments are required: --slack-token/-st, --channel-id/-ci", output
    end
  end
end
