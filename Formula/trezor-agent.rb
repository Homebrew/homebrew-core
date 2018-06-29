class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware-based SSH/GPG agent"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/54/89/6de88988f9efa712cb7131cf3123a2a043c7956ee66e725b14a1ea4c27ec/trezor_agent-0.9.2.tar.gz"
  sha256 "d7756759ab9bb6700007423e58cb20f26effd0271c26f7a43c0a92c0fa487ede"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ff4b2a030026867a0895f99d63a5a1010cf8b1699b093c91e99b92e1d2cd8744" => :high_sierra
    sha256 "a9c354d429d49c1fabd255f18548f03967f086f136de8ab8a7bef0eb4e7efbb8" => :sierra
    sha256 "2da90be8d971b100a37ad9b6e64d64e3ced33a86c79a940e2e912f86d1bc4682" => :el_capitan
  end

  depends_on "libusb"
  depends_on "python"

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/77/61/ae928ce6ab85d4479ea198488cf5ffa371bd4ece2030c0ee85ff668deac5/ConfigArgParse-0.13.0.tar.gz"
    sha256 "e6441aa58e23d3d122055808e5e2220fd742dff6e1e51082d2a4e4ed145dd788"
  end

  resource "PyMsgBox" do
    url "https://files.pythonhosted.org/packages/b6/65/86379ede1db26c40e7972d7a41c69cdf12cc6a0f143749aabf67ab8a41a1/PyMsgBox-1.0.6.zip"
    sha256 "3888116a60812d01d44529c402014bf0896d2a9262617cb18faa9a7b3800ad4e"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/9d/36/49d0ee152b6a1631f03a541532c6201942430060aa97fe011cf01a2cce64/Unidecode-1.0.22.tar.gz"
    sha256 "8c33dd588e0c9bc22a76eaa0c715a5434851f726131bd44a6c26471746efabf5"
  end

  resource "backports.shutil_which" do
    url "https://files.pythonhosted.org/packages/dd/ea/715dc80584207a0ff4a693a73b03c65f087d8ad30842832b9866fe18cb2f/backports.shutil_which-3.5.1.tar.gz"
    sha256 "dd439a7b02433e47968c25a45a76704201c4ef2167deb49830281c379b1a4a9b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "ed25519" do
    url "https://files.pythonhosted.org/packages/d5/d6/cd19a64022dc7557d245aad6a943eed7693189b48c58a9adf3bc00ceedc5/ed25519-1.4.tar.gz"
    sha256 "2991b94e1883d1313c956a1e3ced27b8a2fdae23ac40c0d9d0b103d5a70d1d2a"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/c1/86/89df0e8890f96eeb5fb68d4ccb14cb38e2c2d2cfd7601ba972206acd9015/hidapi-0.7.99.post21.tar.gz"
    sha256 "e0be1aa6566979266a8fc845ab0e18613f4918cf2c977fe67050f5dc7e2a9a97"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/63/57/39df4b80036657c9d57a17fe94902965a20543569e9bef0bb7cd89e8fa4a/libagent-0.11.2.tar.gz"
    sha256 "51f36116dacab1df8672a876bb2ddbf08a717e0afc8276406bd23aeda79d5030"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/ec/5d/4fdac6c53525786fe35cff035c3345452e24e2bee5627893be65d12555cb/libusb1-1.6.4.tar.gz"
    sha256 "8c930d9c1d037d9c83924c82608aa6a1adcaa01ca0e4a23ee0e8e18d7eee670d"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/a4/5a/663362ccceb76035ad50fbc20203b6a4674be1fe434886b7407e79519c5e/mnemonic-0.18.tar.gz"
    sha256 "02a7306a792370f4a0c106c2cf1ce5a0c84b9dbd7e71c6792fdb9ad88a727f1d"
  end

  resource "pbkdf2" do
    url "https://files.pythonhosted.org/packages/02/c0/6a2376ae81beb82eda645a091684c0b0becb86b972def7849ea9066e3d5e/pbkdf2-1.3.tar.gz"
    sha256 "ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/14/03/ff5279abda7b46e9538bfb1411d42831b7e65c460d73831ed2445649bc02/protobuf-3.5.1.tar.gz"
    sha256 "95b78959572de7d7fafa3acb718ed71f482932ddddddbd29ba8319c10639d863"
  end

  resource "pyblake2" do
    url "https://files.pythonhosted.org/packages/cc/a6/3fa4c5cd5c3f590187cc31e5d5089332fb46c3a9912a28d5c44d34268cd4/pyblake2-1.1.0.tar.gz"
    sha256 "3a850036bf42053c74bfc52c063323ca78e40ba1f326b01777da5750a143631a"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/b2/fb/a280d65f81e9d69989c8d6c4e0bb18d7280cdcd6d406a2cc3f4eb47d4402/python-daemon-2.1.2.tar.gz"
    sha256 "261c859be5c12ae7d4286dc6951e87e9e1a70a882a8b41fd926efc1ec4214f73"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/f9/53/922c7a15116e52cd7340f81b83322d5ec9d38668cd78d1a0c7e75dfce8f2/rlp-0.6.0.tar.gz"
    sha256 "87879a0ba1479b760cee98af165de2eee95258b261faa293199f60742be96f34"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/40/56/d1f930872436300b474a447a8042091bd335119f0c58bd8647546d6c3dc0/semver-2.7.9.tar.gz"
    sha256 "1ffb55fb86a076cf7c161e6b5931f7da59f15abe217e0f24cea96cc8eec50f42"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "trezor" do
    url "https://files.pythonhosted.org/packages/26/46/b78ba738beea1d451a9f88b55edde8d1fac1049b69157aeaf12390ec00b6/trezor-0.9.1.tar.gz"
    sha256 "a481191011bade98f1e9f1201e7c72a83945050657bbc90dc4ac32dc8b8b46a4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/trezor-agent identity@myhost 2>&1", 1)
    assert_match "Trezor not connected", output
  end
end
