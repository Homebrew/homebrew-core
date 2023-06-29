class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/d9/6d/42920046529b56cfb8bae1e221dd44bde25901c8c4240949cfd642d870d3/slither-analyzer-0.9.5.tar.gz"
  sha256 "04beb3e55656a97f11195d2ff17d7d7ae161bc86b1a7ff4f17e2460c7b970d4a"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4acc8ce36bf9b9b833bdd7342a51174a67c81bbee98b4b19a077231c8461a871"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1debc6534923ca5115ba4cd5aba15aa48cbed34e91324e6bdcfed21afdb11748"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c634b0c4c0bf511b21144c31fa6b54e89f8541e8193fdd80bd3e120f88b4a2f3"
    sha256 cellar: :any_skip_relocation, ventura:        "07b1befd3ef7caa163491c715154a6076ab43256044d066b457259a79d524e2d"
    sha256 cellar: :any_skip_relocation, monterey:       "a3f0c773e26201d06650b6736065ea446767bafb20de5b564ea39244b7c7cd14"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf0174d23dbce5e0b4b33aac5637b09c908987fd60a83fa31f81308f7caf488a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f216dc4d3be6e0d32bddfe510d61683a99030729a595fa17c6002739856e78"
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
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/2d/08/e6b51b0456becc0db01e969d6e1c4542094bde0a7bbb197834f94b18332a/bitarray-2.7.6.tar.gz"
    sha256 "3807f9323c308bc3f9b58cbe5d04dc28f34ac32d852999334da96b42f64b5356"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
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
    url "https://files.pythonhosted.org/packages/b0/1c/b7074d196438bbe667453f73f1a45cb51ee2236a99b333a16b1aa16927b0/eth_abi-4.1.0.tar.gz"
    sha256 "fe738cdb24983adfe89abf727c723c288f8d0029e97fb08160b20bb5290ab475"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/e6/ec/41c8bd1b11997f6627f97ba7247d1d68f8089fe727cd6ae12c9fb2b966bc/eth-account-0.9.0.tar.gz"
    sha256 "5f66ecb7bc52569924dfaf4a9add501b1c2a4901eec74e3c0598cd26d0971777"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/33/98/0a5ff6036b36018db5a728e1e1691457df191bba10a95a912d456b6d1e73/eth-hash-0.5.2.tar.gz"
    sha256 "1b5f10eca7765cc385e1430eefc5ced6e2e463bb18d1365510e2e539c1a6fe4e"
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
    url "https://files.pythonhosted.org/packages/b6/4e/5f386efcbf7dfc2d94c6dfc8def7270a0cf58212099bc19bd0f3f2fe6171/eth-typing-3.4.0.tar.gz"
    sha256 "7f49610469811ee97ac43eaf6baa294778ce74042d41e61ecf22e5ebe385590f"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/19/43/78d9273c5388d70e478eaaac76849101685b285d4bcfee139fdeb3704c00/eth-utils-2.1.1.tar.gz"
    sha256 "7cccfb0b0749431d0d001e327e9a7289bf07308316a73850ae3895020e5682f4"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "hexbytes" do
    url "https://files.pythonhosted.org/packages/c1/94/fbfd526e8964652eec6a7b74ae18d1426e225ab602553858531ec6567d05/hexbytes-0.3.1.tar.gz"
    sha256 "a3fe35c6831ee8fafd048c4c086b986075fc14fd46258fa24ecb8d65745f9a9d"
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
    url "https://files.pythonhosted.org/packages/83/63/21480e8ecc218b9b15672d194ea79da8a7389737c21d8406254306733cac/lru-dict-1.2.0.tar.gz"
    sha256 "13c56782f19d68ddf4d8db0170041192859616514c706b126d0df2ec72a11bd7"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/ad/03/2d8d0ac1c3107945956bcef379ae11b4ecd7898147f1719911e7684afca1/parsimonious-0.9.0.tar.gz"
    sha256 "b2ad1ae63a2f65bd78f5e0a8ac510a98f3607a43f1db2a8d46636a5d9e4a30c1"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/18/fa/82e719efc465238383f099c08b5284b974f5002dbe12050bcbbc912366eb/prettytable-3.8.0.tar.gz"
    sha256 "031eae6a9102017e8c7c7906460d150b7ed78b20fd1d8c8be4edaf88556c07ce"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/e5/9d/20e9bf4067e85c3074f1f5bac820a3cfb9ce885cddd8a649fe3570659c77/protobuf-4.23.3.tar.gz"
    sha256 "7a92beb30600332a52cdadbedb40d33fd7c8a0d7f549c440347bc606fb3fe34b"
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
    url "https://files.pythonhosted.org/packages/18/df/401fd39ffd50062ff1e0344f95f8e2c141de4fd1eca1677d2f29609e5389/regex-2023.6.3.tar.gz"
    sha256 "72d1a25bf36d2050ceb35b517afe13864865268dfb45910e2e17a84be6cbfeb0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/61/15/e3b1d71733285611be4576bd2f1431c1c7003083931281349a706f3e6634/web3-6.5.0.tar.gz"
    sha256 "ebbce3caa0b50015d15a07f17d2a280abbb94a52c6994babb90f3a5482c97712"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
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
