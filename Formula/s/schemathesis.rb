class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/51/15/1ff93394dde40bdb167bcd491bdbf182945431f346c2e28a4ba28a4ae17f/schemathesis-3.20.1.tar.gz"
  sha256 "b20b8caebd008e2a24536561cf6ef048833e04623b595d7342f883618b1d6e55"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8bafd3b1f251842acfac54eaafe3fb2eadf3d27693267bd028ede11c36606871"
    sha256 cellar: :any,                 arm64_ventura:  "b2b6d8226e52150d5d725305fe1753f85cc2e6ec7618733238d172e655c3d026"
    sha256 cellar: :any,                 arm64_monterey: "c25e9f66026853c47b790f20da6a2e879f19e18f859291914b89c86c4144e3f5"
    sha256 cellar: :any,                 sonoma:         "aca890d529b475dc19f6ddabd901c63ba489f118c75179607941466de669f958"
    sha256 cellar: :any,                 ventura:        "69b59c6e397d896b7e04f70bb9e52cdf33c2c3768c63fe1e1018d4eb45aedd0a"
    sha256 cellar: :any,                 monterey:       "e70dcdab0ad4dba43d6b4a0e264d2e58051ba39a2fb967f1d2325bc248619e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04347e66ee77666325b8f5ccfeceb76c9289bde0392ffb269dd3d837000c89f7"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/74/17/5075225ee1abbb93cd7fc30a2d343c6a3f5f71cf388f14768a7a38256581/anyio-4.0.0.tar.gz"
    sha256 "f7ed51751b2c2add651e5747c891b47e26d2a21be5d32d9311dfe9692f3e5d7a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/ee/a6/94df9045ca1bac404c7b394094cd06713f63f49c7a4d54d99b773ae81737/graphql-core-3.2.3.tar.gz"
    sha256 "06d2aad0ac723e35b1cb47885d3e5c45e956a53bc1b209a9fc5369007fe46676"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/23/b6/d71729dc09e5a5b361b655ae18e85fbf97e5e27a076c4f9b4606b4eb0340/httpcore-0.18.0.tar.gz"
    sha256 "13b5e5cd1dca1a6636a6aaea212b19f4f85cd88c366a2b82304181b769aab3c9"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/a5/24/dbc981590a8b72ddd5f954fbddb1da010ae844a1cde904bca3c9380ccb1d/httpx-0.25.0.tar.gz"
    sha256 "47ecda285389cb32bb2691cc6e069e3ab0205956f681c5b2ad2325719751d875"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/24/2f/9762d5b9901938ffe7ddfe3527054f6aa4d5335b1595150623f4abab76e7/hypothesis-6.88.1.tar.gz"
    sha256 "f4c2c004b9ec3e0e25332ad2cb6b91eba477a855557a7b5c6e79068809ff8b51"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/50/18/e9c6375162bf2863feb6e073d649eff7e2f12eb9f6f028e05a72fbd69fee/hypothesis_graphql-0.10.0.tar.gz"
    sha256 "468d45f7ab32c2f4121799b2aa5892bd7cd9c8231ec2059dd6b34ed4b976698c"
  end

  resource "hypothesis-jsonschema" do
    url "https://files.pythonhosted.org/packages/8b/d7/47d7c208ca0f8a2ce6535d6cf0a167d9120ccfc00d6c5ff5fae7936a4654/hypothesis-jsonschema-0.22.1.tar.gz"
    sha256 "5dd7449009f323e408a9aa64afb4d18bd1f60ea2eabf5bf152a510da728b34f2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/e4/43/087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5/jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/c0/a2/bb73c385e6d68cbe0ebe6ff16c22c96a79194c1298b2942005fcaf3eda9d/pyrate_limiter-2.10.0.tar.gz"
    sha256 "98cc52cdbe058458e945ae87d4fd5a73186497ffa545ee6e98372f8599a5bd34"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e5/d0/18209bb95db8ee693a9a04fe056ab0663c6d6b1baf67dd50819dd9cd4bd7/pytest-7.4.2.tar.gz"
    sha256 "a766259cfab564a2ad52cb1aae1b881a75c3eb7e34ca3779697c23ed47c47069"
  end

  resource "pytest-subtests" do
    url "https://files.pythonhosted.org/packages/b9/ea/3971817de038f8a03e8a1d1833ce5708965c67bacf1455d140f836c6f7f4/pytest-subtests-0.7.0.tar.gz"
    sha256 "95c44c77e3fbede9848bb88ca90b384815fcba8090ef9a9f55659ab163b1681c"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/ee/12/d6cfa2699916e5ece53a42e486e03b5a14e672c76ddb16d4649efcf9efb8/rpds_py-0.10.6.tar.gz"
    sha256 "4ce5a708d65a8dbf3748d2474b580d606b1b9f91b5c6ab2a316e0b0cf7a4ba50"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/e1/4b/fcd426d9477554d31dacb0c8069828466841b69ad26c8cfab9c5321830ec/starlette-0.31.1.tar.gz"
    sha256 "a4dc2a3448fb059000868d7eb774dd71229261b6d49b6851e7849bec69c0a011"
  end

  resource "starlette-testclient" do
    url "https://files.pythonhosted.org/packages/ab/2d/41c70f946ea97c20149c2ae65466ea10d15a23bc044f5c90ba0e2016a41f/starlette_testclient-0.2.0.tar.gz"
    sha256 "3fb6681d1dc7e9ab6dc05b5ab455b822a03f37e7371316a828e2d8380a198a4a"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/8c/47/75c7099c78dc207486e30cdb2b16059ca6d5c6cdcf9290f4621368bd06e4/werkzeug-3.0.0.tar.gz"
    sha256 "3ffff4dcc32db52ef3cc94dff3000a3c2846890f3a5a51800a27b909c5e770f0"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "openapi": "3.0.3",
        "paths": {}
      }
    EOS
    output = shell_output("#{bin}/st run ./example.json --dry-run")
    assert_match "Schemathesis test session starts", output
    assert_match "Specification version: Open API 3.0.3", output
    assert_match "No checks were performed.", output
  end
end
