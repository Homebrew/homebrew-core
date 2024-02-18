class Raven < Formula
  include Language::Python::Virtualenv

  desc "Risk Analysis and Vulnerability Enumeration for CI/CD"
  homepage "https://github.com/CycodeLabs/raven"
  url "https://files.pythonhosted.org/packages/96/0e/796a4c20e3afc2a88268e189fda9ffc8b0a29b79c8e973f445aad3da6e20/raven-cycode-1.0.7.tar.gz"
  sha256 "746da92efcdc34b6801ce78456a804ee4765ece6b56ccf323c894a4df07b74c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c6cccba9c9b787eb326a83e8b453637ce358d64e75f82b0a9818ce9a13fee9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a9ede30f8c5508755d4bd69a7077dcdf5de41ea3dad8c5d84e0e8d5bbe80dd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41abf1964933c140013642bd17f92ff009376319efd35be71c534edf9a50dda5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4932262d06e3373e152a1b3b47911508ef410bf605ba462157a15fb1f98cbcdf"
    sha256 cellar: :any_skip_relocation, ventura:        "302824e6ee46409592a2de3b6f81a885d78140b7e98397c56970674b2fd29db8"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc95c353037f701004dc0ec8f893e0258682fed495f7159fb2d5541c44dd121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5142819bc23ee7c9a110d0716a766e9032dff2c0e2c7abbc68e0170fca8e743"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

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

  resource "pansi" do
    url "https://files.pythonhosted.org/packages/22/0d/2c19187e820cbad87e73619fe2450d2698eb003eb0a0137551bd687a9676/pansi-2020.7.3.tar.gz"
    sha256 "bd182d504528f870601acb0282aded411ad00a0148427b0e53a12162f4e74dcf"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "py2neo" do
    url "https://files.pythonhosted.org/packages/96/bb/fd298b06181fc4aace4838d91e6b511184ad1f3e5fe9cffee7878c66f14a/py2neo-2021.2.4.tar.gz"
    sha256 "4b2737fcd9fd8d82b57e856de4eda005281c9cf0741c989e5252678f0503f77e"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/80/1f/9d8e98e4133ffb16c90f3b405c43e38d3abb715bb5d7a63a5a684f7e46a3/pytest-7.4.4.tar.gz"
    sha256 "2cf0005922c6ace4a3e2ec8b4080eb0d9753fdc93107415332f50ce9e7994280"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/4a/4c/3c3b766f4ecbb3f0bec91ef342ee98d179e040c25b6ecc99e510c2570f2a/redis-5.0.1.tar.gz"
    sha256 "0dab495cd5753069d3bc650a0dde8a8f9edde16fc5691b689a566eda58100d0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/ee/0f/f9ec7337003e39cdbeba9421f195e0b85d81810ddb6279bfa79a33bcb5a4/slack_sdk-3.26.2.tar.gz"
    sha256 "bcdac5e688fa50e9357ecd00b803b6a8bad766aa614d35d8dc0636f40adc48bf"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
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
