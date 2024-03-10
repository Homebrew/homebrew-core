class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware SSH/GPG agent for Trezor, Keepkey & Ledger"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/11/bc/aa2bdee9cd81af9ecde0a9e8b5c6c6594a4a0ee7ade950b51a39d54f9e63/trezor_agent-0.12.0.tar.gz"
  sha256 "e08ca5a54bd7658017164c8518d6cdf623d3b077dfdccfd12f612af5fef05855"
  license "LGPL-3.0-only"
  revision 2

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8089316592e0200e924cc349870551f8269a2f1fd5427d255a3224d889072621"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b76833e4da4bacca02c2bb53669d474c9bba4b8bdacd0bb116a13f4972bd8ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5daa22524b527a90fba3fdaaed57e86f0728d97bbfe204286da04951f10cd2ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3cfc4b7df2099d63139aa02d06e2dcbe4ce4ca5ffb186904143b114285e168c"
    sha256 cellar: :any_skip_relocation, ventura:        "6ec51d8ee98060ca94d540851975c1ba0a7fdf5ec2e204e809eecb68d6541c0c"
    sha256 cellar: :any_skip_relocation, monterey:       "6f5ccc027bc6408bd7ac051517e33256ab13b18fc5f9f23dcef01a5150d41e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aca7da7281da077231135cf8880eb2088fb06622fdf04093f82a2734e7823c4b"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.12"

  resource "backports-shutil-which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https://files.pythonhosted.org/packages/ab/fe/b67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43f/bech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "bleak" do
    url "https://files.pythonhosted.org/packages/6a/c0/3aca655fa43b8ff5340d99fac4e67061f53f42f092fc847bdd0559d67846/bleak-0.21.1.tar.gz"
    sha256 "ec4a1a2772fb315b992cbaa1153070c7e26968a52b0e2727035f443a1af5c18f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/02/77/8c84b98eca70d245a2a956452f21d57930d22ab88cbeed9290ca630cf03f/construct-2.10.70.tar.gz"
    sha256 "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"
  end

  resource "construct-classes" do
    url "https://files.pythonhosted.org/packages/83/d3/e42d3cc9eab95995d5349ec51f6d638028b9c21e7e8ac6bea056b36438b8/construct-classes-0.1.2.tar.gz"
    sha256 "72ac1abbae5bddb4918688713f991f5a7fb6c9b593646a82f4bf3ac53de7eeb5"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/1f/53/a5da4f2c5739cf66290fac1431ee52aff6851c7c8ffd8264f13affd7bcdd/docutils-0.20.1.tar.gz"
    sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "ecpy" do
    url "https://files.pythonhosted.org/packages/e0/48/3f8c1a252e3a46fd04e6fabc5e11c933b9c39cf84edd4e7c906e29c23750/ECPy-1.2.5.tar.gz"
    sha256 "9635cffb9b6ecf7fd7f72aea1665829ac74a1d272006d0057d45a621aae20228"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/95/0e/c106800c94219ec3e6b483210e91623117bfafcf1decaff3c422e18af349/hidapi-0.14.0.tar.gz"
    sha256 "a7cb029286ced5426a381286526d9501846409701a29c2538615c3d1a612b8be"

    # patch to build with Cython 3+, remove in next release
    patch do
      url "https://github.com/trezor/cython-hidapi/commit/749da6931f57c4c30596de678125648ccfd6e1cd.patch?full_index=1"
      sha256 "e3d70eb9850c7be0fdb0c31bf575b33be5c5848def904760a6ca9f4c3824f000"
    end
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "keepkey" do
    url "https://files.pythonhosted.org/packages/30/38/558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7/keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "keepkey-agent" do
    url "https://files.pythonhosted.org/packages/65/72/4bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110/keepkey_agent-0.9.0.tar.gz"
    sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  end

  resource "ledger-agent" do
    url "https://files.pythonhosted.org/packages/a3/c9/ac7546d6168662af356493231ca8818bdf8ffd05238a68fe5085fd9e6358/ledger_agent-0.9.0.tar.gz"
    sha256 "2265ba9c6a4594ff798fe480856ea36bfe6d8ae7ba2190b74f9666510530f20f"
  end

  resource "ledgerblue" do
    url "https://files.pythonhosted.org/packages/c0/bb/b9d96530f4a94bec5d76116b47e9e7c8dcc362a28b22ad6faa1d25c1d9ec/ledgerblue-0.1.48.tar.gz"
    sha256 "2d544d72c4e624e477cd30616ca578574cc2424d2c93f51fea44a67db02181f6"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/4e/0f/b48045dd9d12eea5c092aaad4c251443384da700c8d85349fc3c554a2320/libagent-0.14.7.tar.gz"
    sha256 "8cea67fbe94216f61dbc22fac9d3d749b41b9cfc11393a76b0b0013c204adb98"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/af/19/53ecbfb96d6832f2272d13b84658c360802fcfff7c0c497ab8f6bf15ac40/libusb1-3.1.0.tar.gz"
    sha256 "4ee9b0a55f8bd0b3ea7017ae919a6c1f439af742c4a4b04543c5fd7af89b828c"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/ff/77/e6232ed59fbd7b90208bb8d4f89ed5aabcf30a524bc2fb8f0dafbe8e7df9/mnemonic-0.21.tar.gz"
    sha256 "1fe496356820984f45559b1540c80ff10de448368929b9c60a2b55744cc88acf"
  end

  resource "ndeflib" do
    url "https://files.pythonhosted.org/packages/58/f8/cd11ec90bd6a6bcf35bb80e4e29fdebe8bf2b05e869a93ca1e41d85518d0/ndeflib-0.3.3.tar.gz"
    sha256 "1d56828558b9b16f2822a4051824346347b66adf5320ea86070748b6f2454a88"
  end

  resource "nfcpy" do
    url "https://files.pythonhosted.org/packages/38/a2/cce3ab796e84bea5098c4231ff56e523cb182c58a21280ccff0d75e693e6/nfcpy-1.0.4.tar.gz"
    sha256 "e5bd08d0119e1d9e95d05215f838b07b44d03b651adddc523cc1a38892b8af6b"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/5e/d8/65adb47d921ce828ba319d6587aa8758da022de509c3862a70177a958844/protobuf-4.25.3.tar.gz"
    sha256 "25b5d0b42fd000320bd7830b349e3b696435f3b329810427a6bcce6a5492cc5c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/ed/19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239/pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/31/a4/b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1/pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pydes" do
    url "https://files.pythonhosted.org/packages/92/5e/0075a35ea5d307a182b0963900298b209ea2f363ccdd5a27e8cb04c58410/pyDes-2.0.1.tar.gz"
    sha256 "e2ab8e21d2b83e90d90dbfdcb6fb8ac0000b813238b7ecaede04f8435c389012"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/84/05/fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8/pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  resource "pymsgbox" do
    url "https://files.pythonhosted.org/packages/7d/ff/4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875/PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/48/d9/a13566ce8914746557b9e8637a5abe1caae86ed202b0fb072029626b8bb1/pyobjc-core-9.2.tar.gz"
    sha256 "d734b9291fec91ff4e3ae38b9c6839debf02b79c07314476e87da8e90b2c68c3"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/38/91/c54fdffda6d7cfad67ff617f19001163658d50bc72376d1584e691cf4895/pyobjc-framework-Cocoa-9.2.tar.gz"
    sha256 "efd78080872d8c8de6c2b97e0e4eac99d6203a5d1637aa135d071d464eb2db53"
  end

  resource "pyobjc-framework-corebluetooth" do
    url "https://files.pythonhosted.org/packages/f1/7a/239d5b1ac63056bb3e754c1f189f3e17051f3d2c3368c339d15b34f2ac48/pyobjc-framework-CoreBluetooth-9.2.tar.gz"
    sha256 "cb2481b1dfe211ae9ce55f36537dc8155dbf0dc8ff26e0bc2e13f7afb0a291d1"
  end

  resource "pyobjc-framework-libdispatch" do
    url "https://files.pythonhosted.org/packages/f1/73/455a8b92d3fc5b47b22e8055b6df19be96b2aa13715676e70a9cb7ed00b2/pyobjc-framework-libdispatch-9.2.tar.gz"
    sha256 "542e7f7c2b041939db5ed6f3119c1d67d73ec14a996278b92485f8513039c168"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/84/50/97b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205a/python-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "python-gnupg" do
    url "https://files.pythonhosted.org/packages/b1/5d/4425390ad81d22b330a1b0df204c4d39fb3cb7c39e081d51e9f7426ce716/python-gnupg-0.5.2.tar.gz"
    sha256 "01d8013931c9fa3f45824bbea7054c03d6e11f258a72e7e086e168dbcb91854c"
  end

  resource "python-u2flib-host" do
    url "https://files.pythonhosted.org/packages/4d/3d/0997fe8196f5be24b7015708a0744a0ef928c4fb3c8bc820dc3328208ef2/python-u2flib-host-3.0.3.tar.gz"
    sha256 "ab678b9dc29466a779efcaa2f0150dce35059a7d17680fc26057fa599a53fc0a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "trezor" do
    url "https://files.pythonhosted.org/packages/8e/82/831de0a643401c4dcfbbc17c33de35b8c3d23281ac60a0831be5f10838d3/trezor-0.13.8.tar.gz"
    sha256 "634d4eddf35603257c321618d8548c6a35b27384657b65e3b0bdbad635a57cff"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/f7/89/19151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3e/Unidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  def install
    ENV.append "CFLAGS", "-I#{Formula["libusb"].include}/libusb-1.0"
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| OS.mac? ? r.name == "dbus-fast" : r.name.start_with?("pyobjc") }
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("#{bin}/trezor-agent identity@myhost 2>&1", 1)
    assert_match "Trezor not connected", output
  end
end
