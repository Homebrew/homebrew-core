class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://blog.trailofbits.com/2018/10/19/slither-a-solidity-static-analysis-framework/"
  url "https://files.pythonhosted.org/packages/05/c2/01a0c06017ac631db4d37cc36dce18be2eabd80576270d356688e5121908/slither_analyzer-0.11.6.tar.gz"
  sha256 "72aff6c1924a8641c1c8e4d84f9a4e6c97b5bfb3221bf71a11ffaee46d2f7da2"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "19724502843491477080c36281795a492eaf488055154fbd0ca4a22d24de11e5"
    sha256 cellar: :any, arm64_tahoe:       "70cec7dab017fce0afee312e8b6a8f7d53e0be735fdeb526e4ca61f7f11edea3"
    sha256 cellar: :any, arm64_sequoia:     "4e3d3fc67ec337b7b087c8c44ddc816ff6089dc70f976647863edfde5a6b5c4b"
    sha256 cellar: :any, arm64_sonoma:      "a5ac113278ea76062f1a2b59f2f42395a386f1f735e6e00120c161a7cbdf951f"
    sha256 cellar: :any, sonoma:            "126994fe95e6b39b0b0cd3626bc33891976f2dca37666c1fb47158bfbf282ad5"
    sha256 cellar: :any, arm64_linux:       "5ce4e30bc0c2fba48c83a84e1605eeb4383f4abf42328d524733e35b1f3573d9"
    sha256 cellar: :any, x86_64_linux:      "d623d851073dd204edec324e90ec8375426bb9e3a5fc57329f6e1653ac136623"
  end

  depends_on "rust" => :build # for cbor2
  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/58/d9/22ce5786ac0c1653ae8b6c23bded02c1686d11f0dbb45b31ce128e0df985/aiohttp-3.14.3.tar.gz"
    sha256 "9491196535a88924a60afd5b5f434b5b203b6cc616250878dbdb223a8f7844bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/04/f7/6765577df59e2345036e435f7e983e1c291d67b7d76a51918eff04ad1494/bitarray-3.11.0.tar.gz"
    sha256 "bf19437ec00ec3d40aef82eaeedc14cf4000be9b635c4f5049796506e6630dd8"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/39/34/d443914ea562a985ccb357682e17b7190d5d58eff797c741379be47a8f31/cbor2-6.1.5.tar.gz"
    sha256 "6eb06160c42315ac0c4ded461c7d84d92fa18c69d13d17fc1dfc1fae96580c95"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "ckzg" do
    url "https://files.pythonhosted.org/packages/2b/88/552337d9fc69dc85fb6102c18b73a9f3f77efb39bb9a0c1a8c61bbdd7274/ckzg-2.1.8.tar.gz"
    sha256 "d7bef6b425dca6995457fc59fc5b30211d9b28cbbeee0e7a7bef1372e13f29ca"
  end

  resource "crytic-compile" do
    url "https://files.pythonhosted.org/packages/d3/c1/ba7f089fbf73cef1f1684d8fb5ec7c47d6f81870ca3e21b32aed88196774/crytic_compile-0.4.2.tar.gz"
    sha256 "161325e40785d8e42cdd8846b98d4f82c291ca5bcd07b5feae1a84d5a18c59fb"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/bd/d4/16916f3dc20a3f5455b63c35dcb260b3716f59ce27a93586804e70e431d5/cytoolz-1.1.0.tar.gz"
    sha256 "13a7bf254c3c0d28b12e2290b82aed0f0977a4c2a2bf84854fcdc7796a29f3b0"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/b6/90/8bbcb07308436211a1e9a09a2fbaa259d2a169d3b081ca22525e22d16444/eth_abi-6.0.0.tar.gz"
    sha256 "e83a0ed91f2dadeeb50236d673736fe2edc6fcc0a1c1e13d461192d4b23d5bcc"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/15/f1/e1e35b67d0f36f0186cfc0502da7984560c03d1fe51e36e3bbe6d6167ba7/eth_account-0.14.0.tar.gz"
    sha256 "2c8291b1a8fcbd29a55b07f75f0a0aaffd04704d3ec28d1396587f18a5541c6d"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/3c/f5/c67fc24f2f676aa9b7ab29679d44f113f314c817207cd4319353356f62da/eth_hash-0.8.0.tar.gz"
    sha256 "b009752b620da2e9c7668014849d1f5fadbe4f138603f1871cc5d4ca706896b1"
  end

  resource "eth-keyfile" do
    url "https://files.pythonhosted.org/packages/07/e1/eb8cc218abd7e7ee8eeafbb9c1deef17e9fdda9c3f39af23479899745136/eth_keyfile-0.10.0.tar.gz"
    sha256 "3003b20000d68203e8fbf45456851a524f859a7432d2fae73be4a9aebeb4b8e1"
  end

  resource "eth-keys" do
    url "https://files.pythonhosted.org/packages/39/58/f54660cffe3f39aad2d80d13b072973ee9134b6cdfd8b4d086419eda997b/eth_keys-0.8.0.tar.gz"
    sha256 "11549b251876fccd7caedd6905e494ea2309aec352ec2579b00ef9978017a964"
  end

  resource "eth-rlp" do
    url "https://files.pythonhosted.org/packages/5f/e1/9719acaa45e6f158ebfc260a97edc71591264c1d09701cf8a30a687a36b0/eth_rlp-3.0.0.tar.gz"
    sha256 "9663e54a4a1c1c847d2d328c1d07e4174ec1c082953fbb42b60e61c501c4931c"
  end

  resource "eth-typing" do
    url "https://files.pythonhosted.org/packages/37/e7/06c5af99ad40494f6d10126a9030ff4eb14c5b773f2a4076017efb0a163a/eth_typing-6.0.0.tar.gz"
    sha256 "315dd460dc0b71c15a6cd51e3c0b70d237eec8771beb844144f3a1fb4adb2392"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/e9/1b/0b8548da7b31eba87ed58bca1d0de5dcb13a6c113e02c09019ec5a6716ed/eth_utils-6.0.0.tar.gz"
    sha256 "eb54b2f82dd300d3142c49a89da195e823f5e5284d43203593f87c67bad92a96"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "hexbytes" do
    url "https://files.pythonhosted.org/packages/27/4f/eabe45c58f2d27cd0b338ecc41b0b475a3751ed70eb1a21db08497e3ceec/hexbytes-2.0.0.tar.gz"
    sha256 "01312fcd5c57e8a8d2d7dd3274dcf84ea50422aff2abcc2d9fd89ad6a32498e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/99/1d4d69c3512d0ddbfa3a1b69cfd9a151012ab2eb4eabbb096201b1f0b7d8/multidict-6.9.1.tar.gz"
    sha256 "0f06e60fa190aa7abd0914c2a766736fdc8e9f34878c4346338534b73d1b20e2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/7b/91/abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7/parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/81/74/ba08d81e668ccfe8658d7520a307e63c19862c08eb4ccb26f356c5239a7a/prettytable-3.18.0.tar.gz"
    sha256 "439217116152244369caf3d9f1caf2f9fe29b03bd79e88d2928c8e718c95d680"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "py-ecc" do
    url "https://files.pythonhosted.org/packages/1c/96/e73075d5c885274efada2fbc5db6377022036c2f5b4b470dbcf4106e07d5/py_ecc-8.0.0.tar.gz"
    sha256 "56aca19e5dc37294f60c1cc76666c03c2276e7666412b9a559fa0145d099933d"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pyunormalize" do
    url "https://files.pythonhosted.org/packages/49/64/5c8ce34a4e366ee052ce7b3b2ddd11b9711a072902a31d0385f3a0f394e8/pyunormalize-18.0.0.tar.gz"
    sha256 "2b2e65201e688bb38c66ab66ef1071cc07b32e9840e5ae07aab716db6ede7d6d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/1e/45/68859ee36a69ddd8fa819d52fab75214de56f05500907e8bf09b5fd7bd75/rlp-5.0.0.tar.gz"
    sha256 "ae8ac791160c160e270f9c7df76e68f4d42bb86a13726d807b9357c312d0bac4"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/62/89/51e614fdbf26f47268c18f8a3b6cf1cb67c9a8b48b7b7231c948cae97814/solc_select-1.2.0.tar.gz"
    sha256 "ad0a7afcae05061ce5e7632950b1fa0193ba9eaf05e4956f86effee024c6fb07"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/11/d6/114b492226588d6ff54579d95847662fc69196bdeec318eb45393b24c192/toolz-1.1.0.tar.gz"
    sha256 "27a5c770d068c110d9ed9323f24f1543e83b2f300a687b7891c1a6d56b697b5b"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/c0/18/4c2c0290953f8b3b9612adfcb07b57f144ade3ad32a76764fca42b77c5f3/types_requests-2.33.0.20260906.tar.gz"
    sha256 "76ab8a0fb736744a0c3deee7aa57b2927e301f078d9e61f5391b3e92002416b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/dc/ac/3a943d2792c9bb368aaa8b50121c0f778460ba2d7fbdc0a0366201d9e761/wcwidth-0.9.1.tar.gz"
    sha256 "5823209b0d43af322ce698c689380d7c15ca31fa8e6e3be8459f27031bef0af5"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/f1/d9/bdfa9e715804020c3f3676346065c18adbc207c9343a3458246d7430f45c/web3-7.16.0.tar.gz"
    sha256 "b4a75a3fa94fef4d23d502eb3c2244146ef9a1ee0082cf1cb0a91586ba0510c3"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
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
