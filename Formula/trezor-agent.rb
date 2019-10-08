class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware SSH/GPG agent for Trezor, Keepkey & Ledger"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/61/33/eb639bced493984170e1ec3cf149b06b9f4cd05886f667a3eb0e1f94396b/trezor_agent-0.10.0.tar.gz"
  sha256 "e82bf000c1178b1a7612f2a90487eb34c6234d2edb15dc8e310ad875d8298690"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ebab61a0624369d7c1a0704b683a11403fdd88eb38e89bb2b1d4391679d29974" => :mojave
    sha256 "18fc1f52a8727b8296c18d1187df0a65898a7e53dc08edc64a09a8d3631e3009" => :high_sierra
    sha256 "a2094afbbae63c2fcead69c854581720ccf878557ae6346fbb24457772c0e47b" => :sierra
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
    url "https://files.pythonhosted.org/packages/e1/0f/f8d5e939184547b3bdc6128551b831a62832713aa98c2ccdf8c47ecc7f17/certifi-2018.8.24.tar.gz"
    sha256 "376690d6f16d32f9d1fe8932551d80b23e9d393a8578c5633a2ed39a64861638"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/19/c0/f054941fa33d14378de66d2c0477d31f7ad97aa2e298a5771a7b20bc2039/construct-2.9.45.tar.gz"
    sha256 "2271a0efd0798679dea825ff47e22a4c550456a5db0ba8baa82f7eae0af0118c"
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
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "keepkey-agent" do
    url "https://files.pythonhosted.org/packages/65/72/4bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110/keepkey_agent-0.9.0.tar.gz"
    sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  end

  resource "ledger-agent" do
    url "https://files.pythonhosted.org/packages/a3/c9/ac7546d6168662af356493231ca8818bdf8ffd05238a68fe5085fd9e6358/ledger_agent-0.9.0.tar.gz"
    sha256 "2265ba9c6a4594ff798fe480856ea36bfe6d8ae7ba2190b74f9666510530f20f"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/9b/13/5e3e78890a66be778f448998368d7a17be704358a2036788a1480fe73f1c/libagent-0.13.1.tar.gz"
    sha256 "b9afa0851f668612702fcd648cee47af4dc7cfe4f86d4c4a84b1a6b4a4960b41"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/39/c6/a9c8c38e3a8a587cd5c32146a5156375e107e483eb2ccb80284a147921dd/libusb1-1.6.6.tar.gz"
    sha256 "a49917a2262cf7134396f6720c8be011f14aabfc5cdc53f880cc672c0f39d271"
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
    url "https://files.pythonhosted.org/packages/1b/90/f531329e628ff34aee79b0b9523196eb7b5b6b398f112bb0c03b24ab1973/protobuf-3.6.1.tar.gz"
    sha256 "1489b376b0f364bcc6f89519718c057eb191d7ad6f1b395ffd93d1aa45587811"
  end

  resource "pyblake2" do
    url "https://files.pythonhosted.org/packages/a6/ea/559658f48713567276cabe1344a9ef918adcb34a9da417dbf0a2f7477d8e/pyblake2-1.1.2.tar.gz"
    sha256 "5ccc7eb02edb82fafb8adbb90746af71460fbc29aa0f822526fc976dff83e93f"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/99/2a/75fe6aa7086e838570f29899f674e7896a42be26d9fff33f90d990e599d2/python-daemon-2.2.0.tar.gz"
    sha256 "aca149ebf7e73f10cd554b2df5c95295d49add8666348eff6195053ec307728c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/01/aa/475f96f82d3d91e6f9e434ad465069e4b031665df048050fab70385ad1c9/rlp-1.0.2.tar.gz"
    sha256 "040fb5172fa23d27953a886c40cac989fc031d0629db934b5a9edcd2fb28df1e"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/47/13/8ae74584d6dd33a1d640ea27cd656a9f718132e75d759c09377d10d64595/semver-2.8.1.tar.gz"
    sha256 "5b09010a66d9a3837211bb7ae5a20d10ba88f8cb49e92cb139a69ef90d5060d8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "trezor" do
    url "https://files.pythonhosted.org/packages/88/9e/9b84a35c3709cda7b35a211dc9617f38740eb2d3a46a20a1087efb795302/trezor-0.11.3.tar.gz"
    sha256 "c79a500e90d003073c8060d319dceb042caaba9472f13990c77ed37d04a82108"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/fa/aa/229f5c82d17d10d4ef318b5c22a8626a1c78fc97f80d3307035cf696681b/typing_extensions-3.7.2.tar.gz"
    sha256 "fb2cd053238d33a8ec939190f30cfd736c00653a85a2919415cecf7dc3d9da71"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/trezor-agent identity@myhost 2>&1", 1)
    assert_match "Trezor not connected", output
  end
end
