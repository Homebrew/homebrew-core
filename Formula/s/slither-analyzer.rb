class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/1d/62/6963e21c75a783de0683fe9267c827a93dc5294dcc0001bf52bf3a9ff809/slither-analyzer-0.10.1.tar.gz"
  sha256 "b99b81dfe949238e15e48d2ca9b3e756144a194f3a25c7d61c22712b2f99e9a6"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6a1eec5ed8118668ca30d9aa4e94f8f9981526b638bb1856ab4da8fd424ae69"
    sha256 cellar: :any,                 arm64_ventura:  "71ca0283e84bcd93dfa9d5265867e5f66f2682ac716471ed4ce687e6461948e4"
    sha256 cellar: :any,                 arm64_monterey: "1358384a66b3d2ef4dc2b6f35cd5e4d8293340d08503b01125a846a5d614c567"
    sha256 cellar: :any,                 sonoma:         "98eae80ceea5658e76f5ee2b3c090fa6fec16044c9ce0c5d65a3bd3dda5880f6"
    sha256 cellar: :any,                 ventura:        "65cc8061fa088b560050d1eb21b19d00f23e3ea9a7ad54acdf4f8284dc840982"
    sha256 cellar: :any,                 monterey:       "0ed830c806747ce82838888078e6a86cfb7abcd39ead36d4920b93a065e2524f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a42fd57c27478139d99c51658de69677f27fb334c433647e57cb5d69b954be"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/18/93/1f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258b/aiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/c7/bf/25cf92a83e1fe4948d7935ae3c02f4c9ff9cb9c13e977fba8af11a5f642c/bitarray-2.9.2.tar.gz"
    sha256 "a8f286a51a32323715d77755ed959f94bef13972e9a2fe71b609e40e6d27957e"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/ca/39/0d0a29671be102bd0c717c60f9c805b46042ff98d4a63282cfaff3704b45/cbor2-5.6.2.tar.gz"
    sha256 "b7513c2dea8868991fad7ef8899890ebcf8b199b9b4461c3c11d7ad3aef4820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "crytic-compile" do
    url "https://files.pythonhosted.org/packages/76/07/b629a6bf2c56f63bb6cd1b2000e58395642dcd72ebae746282a58c0feb3f/crytic-compile-0.3.6.tar.gz"
    sha256 "9a53c8913daadfd0f67e288acbe9e74130fe52cc344849925e6e969abc1b8340"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/70/d8/8df71050b214686591241a1826d2e6934b5c295c5bc57f643e4ed697f1eb/cytoolz-0.12.3.tar.gz"
    sha256 "4503dc59f4ced53a54643272c61dc305d1dbbfbd7d6bdf296948de9f34c3a282"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/b2/cb/370191e5445b3cbac2e6cb2023aa6ec232bbfa683d80909c884b2b0c2c62/eth_abi-5.0.1.tar.gz"
    sha256 "e9425110c6120c585c9f0db2e8a33d76c4b886b148a65e68fc0035d3917a3b9c"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/9a/28/d188a0b35efe132a48c0fcb52bcb7f350452e8d63920f7dd8f0fceab37cd/eth-account-0.11.0.tar.gz"
    sha256 "2ffc7a0c7538053a06a7d11495c16c7ad9897dd42be0f64ca7551e9f6e0738c3"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/c6/b6/57c89b91cf2dbb02b3019337f97bf346167d06cd23d3bde43c9fe52cae7e/eth-hash-0.7.0.tar.gz"
    sha256 "bacdc705bfd85dadd055ecd35fd1b4f846b671add101427e089a4ca2e8db310a"
  end

  resource "eth-keyfile" do
    url "https://files.pythonhosted.org/packages/bd/94/730d6da0abddadbb3d0bb4d32b3cd068d9776c3737cdc70325a68f64e9f7/eth-keyfile-0.8.0.tar.gz"
    sha256 "02e3c2e564c7403b92db3fef8ecae3d21123b15787daecd5b643a57369c530f9"
  end

  resource "eth-keys" do
    url "https://files.pythonhosted.org/packages/ad/1d/823dbc3256f9647ebbc8804a2af7631f1ce3155288473bd63e89ff3ce898/eth-keys-0.5.0.tar.gz"
    sha256 "a0abccb83f3d84322591a2c047a1e3aa52ea86b185fa3e82ce311d120ca2791e"
  end

  resource "eth-rlp" do
    url "https://files.pythonhosted.org/packages/9b/2e/fb9c2e0a2d0e249b61abf462828f3f8039305dfbe5844e138ab1a3b3a413/eth-rlp-1.0.1.tar.gz"
    sha256 "d61dbda892ee1220f28fb3663c08f6383c305db9f1f5624dc585c9cd05115027"
  end

  resource "eth-typing" do
    url "https://files.pythonhosted.org/packages/07/8c/607509f95e8924bfb6053a1fc282fee9d1673590c1c534bb82843e4d6368/eth-typing-4.0.0.tar.gz"
    sha256 "9af0b6beafbc5c2e18daf19da5f5a68315023172c4e79d149e12ad10a3d3f731"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/93/78/0c6c891655021288461c9f622205888da9017cbaeeb811ebc384ba8b8d54/eth-utils-4.0.0.tar.gz"
    sha256 "58f9c57900e0f430be728a5e976dc6ed51f493a61e8a4ff1f73c043832cd4f2f"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "hexbytes" do
    url "https://files.pythonhosted.org/packages/c1/94/fbfd526e8964652eec6a7b74ae18d1426e225ab602553858531ec6567d05/hexbytes-0.3.1.tar.gz"
    sha256 "a3fe35c6831ee8fafd048c4c086b986075fc14fd46258fa24ecb8d65745f9a9d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "lru-dict" do
    url "https://files.pythonhosted.org/packages/83/63/21480e8ecc218b9b15672d194ea79da8a7389737c21d8406254306733cac/lru-dict-1.2.0.tar.gz"
    sha256 "13c56782f19d68ddf4d8db0170041192859616514c706b126d0df2ec72a11bd7"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836/multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/ad/03/2d8d0ac1c3107945956bcef379ae11b4ecd7898147f1719911e7684afca1/parsimonious-0.9.0.tar.gz"
    sha256 "b2ad1ae63a2f65bd78f5e0a8ac510a98f3607a43f1db2a8d46636a5d9e4a30c1"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/19/d3/7cb826e085a254888d8afb4ae3f8d43859b13149ac8450b221120d4964c9/prettytable-3.10.0.tar.gz"
    sha256 "9665594d137fb08a1117518c25551e0ede1687197cf353a4fdc78d27e1073568"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/5e/d8/65adb47d921ce828ba319d6587aa8758da022de509c3862a70177a958844/protobuf-4.25.3.tar.gz"
    sha256 "25b5d0b42fd000320bd7830b349e3b696435f3b329810427a6bcce6a5492cc5c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/ed/19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239/pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pyunormalize" do
    url "https://files.pythonhosted.org/packages/dc/5b/ddc89263363422c0d52fdc0a4d88a126621d5cb60359cd45679d3c0447fc/pyunormalize-15.1.0.tar.gz"
    sha256 "cf4a87451a0f1cb76911aa97f432f4579e1f564a2f0c84ce488c73a73901b6c1"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/21/c5/b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9a/referencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/8c/dc/b8e721d244409d13b4c9f76679a6838b2f4a6c72ed9d69cd9c7d1c7fd3fd/rlp-4.0.0.tar.gz"
    sha256 "61a5541f86e4684ab145cb849a5929d2ced8222930a570b3941cf4af16b72a78"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/ba/ce7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5e/rpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/60/a0/2a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019/solc-select-1.0.4.tar.gz"
    sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/3e/bf/5e12db234df984f6df3c7f12f1428aa680ba4e101f63f4b8b3f9e8d2e617/toolz-0.12.1.tar.gz"
    sha256 "ecca342664893f177a13dac0e6b41cbd8ac25a358e5f215316d43e2100224f4d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/01/69/ce305279450e9d033e3ee7223deaa6971d70c7445d9bb955d4700b667ef3/web3-6.15.1.tar.gz"
    sha256 "f9e7eefc1b3c3d194868a4ef9583b625c18ea3f31a48ebe143183db74898f381"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  # Drop setuptools dep
  # https://github.com/crytic/slither/pull/2290
  patch do
    url "https://github.com/crytic/slither/commit/93cbf7d887a930e20c1ea8cf543ec2f41e84aadd.patch?full_index=1"
    sha256 "6c6278b86c8d75fb01a50715a8891ab8a94ec6d4372092440f1cefd67fbe0940"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      # slither exits with code 255 if high severity findings are found
      assert_match("5 result(s) found",
                   shell_output("#{bin}/slither --detect uninitialized-state --fail-high " \
                                "variable-0.8.0.sol-0.8.15-compact.zip 2>&1", 255))
    end
  end
end
