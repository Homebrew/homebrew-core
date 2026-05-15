class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware SSH/GPG agent for Trezor and Ledger"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/d9/b1/e533c417259dc112a067226d4c95cb772d7c090b696a61a065e1e41429d6/trezor_agent-0.13.0.tar.gz"
  sha256 "f3324a7c5708db0e40682e272720f5d9e9dac7b62281ee740ee7825e6a23e8ff"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20a651a1adb054a11c1d01cde22dbab462bb48071304816e7c4e8284a9523290"
    sha256 cellar: :any,                 arm64_sequoia: "4715530fb5825581493de331775260a9adf789aa7ae9b40a1dae2f514c28d5f6"
    sha256 cellar: :any,                 arm64_sonoma:  "a4beff2fc5948dd0dda0ff22f7229367b66b4e2a2b90a79bff7c5c7285d2441f"
    sha256 cellar: :any,                 sonoma:        "c9999f244913227da026a46ae71ac3762517d81aa92f76a74d43ac8f07b47c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d80adf7d9b744c38c9815019b02c4b3f393af724cef3ded3b273167e13beafce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b80208824b06c6d227ae528bcc9ac83f1f86a4c4d686ddf35fae4be1af629a5"
  end

  depends_on "pkgconf" => :build # for hidapi resource
  depends_on "rust" => :build # for construct-classes
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "hidapi"
  depends_on "libsodium" # for pynacl
  depends_on "libusb" # for libusb1
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography],
                extra_packages:   %w[jeepney secretstorage]

  resource "backports-shutil-which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https://files.pythonhosted.org/packages/ab/fe/b67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43f/bech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3f/0b/30328302903c55218ffc5199646d0e9d28348ff26c02ba77b2ffc58d294a/configargparse-1.7.5.tar.gz"
    sha256 "e3f9a7bb6be34d66b2e3c4a2f58e3045f8dfae47b0dc039f87bcfaa0f193fb0f"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/02/77/8c84b98eca70d245a2a956452f21d57930d22ab88cbeed9290ca630cf03f/construct-2.10.70.tar.gz"
    sha256 "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"
  end

  resource "construct-classes" do
    url "https://files.pythonhosted.org/packages/75/6f/e2e98ed52e94fd9db21a7f816061e0d47fef9b13077b5a9940a7b55e0b98/construct_classes-0.2.2.tar.gz"
    sha256 "c644026fef4d082fd6632efa974376d77e8be7d95e4e57a6df74407fc0954efd"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/b6/03bb70946330e88ffec97aefd3ea75ba575cb2e762061e0e62a213befee8/docutils-0.22.4.tar.gz"
    sha256 "4db53b1fde9abecbb74d91230d32ab626d94f6badfc575d6db9194a49df29968"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/25/ca/8de7744cb3bc966c85430ca2d0fcaeea872507c6a4cf6e007f7fe269ed9d/ecdsa-0.19.2.tar.gz"
    sha256 "62635b0ac1ca2e027f82122b5b81cb706edc38cd91c63dda28e4f3455a2bf930"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/74/f6/caad9ed701fbb9223eb9e0b41a5514390769b4cb3084a2704ab69e9df0fe/hidapi-0.15.0.tar.gz"
    sha256 "ecbc265cbe8b7b88755f421e0ba25f084091ec550c2b90ff9e8ddd4fcd540311"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/01/f8/c8759b7ed2b8b42a83c9989d37ad4d0594960593067cca40acc560cf4d37/libagent-0.16.1.tar.gz"
    sha256 "7132c11100e53d3a54cb276fe9d03577c61c8c357025e2716de0812bd94f2763"
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

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "noiseprotocol" do
    url "https://files.pythonhosted.org/packages/76/17/fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95/noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pymsgbox" do
    url "https://files.pythonhosted.org/packages/ae/6a/e80da7594ee598a776972d09e2813df2b06b3bc29218f440631dfa7c78a8/pymsgbox-2.0.1.tar.gz"
    sha256 "98d055c49a511dcc10fa08c3043e7102d468f5e4b3a83c6d3c61df722c7d798d"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/3d/37/4f10e37bdabc058a32989da2daf29e57dc59dbc5395497f3d36d5f5e2694/python_daemon-3.1.2.tar.gz"
    sha256 "f7b04335adc473de877f5117e26d5f1142f4c9f7cd765408f0877757be5afbf4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
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
    url "https://files.pythonhosted.org/packages/dd/7a/744be94761ace101a8efc91c467cae673da68bea7e4eb50771cd5583119d/slip10-1.1.0.tar.gz"
    sha256 "d248d3df26f123f08474339c45f0f264254f74ae9a5657234a1d5eb91f0c4d54"
  end

  resource "trezor" do
    url "https://files.pythonhosted.org/packages/91/b4/8f7ac04be8942f088f724598752b1f348b3f6f819efad75f82602ec3781c/trezor-0.20.0.tar.gz"
    sha256 "4c098e20315b2716673abdef402822e7189101598c7c03f23749dd2010ee2504"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/89/24/a2eb353a6edac9a0303977c4cb048134959dd2a51b48a269dfc9dde00c8a/wheel-0.46.3.tar.gz"
    sha256 "e3e79874b07d776c40bd6033f8ddf76a7dad46a7b8aa1b2787a83083519a1803"
  end

  def install
    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)
  end

  test do
    output = shell_output("#{bin}/trezor-agent identity@myhost 2>&1", 1)
    assert_match "No Trezor device found", output

    # Check versions of resources as resolver may not pick correct versions of non-OS extra packages
    system libexec/"bin/python", "-m", "pip", "check"
  end
end
