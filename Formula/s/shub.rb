class Shub < Formula
  include Language::Python::Virtualenv

  desc "Scrapinghub command-line client"
  homepage "https://shub.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/70/ad/b4fa99366cd3c8db8812438fb1e8b6f8a10b2935b0ee28ac238ade864a8f/shub-2.15.4.tar.gz"
  sha256 "abd656f488449a6f88084cfc6f0e5bf1e015377f9777a02f35ae5dd44179434a"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/scrapinghub/shub.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28a4cd1e17d8f759f87bcfb3a57e53c439ce9c757e99729707886cf32d39a841"
    sha256 cellar: :any,                 arm64_ventura:  "0047bec7e6705f84fbe4be5ea3e792c359ac3f918f92c07b2461be46e3729976"
    sha256 cellar: :any,                 arm64_monterey: "d05b32e7247a5e5e9b5d79e3bea59d5630deddc453449c86a14f8acf6f20ea80"
    sha256 cellar: :any,                 sonoma:         "4fdc98f8089375197dfafbdbf609edb375b41c21e58b353144957827f1c7a530"
    sha256 cellar: :any,                 ventura:        "d5b5aa4d3706d4fec50f82adbe436e93d32be963e04a4691a283c9098a800fcb"
    sha256 cellar: :any,                 monterey:       "27db38f3342bbb09a614f1a1768038809b3601138237d39b18b1f3ef48edaabb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149561765ac11879f0f6bd2f74b005652a28bb85aaa170b3eaff882e22a1195a"
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

  resource "docker" do
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/ce/70/15ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9dd/retrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "scrapinghub" do
    url "https://files.pythonhosted.org/packages/a4/5e/83f599af82e467a804da77824e2301ff253c6251c31ac56d0f70bac9e9ce/scrapinghub-2.4.0.tar.gz"
    sha256 "58b90ba44ee01b80576ecce45645e19ca4e6f1176f4da26fcfcbb71bf26f6814"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/9c/97/6627aaf69c42a41d0d22a54ad2bf420290e07da82448823dcd6851de427e/tqdm-4.55.1.tar.gz"
    sha256 "556c55b081bd9aa746d34125d024b73f0e2a0e62d5927ff0e400e20ee0a03b9a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"shub", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shub version")

    assert_match "Error: Missing argument 'SPIDER'.",
      shell_output("#{bin}/shub schedule 2>&1", 2)
  end
end
