class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/a5/c4/d2aaf5a600a8ac176655fb7e2130a4879d766e17f51ee4694d022474ebdf/slither-analyzer-0.10.0.tar.gz"
  sha256 "d01ad88a7fc9581f717859c66d01ef1658ba49505c60e89d5cf38ce6a7f4cdff"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "20fc5e697a005779223f35e935f777ec62295d1eacf252215adc62b0348add9e"
    sha256 cellar: :any,                 arm64_ventura:  "cd48d6dc2454e433c9b2844586e00a70d19950df9b542b4307271386143fcc53"
    sha256 cellar: :any,                 arm64_monterey: "4505cfe72360d3b8675550e73aeee7027c6b72b3096054dab3c1db2313a638e7"
    sha256 cellar: :any,                 sonoma:         "a078dc8d6073cf79835c2f3f0fe5916b6ca5fdf1f02d33cceecfd30dab49aea9"
    sha256 cellar: :any,                 ventura:        "66206bfde4ea44f816deb98266a8a9423852c32a8de229498769a5d478afd8f5"
    sha256 cellar: :any,                 monterey:       "72f14e435134f0b75098fa226708bd005f92a726a29b86d95cc6943daa7f8ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10fce23a075635282fcd19c8488eb57637a16da38ee50b94027a9dc2d9441a2"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "crytic-compile"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-toml"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "solc-select"

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

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/70/d8/8df71050b214686591241a1826d2e6934b5c295c5bc57f643e4ed697f1eb/cytoolz-0.12.3.tar.gz"
    sha256 "4503dc59f4ced53a54643272c61dc305d1dbbfbd7d6bdf296948de9f34c3a282"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/7b/98/3ed235fe27f30a7fa51dfcc5cdfdf5af1fbcef7906858ef59ff40e154bc0/eth_abi-5.0.0.tar.gz"
    sha256 "89c4454d794d9ed92ad5cb2794698c5cee6b7b3ca6009187d0e282adc7f9b6dc"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/46/99/de5a08d64ca9e5c31a7d0ee88c39283aa34a53c7fd08a8d83e8051523ab3/eth-account-0.10.0.tar.gz"
    sha256 "474a2fccf7286230cf66502565f03b536921d7e1fdfceba198e42160e5ac4bc1"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/b2/62/ee6a0e4716d6f714d35a52c65ff607c99588bb4af34de916d4ff835877dc/eth-hash-0.6.0.tar.gz"
    sha256 "ae72889e60db6acbb3872c288cfa02ed157f4c27630fcd7f9c8442302c31e478"
  end

  resource "eth-keyfile" do
    url "https://files.pythonhosted.org/packages/99/39/c65fd9fd00071a93639c07e76a81f943be68f0e016a4a900262f6a33a628/eth-keyfile-0.7.0.tar.gz"
    sha256 "6bdb8110c3a50439deb68a04c93c9d5ddd5402353bfae1bf4cfca1d6dff14fcf"
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
    url "https://files.pythonhosted.org/packages/c5/a8/3ae71d48668700753012c92813f366f91551331ff2a05e9c98f92551d1a9/eth-utils-3.0.0.tar.gz"
    sha256 "8721869568448349bceae63c277b75758d11e0dc190e7ef31e161b89619458f1"
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

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/ad/03/2d8d0ac1c3107945956bcef379ae11b4ecd7898147f1719911e7684afca1/parsimonious-0.9.0.tar.gz"
    sha256 "b2ad1ae63a2f65bd78f5e0a8ac510a98f3607a43f1db2a8d46636a5d9e4a30c1"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/db/a5/05ea470f4e793c9408bc975ce1c6957447e3134ce7f7a58c13be8b2c216f/protobuf-4.25.2.tar.gz"
    sha256 "fe599e175cb347efc8ee524bcd4b902d11f7262c0e569ececcb89995c15f0a5e"
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
    url "https://files.pythonhosted.org/packages/b7/0a/e3bdcc977e6db3bf32a3f42172f583adfa7c3604091a03d512333e0161fe/rpds_py-0.17.1.tar.gz"
    sha256 "0210b2668f24c078307260bf88bdac9d6f1093635df5123789bfee4d8d7fc8e7"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/3e/bf/5e12db234df984f6df3c7f12f1428aa680ba4e101f63f4b8b3f9e8d2e617/toolz-0.12.1.tar.gz"
    sha256 "ecca342664893f177a13dac0e6b41cbd8ac25a358e5f215316d43e2100224f4d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/a4/82/9ab41011a202a1ab74306899b01cdf3c6bb0aed81226018f1f9705a31281/web3-6.15.0.tar.gz"
    sha256 "a646d1fe5eba00625b5459d23910e472f0d0aa063788422bff2648ca4e1ebc7e"
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
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[crytic-compile solc-select].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
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
