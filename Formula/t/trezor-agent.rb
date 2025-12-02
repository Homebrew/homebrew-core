class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware SSH/GPG agent for Trezor and Ledger"
  homepage "https://github.com/romanz/trezor-agent"
  # NOTE: On version bumps, check if `bleak`'s OS-specific extra_packages need to be updated.
  # These are required to avoid losing resources since the packages are resolved based on native OS.
  # Ref: https://github.com/hbldh/bleak/blob/develop/pyproject.toml#L28-L40
  url "https://files.pythonhosted.org/packages/11/bc/aa2bdee9cd81af9ecde0a9e8b5c6c6594a4a0ee7ade950b51a39d54f9e63/trezor_agent-0.12.0.tar.gz"
  sha256 "e08ca5a54bd7658017164c8518d6cdf623d3b077dfdccfd12f612af5fef05855"
  license "LGPL-3.0-only"
  revision 7

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eacf3b2cc29eb355e0e86ba40df6005aa8f1aa8e39419500a22cc2b557377773"
    sha256 cellar: :any,                 arm64_sequoia: "73a1579e72b264ebd779ecf359d286aecb62319983c451bc8eb7aa7c3c0a0ef0"
    sha256 cellar: :any,                 arm64_sonoma:  "37527d676d0ed75edf43729ca9b40c27cdeadd9d90145777377eb1457b819942"
    sha256 cellar: :any,                 sonoma:        "4731593bbf393c868553a5209027a4503263b557e7806cdbcf50d9103d0cf835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d502901f599f98daae8babce06856edb473691259576a0184ffb29f2cf0d0ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822b6ca6e8131a09891ff37fe50f61eb437f44f2a3b58661e54c2957a0c58654"
  end

  depends_on "pkgconf" => :build # for hidapi resource
  depends_on "rust" => :build # for construct-classes
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "hidapi"
  depends_on "libsodium" # for pynacl
  depends_on "libusb" # for libusb1
  depends_on "pillow"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  pypi_packages exclude_packages: ["certifi", "cryptography", "pillow"],
                extra_packages:   %w[
                  dbus-fast ledger-agent pyobjc-core
                  pyobjc-framework-CoreBluetooth pyobjc-framework-libdispatch
                ]

  resource "backports-shutil-which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "base58" do
    url "https://files.pythonhosted.org/packages/7f/45/8ae61209bb9015f516102fa559a2914178da1d5868428bd86a1b4421141d/base58-2.1.1.tar.gz"
    sha256 "c5d0cb3f5b6e81e8e35da5754388ddcc6d0d14b6c6a132cb93d69ed580a7278c"
  end

  resource "bech32" do
    url "https://files.pythonhosted.org/packages/ab/fe/b67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43f/bech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "bleak" do
    url "https://files.pythonhosted.org/packages/10/88/6bb2bcb94ef7a2f37c5bd5ec99a4ae9208c4caa3fa6d203f9b601e047e64/bleak-1.1.1.tar.gz"
    sha256 "eeef18053eb3bd569a25bff62cd4eb9ee56be4d84f5321023a7c4920943e6ccb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/02/77/8c84b98eca70d245a2a956452f21d57930d22ab88cbeed9290ca630cf03f/construct-2.10.70.tar.gz"
    sha256 "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"
  end

  resource "construct-classes" do
    url "https://files.pythonhosted.org/packages/75/6f/e2e98ed52e94fd9db21a7f816061e0d47fef9b13077b5a9940a7b55e0b98/construct_classes-0.2.2.tar.gz"
    sha256 "c644026fef4d082fd6632efa974376d77e8be7d95e4e57a6df74407fc0954efd"
  end

  resource "dbus-fast" do
    url "https://files.pythonhosted.org/packages/1b/f9/3952e3514244417a33643087bc5dc134aff546606d5f66f796018cb7fdfc/dbus_fast-2.44.5.tar.gz"
    sha256 "e9d738e3898e2d505d7f2d5d21949bd705d7cd3d7240dda5481bb1c5fd5e3da8"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4a/c0/89fe6215b443b919cb98a5002e107cb5026854ed1ccb6b5833e0768419d1/docutils-0.22.2.tar.gz"
    sha256 "9fdb771707c8784c8f2728b67cb2c691305933d68137ef95a75db5f4dfbc213d"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/c0/1f/924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46a/ecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
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
    url "https://files.pythonhosted.org/packages/47/72/21ccaaca6ffb06f544afd16191425025d831c2a6d318635e9c8854070f2d/hidapi-0.14.0.post4.tar.gz"
    sha256 "48fce253e526d17b663fbf9989c71c7ef7653ced5f4be65f1437c313fb3dbdf6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ledger-agent" do
    url "https://files.pythonhosted.org/packages/a3/c9/ac7546d6168662af356493231ca8818bdf8ffd05238a68fe5085fd9e6358/ledger_agent-0.9.0.tar.gz"
    sha256 "2265ba9c6a4594ff798fe480856ea36bfe6d8ae7ba2190b74f9666510530f20f"
  end

  resource "ledgerblue" do
    url "https://files.pythonhosted.org/packages/a9/2b/acdc7792de33a63bc723a21ff2d4350d55ad1bfd388de17a7343b251b03b/ledgerblue-0.1.55.tar.gz"
    sha256 "eacd95f1c5e293a8c483ccf750ae3da95c2874f6f05cc2245a4ee227b398d2b3"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/33/9f/d80eb0568f617d4041fd83b8b301fdb817290503ee4c1546024df916454e/libagent-0.15.0.tar.gz"
    sha256 "c87caebdb932ed42bcd8a8cbe40ce3589587c71c3513ca79cadf7a040e24b4eb"

    # Backport replacement of pkg_resources to fix issue seen on arm64 linux
    patch do
      url "https://github.com/romanz/trezor-agent/commit/68e39c14216f466c8710bf65ef133c744f8f92da.patch?full_index=1"
      sha256 "a2b2279ba0eaf7a11d2a2e1f79155829bc8939942848b01602062f6c269b68b0"
    end
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/a2/7f/c59ad56d1bca8fa4321d1bb77ba4687775751a4deceec14943a44da18ca0/libusb1-3.3.1.tar.gz"
    sha256 "3951d360f2daf0e0eacf839e15d2d1d2f4f5e7830231eb3188eeffef2dd17bad"
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
    url "https://files.pythonhosted.org/packages/fa/a4/cc17347aa2897568beece2e674674359f911d6fe21b0b8d6268cd42727ac/protobuf-6.32.1.tar.gz"
    sha256 "ee2469e4a021474ab9baafea6cd070e5bf27c7d29433504ddea1a4ee5850f68d"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pydes" do
    url "https://files.pythonhosted.org/packages/92/5e/0075a35ea5d307a182b0963900298b209ea2f363ccdd5a27e8cb04c58410/pyDes-2.0.1.tar.gz"
    sha256 "e2ab8e21d2b83e90d90dbfdcb6fb8ac0000b813238b7ecaede04f8435c389012"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/b9/ab/33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071af/pyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pymsgbox" do
    url "https://files.pythonhosted.org/packages/ae/6a/e80da7594ee598a776972d09e2813df2b06b3bc29218f440631dfa7c78a8/pymsgbox-2.0.1.tar.gz"
    sha256 "98d055c49a511dcc10fa08c3043e7102d468f5e4b3a83c6d3c61df722c7d798d"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/e8/e9/0b85c81e2b441267bca707b5d89f56c2f02578ef8f3eafddf0e0c0b8848c/pyobjc_core-11.1.tar.gz"
    sha256 "b63d4d90c5df7e762f34739b39cc55bc63dbcf9fb2fb3f2671e528488c7a87fe"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/4b/c5/7a866d24bc026f79239b74d05e2cf3088b03263da66d53d1b4cf5207f5ae/pyobjc_framework_cocoa-11.1.tar.gz"
    sha256 "87df76b9b73e7ca699a828ff112564b59251bb9bbe72e610e670a4dc9940d038"
  end

  resource "pyobjc-framework-corebluetooth" do
    url "https://files.pythonhosted.org/packages/3d/fe/2081dfd9413b7b4d719935c33762fbed9cce9dc06430f322d1e2c9dbcd91/pyobjc_framework_corebluetooth-11.1.tar.gz"
    sha256 "1deba46e3fcaf5e1c314f4bbafb77d9fe49ec248c493ad00d8aff2df212d6190"
  end

  resource "pyobjc-framework-libdispatch" do
    url "https://files.pythonhosted.org/packages/be/89/7830c293ba71feb086cb1551455757f26a7e2abd12f360d375aae32a4d7d/pyobjc_framework_libdispatch-11.1.tar.gz"
    sha256 "11a704e50a0b7dbfb01552b7d686473ffa63b5254100fdb271a1fe368dd08e87"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/3d/37/4f10e37bdabc058a32989da2daf29e57dc59dbc5395497f3d36d5f5e2694/python_daemon-3.1.2.tar.gz"
    sha256 "f7b04335adc473de877f5117e26d5f1142f4c9f7cd765408f0877757be5afbf4"
  end

  resource "python-gnupg" do
    url "https://files.pythonhosted.org/packages/42/d0/72a14a79f26c6119b281f6ccc475a787432ef155560278e60df97ce68a86/python-gnupg-0.5.5.tar.gz"
    sha256 "3fdcaf76f60a1b948ff8e37dc398d03cf9ce7427065d583082b92da7a4ff5a63"
  end

  resource "python-u2flib-host" do
    url "https://files.pythonhosted.org/packages/4d/3d/0997fe8196f5be24b7015708a0744a0ef928c4fb3c8bc820dc3328208ef2/python-u2flib-host-3.0.3.tar.gz"
    sha256 "ab678b9dc29466a779efcaa2f0150dce35059a7d17680fc26057fa599a53fc0a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "shamir-mnemonic" do
    url "https://files.pythonhosted.org/packages/b2/fd/9f5b305b5280795209817efe6b0cd6017f4714e3f36d160b2d4dfcc78c02/shamir_mnemonic-0.3.0.tar.gz"
    sha256 "bc04886a1ddfe2a64d8a3ec51abf0f664d98d5b557cc7e78a8ad2d10a1d87438"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "slip10" do
    url "https://files.pythonhosted.org/packages/7b/30/6ba9170f06c61f82b4f66bacefd13819a295798f959027a0600211d8f7ad/slip10-1.0.1.tar.gz"
    sha256 "02b350ae557b591791428b17551f95d7ac57e9211f37debdc814c90b4a123a54"
  end

  resource "trezor" do
    url "https://files.pythonhosted.org/packages/c2/11/bd2ff7f6ff07cdd739b27de64398e9772ceaef59e0ee1341f4bb4a571794/trezor-0.13.10.tar.gz"
    sha256 "7a0b6ae4628dd0c31a5ceb51258918d9bbdd3ad851388837225826b228ee504f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    without = if OS.mac?
      # needed for pyobjc-core "-fdisable-block-signature-string"
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699

      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      ["dbus-fast"]
    else
      resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end
    virtualenv_install_with_resources(without:)
  end

  test do
    output = shell_output("#{bin}/trezor-agent identity@myhost 2>&1", 1)
    assert_match "Trezor not connected", output

    # Check versions of resources as resolver may not pick correct versions of non-OS extra packages
    system libexec/"bin/python", "-m", "pip", "check"
  end
end
