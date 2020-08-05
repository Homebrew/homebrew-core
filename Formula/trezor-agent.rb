class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware SSH/GPG agent for Trezor, Keepkey & Ledger"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/f1/a7/8989377dfce48abf9115055baf6d2cfba55102929a7c5f3e5b9c8e8b5c18/trezor_agent-0.11.0.tar.gz"
  sha256 "139d917d6495bf290bcc21da457f84ccd2e74c78b4d59a649e0cdde4288cd20c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9482a60c735039a2c62c221e2976680a726e2d5fd3fe703486881a73f4206e3a" => :catalina
    sha256 "a6d1e6ba68f9e240d3a5577fcdcbf7df3b6e18fe5c2fa78cb587ad905c2a894e" => :mojave
    sha256 "71454920f5460eb56b1a2c10bb3818967d117a080bab61e8bf8bb1f9eb8e4de2" => :high_sierra
  end

  depends_on "libusb"
  depends_on "python@3.8"

  # Gather dependencies for trezor-agent, ledger-agent & keepkey-agent

  resource "backports.shutil_which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/bb/79/3045743bb26ca2e44a1d317c37395462bfed82dbbd38e69a3280b63696ce/ConfigArgParse-1.2.3.tar.gz"
    sha256 "edd17be986d5c1ba2e307150b8e5f5107aba125f3574dddd02c85d5cdcfd37dc"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/00/e0/71e41b817220333c7c511c3f78d988d69f9b03b5cca2f251a898ad3567a3/construct-2.10.56.tar.gz"
    sha256 "97ba13edcd98546f10f7555af41c8ce7ae9d8221525ec4062c03f9adbf940661"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/e3/7c/b508ade1feb47cd79222e06d85e477f5cfc4fb0455ad3c70eb6330fc49aa/ecdsa-0.15.tar.gz"
    sha256 "8f12ac317f8a1318efa75757ef0a651abe12e51fc1af8838fb91079445227277"
  end

  resource "ECPy" do
    url "https://files.pythonhosted.org/packages/a3/5f/dfed65c95348a6553663257bce82dcf66a79f8e7dfdfd090b5b9e191a34d/ECPy-1.2.3.tar.gz"
    sha256 "6dd09f8cda5a1d673228ff9ef41aea8f036ee5ef3183198de83c14957d68c3e0"
  end

  resource "ed25519" do
    url "https://files.pythonhosted.org/packages/58/38/72ec85c953b90552fb015f31248256ef19e89a164a40ff8fef680259a608/ed25519-1.5.tar.gz"
    sha256 "02053ee019ceef0df97294be2d4d5a8fc120fc86e81e08bec1245fc0f9403358"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/7c/a0/d5ca6f191c8860a4769ba19448d2b2d6b3e2ca2c30aa61bb96a3f6bd25ba/hidapi-0.9.0.post2.tar.gz"
    sha256 "a71dd3c153cb6bb2b73d2612b5ab262830d78c6428f33f0c06818749e64c9320"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "keepkey" do
    url "https://files.pythonhosted.org/packages/30/38/558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7/keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "keepkey_agent" do
    url "https://files.pythonhosted.org/packages/65/72/4bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110/keepkey_agent-0.9.0.tar.gz"
    sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  end

  resource "ledger_agent" do
    url "https://files.pythonhosted.org/packages/a3/c9/ac7546d6168662af356493231ca8818bdf8ffd05238a68fe5085fd9e6358/ledger_agent-0.9.0.tar.gz"
    sha256 "2265ba9c6a4594ff798fe480856ea36bfe6d8ae7ba2190b74f9666510530f20f"
  end

  resource "ledgerblue" do
    url "https://files.pythonhosted.org/packages/ba/7e/9a21deb5f803835addd5674326b219fe3493e54346ba3d7d1aa6071d4310/ledgerblue-0.1.31.tar.gz"
    sha256 "f1fc7ab685780309a7220c6ee517d88072cc594a9615bcc18e68ed5f149fa432"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/11/5e/c4715308ffe45c80af92ff0f45fe8e2964ee01f0a7b380c74cedf1e48da2/libagent-0.14.1.tar.gz"
    sha256 "dc979a564cb68cf7c6fa235bf747eb4555deb84f3a8d716940a1709377f140e7"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/80/bb/4ee9d760dd29499d877ee384f1d2bc6bb9923defd4c69843aef5e729972d/libusb1-1.7.1.tar.gz"
    sha256 "adf64a4f3f5c94643a1286f8153bcf4bc787c348b38934aacd7fe17fbeebc571"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/80/0d/63de5efd5585fd6eb79eb35d3feb91deee8003e60997d61e3759eaf1ea66/mnemonic-0.19.tar.gz"
    sha256 "4e37eb02b2cbd56a0079cabe58a6da93e60e3e4d6e757a586d9f23d96abea931"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c9/d5/e6e789e50e478463a84bd1cdb45aa408d49a2e1aaffc45da43d10722c007/protobuf-3.11.3.tar.gz"
    sha256 "c77c974d1dadf246d789f6dad1c24426137c9091e930dbf50e0a29c1fcf00b1f"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/7f/3c/80cfaec41c3a9d0f524fe29bca9ab22d02ac84b5bfd6e22ade97d405bdba/pycryptodomex-3.9.7.tar.gz"
    sha256 "50163324834edd0c9ce3e4512ded3e221c969086e10fdd5d3fdcaadac5e24a78"
  end

  resource "PyMsgBox" do
    url "https://files.pythonhosted.org/packages/ac/e0/0ac1ac67178a71b92e46f46788ddd799bb40bff40acd60c47c50be170374/PyMsgBox-1.0.7.tar.gz"
    sha256 "7df5ed66c8a80fd36b83b278ba164e7a1d135c8fb8bdf38b291e46bf31d28085"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/05/97/210f94322675c838319ffa8e505032373ff1f6a6219af8d16427e00b1051/python-daemon-2.2.4.tar.gz"
    sha256 "57c84f50a04d7825515e4dbf3a31c70cc44414394a71608dee6cfde469e81766"
  end

  resource "python-u2flib-host" do
    url "https://files.pythonhosted.org/packages/4d/3d/0997fe8196f5be24b7015708a0744a0ef928c4fb3c8bc820dc3328208ef2/python-u2flib-host-3.0.3.tar.gz"
    sha256 "ab678b9dc29466a779efcaa2f0150dce35059a7d17680fc26057fa599a53fc0a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/7a/f6/caeed415475f817542307b09fd80ed2c5f2d167be86e692d3d7b52222a46/semver-2.9.1.tar.gz"
    sha256 "723be40c74b6468861e0e3dbb80a41fc3b171a2a45bf956c245304773dc06055"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "trezor" do
    url "https://files.pythonhosted.org/packages/d1/8d/f467c7a01f858a668940aadd160cee78505025a6ae73fa8bb3d685a45e2c/trezor-0.12.0.tar.gz"
    sha256 "f6bc821bddec06e67a1abd0be1d9fbc61c59b08272c736522ae2f6b225bf9579"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/6a/28/d32852f2af6b5ead85d396249d5bdf450833f3a69896d76eb480d9c5e406/typing_extensions-3.7.4.2.tar.gz"
    sha256 "79ee589a3caca649a9bfd2a8de4709837400dfa00b6cc81962a1e6a1815969ae"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/b1/d6/7e2a98e98c43cf11406de6097e2656d31559f788e9210326ce6544bd7d40/Unidecode-1.1.1.tar.gz"
    sha256 "2b6aab710c2a1647e928e36d69c21e76b453cd455f4e2621000e54b2a9b8cce8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/8b/0f/52de51b9b450ed52694208ab952d5af6ebbcbce7f166a48784095d930d8c/websocket_client-0.57.0.tar.gz"
    sha256 "d735b91d6d1692a6a181f2a8c9e0238e5f6373356f561bb9dc4c7af36f452010"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/trezor-agent identity@myhost 2>&1", 1)
    assert_match "Trezor not connected", output
  end
end
