class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/d9/18/4af93281e1e7ae22fb2bdc3a3da36397781b8b99611fa54379f5a6d1631d/slither-analyzer-0.9.6.tar.gz"
  sha256 "3ee724a3bbd29d631d9c4ed766a63bcd18ed39775b39796b19f02edf4de3fe80"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "b660a2e1aa7261e025135d4b64bc6ad6022c788dc18fb454cd64bc7bfb24a57d"
    sha256 cellar: :any,                 arm64_ventura:  "bd2440bac211a5e48ba33cf09ae64fb0fadbcd7dda69e9627dd1511f425ee169"
    sha256 cellar: :any,                 arm64_monterey: "d9765b9c42d12764d580bdbaf2d9c92cc3b3137fafcc5ae55484671dcc0f6995"
    sha256 cellar: :any,                 sonoma:         "b177ac60108ba97e20a09ed5a2a1a119ce6422232dafbe3161dd79cc2c379464"
    sha256 cellar: :any,                 ventura:        "d150e60c7d18e172703415310c8cb072bdbaa4bb4ee769dc72df5fab319f12ee"
    sha256 cellar: :any,                 monterey:       "853380ee73f917f8596cd620bbf2d34d9ed446ffcf39b18a4ce95da7b3b6a8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9344e25c4b1a3c801b656b79dc2be8750e3370a68cb4db2999ee6d8f71e82850"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "crytic-compile"
  depends_on "python-certifi"
  depends_on "python-packaging"
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

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/a0/61/c27e1e7007e3cc6989053956dfe078db84e164f22c7000b2ad1efc5b93b7/cytoolz-0.12.2.tar.gz"
    sha256 "31d4b0455d72d914645f803d917daf4f314d115c70de0578d3820deb8b101f66"
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
    url "https://files.pythonhosted.org/packages/79/01/ce65847f79de9594d436b7ef295e374dfcc0ff3ee884bf61cf896f970ddb/jsonschema-4.18.0.tar.gz"
    sha256 "8caf5b57a990a98e9b39832ef3cb35c176fe331414252b6e1b26fd5866f891a4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/9a/8c/3d028449ac15cba52db3e1c95ca53b9240b4707fbe17f43e01cc73dd9336/jsonschema_specifications-2023.6.1.tar.gz"
    sha256 "ca1c4dd059a9e7b34101cf5b3ab7ff1d18b139f35950d598d629837ef66e8f28"
  end

  resource "lru-dict" do
    url "https://files.pythonhosted.org/packages/83/63/21480e8ecc218b9b15672d194ea79da8a7389737c21d8406254306733cac/lru-dict-1.2.0.tar.gz"
    sha256 "13c56782f19d68ddf4d8db0170041192859616514c706b126d0df2ec72a11bd7"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
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
    url "https://files.pythonhosted.org/packages/d3/1c/de86d82a5fc780feca36ef52c1231823bb3140266af8a04ed6286957aa6e/protobuf-4.23.4.tar.gz"
    sha256 "ccd9430c0719dce806b93f89c91de7977304729e55377f872a92465d548329a9"
  end

  # pypandoc's convert was removed in 1.8, thus pin to use 1.7.5
  resource "pypandoc" do
    url "https://files.pythonhosted.org/packages/cd/10/7042e44e0b5020d075cd61c93dc6c26d618e5a1f4f1d2cd493fe54ab124d/pypandoc-1.7.5.tar.gz"
    sha256 "802c26aae17b64136c6d006949d8ce183a7d4d9fbd4f2d051e66f4fb9f45ca50"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/20/93/45213b5b6e3eeab03e3f6eb82cc516a81fbf257586a25f9eb1d21af96e1b/referencing-0.29.1.tar.gz"
    sha256 "90cb53782d550ba28d2166ef3f55731f38397def8832baac5d45235f1995e35e"
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

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/75/80/7f76ff5d290a11a8d43653da186def13f293f00baf4927eae1ad128bf9de/rpds_py-0.8.8.tar.gz"
    sha256 "300b8579740b06e246238b730e636f314a7d8dc475be1868650f5d3ddc29a0d8"
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
