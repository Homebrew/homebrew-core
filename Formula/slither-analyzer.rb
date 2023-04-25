class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/5f/aa/2ae88384fc4c72124e1a1482f0d93b133f0eacb18799b046c53a31ba1523/slither-analyzer-0.9.3.tar.gz"
  sha256 "a0dfba374c91d074a2d6792041ee92f147bedcd906e45e0dd240df34fc0fc26c"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4af28f72ff21dd9b25b7efdb2803d1285fce0f65eee5761c03ac4b4a61549031"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b7fb2fa8fb2d4c0b383512a25f0f3b9570bcd74904a84860f13670348b20e57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de51f4e9e0ca56dddb4a8487addc72b10689995f436982694767b3ba4ffc00ea"
    sha256 cellar: :any_skip_relocation, ventura:        "98993d398e275f8bee428325b6f30ed8192fd683209368aa2f85301ec57884db"
    sha256 cellar: :any_skip_relocation, monterey:       "168382c6b788aaa23a5d84a11390a99e82203240012f99ec7f040a4ce0a50f12"
    sha256 cellar: :any_skip_relocation, big_sur:        "28345d63be47469bf497a14038f56cff896780d9f4d22bae54666ce2da40824d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad253ce85366bf42e0112ad1f374daaad210887820e2b8b61c0fccee6b688b67"
  end

  depends_on "crytic-compile"
  depends_on "python@3.11"
  depends_on "solc-select"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c2/fd/1ff4da09ca29d8933fda3f3514980357e25419ce5e0f689041edb8f17dab/aiohttp-3.8.4.tar.gz"
    sha256 "bf2e1a9162c1e441bf805a1fd166e249d574ca04e03b34f97e2928769e91ab5c"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/82/30/68a3ee41e6abbb521a3418fb25a7755127a1d6bf4604028bb404f833b2fc/bitarray-2.7.3.tar.gz"
    sha256 "f71256a32609b036adad932e1228b66a6b4e2cae6be397e588ddc0babd9a78b9"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/da/89/66bac516a236af8375dd7af2b3032a210e222395670758da4b2439b37e40/cytoolz-0.12.1.tar.gz"
    sha256 "fc33909397481c90de3cec831bfb88d97e220dc91939d996920202f184b4648e"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/d4/91/1bb69bdb275dba01eb7f038b3e7e88741262f9f4da5327a965aaf8b3c57e/eth_abi-4.0.0b3.tar.gz"
    sha256 "24f216c8445aab725f5e10c491b4c96506b47264436b3d4af1186b7dd6fb45e9"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/04/f6/bfe7d0d06a2612c0ab85ef1dd08b59bf6ae57e2780310949f9b15a07110f/eth-account-0.8.0.tar.gz"
    sha256 "ccb2d90a16c81c8ea4ca4dc76a70b50f1d63cea6aff3c5a5eddedf9e45143eca"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/ee/96/9f138011b01a0db7c0369187d18dee06385a5cc3b18cca038e882e57885d/eth-hash-0.5.1.tar.gz"
    sha256 "9805075f653e114a31a99678e93b257fb4082337696f4eff7b4371fe65158409"
  end

  resource "eth-keyfile" do
    url "https://files.pythonhosted.org/packages/60/8e/affe6f0d1c0f02c8bbdf900cb57c5a4b97410ff341807fc3107484d2a58f/eth-keyfile-0.6.1.tar.gz"
    sha256 "471be6e5386fce7b22556b3d4bde5558dbce46d2674f00848027cb0a20abdc8c"
  end

  resource "eth-keys" do
    url "https://files.pythonhosted.org/packages/e4/24/03295c85b09f17d0d002d5cfca54614dc68e9ceaa4c8978267a1f6d75299/eth-keys-0.4.0.tar.gz"
    sha256 "7d18887483bc9b8a3fdd8e32ddcb30044b9f08fcb24a380d93b6eee3a5bb3216"
  end

  resource "eth-rlp" do
    url "https://files.pythonhosted.org/packages/f3/a2/2e6ff6eb74820a0fb5716787cb06fc9ae5035092cd830d99de83ff11197b/eth-rlp-0.3.0.tar.gz"
    sha256 "f3263b548df718855d9a8dbd754473f383c0efc82914b0b849572ce3e06e71a6"
  end

  resource "eth-typing" do
    url "https://files.pythonhosted.org/packages/c9/d0/b952374f22b65cc28a55311b64cc0c72f01c123aaa12c0c517de02d71d13/eth-typing-3.3.0.tar.gz"
    sha256 "e9535e9d524d4c7a0cbd3d9832093cc5001a3e31869e72645674d24c6376d196"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/3e/ce/5d8df4d0862c256fd140f7e3f93e8c192e13aef53c2ca8d3e9809382a522/eth-utils-2.1.0.tar.gz"
    sha256 "fcb4c3c1b32947ba92970963f9aaf40da73b04ea1034964ff8c0e70595127138"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "hexbytes" do
    url "https://files.pythonhosted.org/packages/a0/d0/dd14285d3acfc1f8ee8ee628f10d244c4eefd4bac62e83ed9d279b87d4d3/hexbytes-0.3.0.tar.gz"
    sha256 "afeebfb800f5f15a3ca5bab52e49eabcb4b6dac06ec8ff01a94fdb890c6c0712"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "lru-dict" do
    url "https://files.pythonhosted.org/packages/79/da/138e76e2e9ecf074a5ee26cacbd0676e1efdfff2bda3e6f40a6dc8728bf3/lru-dict-1.1.8.tar.gz"
    sha256 "878bc8ef4073e5cfb953dfc1cf4585db41e8b814c0106abde34d00ee0d0b3115"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/ad/03/2d8d0ac1c3107945956bcef379ae11b4ecd7898147f1719911e7684afca1/parsimonious-0.9.0.tar.gz"
    sha256 "b2ad1ae63a2f65bd78f5e0a8ac510a98f3607a43f1db2a8d46636a5d9e4a30c1"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ba/b6/8e78337766d4c324ac22cb887ecc19487531f508dbf17d922b91492d55bb/prettytable-3.6.0.tar.gz"
    sha256 "2e0026af955b4ea67b22122f310b90eae890738c08cb0458693a49b6221530ac"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/4a/e0/9da6a25f4ac72455f5da9d4af8d75144d15e29d415220773850e0ec23d3e/protobuf-4.22.1.tar.gz"
    sha256 "dce7a55d501c31ecf688adb2f6c3f763cf11bc0be815d1946a84d74772ab07a7"
  end

  resource "pypandoc" do
    url "https://files.pythonhosted.org/packages/cd/10/7042e44e0b5020d075cd61c93dc6c26d618e5a1f4f1d2cd493fe54ab124d/pypandoc-1.7.5.tar.gz"
    sha256 "802c26aae17b64136c6d006949d8ce183a7d4d9fbd4f2d051e66f4fb9f45ca50"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/20/63/8b5205a7f9e2792137676c2d29bd6bc9cbecca95015a55ed54d6dd02f3f6/rlp-3.0.0.tar.gz"
    sha256 "63b0465d2948cd9f01de449d7adfb92d207c1aef3982f20310f8009be4a507e8"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/cf/05/2008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84/toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/27/9b/e4f42a38553f6bd42a7a0e1e3d6ad2128ceb7ad700005f7564edba338d28/web3-6.0.0.tar.gz"
    sha256 "6b925a19e4a0001337d8b2faa72577d6b7e8f9a8a9a0b98d8834cdf698cfc045"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/85/dc/549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273/websockets-10.4.tar.gz"
    sha256 "eef610b23933c54d5d921c92578ae5f89813438fded840c2e9809d378dc765d3"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/c4/1e/1b204050c601d5cd82b45d5c8f439cb6f744a2ce0c0a6f83be0ddf0dc7b2/yarl-1.8.2.tar.gz"
    sha256 "49d43402c6e3013ad0978602bf6bf5328535c48d192304b91b97a3c6790b1562"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.11")
    crytic_compile = Formula["crytic-compile"].opt_libexec
    solc_select = Formula["solc-select"].opt_libexec
    (libexec/site_packages/"homebrew-crytic-compile.pth").write crytic_compile/site_packages
    (libexec/site_packages/"homebrew-solc-select.pth").write solc_select/site_packages
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
