class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/f9/d7/327729240d0ab0291cf3e9b36f05e135676ffea796e4a74ec6b7ef7ad2dd/slither_analyzer-0.11.3.tar.gz"
  sha256 "09953ddb89d9ab182aa5826bda6fa3da482c82b5ffa371e34b35ba766044616e"
  license "AGPL-3.0-only"
  revision 3
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a669552be3d6fa0206009a50e68c1154fa37f68d32e8e4252f4b3c3d44cc9ea"
    sha256 cellar: :any,                 arm64_sequoia: "d3d8b589d9cb2044065b1e21416c94bdbca2ef459ebcf161cb3f2e2b4bef6a78"
    sha256 cellar: :any,                 arm64_sonoma:  "f8f044628ebf98bbe66f788cec5a0f1e9a0739759e6143c5d412c030c42a5e95"
    sha256 cellar: :any,                 arm64_ventura: "ff8544b80cf62a5ef122ddb4d6db448d1df227964730e09adf2d935ce24cba8f"
    sha256 cellar: :any,                 sonoma:        "0df77ede0acf71566d3e20f2f5a74d88b6de63a279a00d545de3f5a3ed9117bb"
    sha256 cellar: :any,                 ventura:       "89e608492f04e2f5486c53d9c3d0c3cbf35e1ca858c4eeec1894ebee6cac972f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e3ea8b431cda5c81e3a238935993691a4133df86df85dadbe38c368dce64c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74ea96c92696146197626c1c1f10d1860162ce3efee4140712a32b15de89a4c"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/e6/0b/e39ad954107ebf213a2325038a3e7a506be3d98e1435e1f82086eec4cde2/aiohttp-3.12.14.tar.gz"
    sha256 "6e06e120e34d93100de448fd941522e11dafa78ef1a893c179901b7d66aa29f2"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/8a/e9/be1722981d43341ec1da6370255c414ec00ba23a99e01fc315dbe4c5c9f4/bitarray-3.5.1.tar.gz"
    sha256 "b03c49d1a2eb753cc6090053f1c675ada71e1c3ea02011f1996cf4c2b6e9d6d6"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/e4/aa/ba55b47d51d27911981a18743b4d3cebfabccbb0598c09801b734cec4184/cbor2-5.6.5.tar.gz"
    sha256 "b682820677ee1dbba45f7da11898d2720f92e06be36acec290867d5ebf3d7e09"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "ckzg" do
    url "https://files.pythonhosted.org/packages/55/df/f6db8e83bd4594c1ea685cd37fb81d5399e55765aae16d1a8a9502598f4e/ckzg-2.1.1.tar.gz"
    sha256 "d6b306b7ec93a24e4346aa53d07f7f75053bc0afc7398e35fa649e5f9d48fcc4"
  end

  resource "crytic-compile" do
    url "https://files.pythonhosted.org/packages/78/9b/6834afa2cc6fb3d958027e4c9c24c09735f9c6caeef4e205c22838f772bf/crytic_compile-0.3.10.tar.gz"
    sha256 "0d7e03b4109709dd175a4550345369548f99fc1c96183c34ccc4dd21a7c41601"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/a7/f9/3243eed3a6545c2a33a21f74f655e3fcb5d2192613cd3db81a93369eb339/cytoolz-1.0.1.tar.gz"
    sha256 "89cc3161b89e1bb3ed7636f74ed2e55984fd35516904fc878cae216e42b2c7d6"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/00/71/d9e1380bd77fd22f98b534699af564f189b56d539cc2b9dab908d4e4c242/eth_abi-5.2.0.tar.gz"
    sha256 "178703fa98c07d8eecd5ae569e7e8d159e493ebb6eeb534a8fe973fbc4e40ef0"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/74/cf/20f76a29be97339c969fd765f1237154286a565a1d61be98e76bb7af946a/eth_account-0.13.7.tar.gz"
    sha256 "5853ecbcbb22e65411176f121f5f24b8afeeaf13492359d254b16d8b18c77a46"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/ee/38/577b7bc9380ef9dff0f1dffefe0c9a1ded2385e7a06c306fd95afb6f9451/eth_hash-0.7.1.tar.gz"
    sha256 "d2411a403a0b0a62e8247b4117932d900ffb4c8c64b15f92620547ca5ce46be5"
  end

  resource "eth-keyfile" do
    url "https://files.pythonhosted.org/packages/35/66/dd823b1537befefbbff602e2ada88f1477c5b40ec3731e3d9bc676c5f716/eth_keyfile-0.8.1.tar.gz"
    sha256 "9708bc31f386b52cca0969238ff35b1ac72bd7a7186f2a84b86110d3c973bec1"
  end

  resource "eth-keys" do
    url "https://files.pythonhosted.org/packages/58/11/1ed831c50bd74f57829aa06e58bd82a809c37e070ee501c953b9ac1f1552/eth_keys-0.7.0.tar.gz"
    sha256 "79d24fd876201df67741de3e3fefb3f4dbcbb6ace66e47e6fe662851a4547814"
  end

  resource "eth-rlp" do
    url "https://files.pythonhosted.org/packages/7f/ea/ad39d001fa9fed07fad66edb00af701e29b48be0ed44a3bcf58cb3adf130/eth_rlp-2.2.0.tar.gz"
    sha256 "5e4b2eb1b8213e303d6a232dfe35ab8c29e2d3051b86e8d359def80cd21db83d"
  end

  resource "eth-typing" do
    url "https://files.pythonhosted.org/packages/60/54/62aa24b9cc708f06316167ee71c362779c8ed21fc8234a5cd94a8f53b623/eth_typing-5.2.1.tar.gz"
    sha256 "7557300dbf02a93c70fa44af352b5c4a58f94e997a0fd6797fb7d1c29d9538ee"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/0d/49/bee95f16d2ef068097afeeffbd6c67738107001ee57ad7bcdd4fc4d3c6a7/eth_utils-5.3.0.tar.gz"
    sha256 "1f096867ac6be895f456fa3acb26e9573ae66e753abad9208f316d24d6178156"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "hexbytes" do
    url "https://files.pythonhosted.org/packages/7f/87/adf4635b4b8c050283d74e6db9a81496063229c9263e6acc1903ab79fbec/hexbytes-1.3.1.tar.gz"
    sha256 "a657eebebdfe27254336f98d8af6e2236f3f83aed164b87466b6cf6c5f5a4765"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/3d/2c/5dad12e82fbdf7470f29bff2171484bf07cb3b16ada60a6589af8f376440/multidict-6.6.3.tar.gz"
    sha256 "798a9eb12dab0a6c2e29c1de6f3468af5cb2da6053a20dfa3344907eed0937cc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/7b/91/abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7/parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/99/b1/85e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94f/prettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pyunormalize" do
    url "https://files.pythonhosted.org/packages/b3/08/568036c725dac746ecb267bb749ef930fb7907454fe69fce83c8557287fb/pyunormalize-16.0.0.tar.gz"
    sha256 "2e1dfbb4a118154ae26f70710426a52a364b926c9191f764601f5a8cb12761f7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/1b/2d/439b0728a92964a04d9c88ea1ca9ebb128893fbbd5834faa31f987f2fd4c/rlp-4.1.0.tar.gz"
    sha256 "be07564270a96f3e225e2c107db263de96b5bc1f27722d2855bd3459a08e95a9"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/e0/55/55b19b5f6625e7f1a8398e9f19e61843e4c651164cac10673edd412c0678/solc_select-1.1.0.tar.gz"
    sha256 "94fb6f976ab50ffccc5757d5beaf76417b27cbe15436cfe2b30cdb838f5c7516"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/8a/0b/d80dfa675bf592f636d1ea0b835eab4ec8df6e9415d8cfd766df54456123/toolz-1.0.0.tar.gz"
    sha256 "2c86e3d9a04798ac556793bced838816296a2f085017664e4995cb40a1047a02"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/6d/7f/73b3a04a53b0fd2a911d4ec517940ecd6600630b559e4505cc7b68beb5a0/types_requests-2.32.4.20250611.tar.gz"
    sha256 "741c8777ed6425830bf51e54d6abe245f79b4dcb9019f1622b773463946bf826"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/7e/5e/1660d8d0f78e3391cc48833ddd7a2bcc7e02d5cf267a5ae5defa6d3e459d/web3-7.12.1.tar.gz"
    sha256 "97f6a116ccaeb5907bb4cb6c771cc23bc942bf09528a840189e9b509b7b8347c"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
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
