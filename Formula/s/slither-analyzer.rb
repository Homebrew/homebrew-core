class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/40/e4/83b4a1bceb17dfb9f83bfc921bd47832a3252fb5b55e92b2591b28d8a3d3/slither_analyzer-0.10.3.tar.gz"
  sha256 "5e6c96c0428b79159fbb5f08ff4ed9dc0f1c47ac5af240679fc4afc34762c60b"
  license "AGPL-3.0-only"
  revision 2
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5a00fdd128fdf12aba9ea11cd27f8198bff09c2d80792cfff36df59b956a36f"
    sha256 cellar: :any,                 arm64_ventura:  "009f3f234bb4067304e52ba94d0f516b23a517854c597198a56c2e0249aa2a4d"
    sha256 cellar: :any,                 arm64_monterey: "36f9c814a9307ddf15a660e436d7ffefcbc1ee5b2ed6d8dec90c7619b9f74044"
    sha256 cellar: :any,                 sonoma:         "73983b9d982ff41c0c39482ffa35341c525e702971b27c90600799e5563b40f4"
    sha256 cellar: :any,                 ventura:        "703fc3106451b6f45bfee39c1ca11cc978eaea0d62770e22f3c882af33b6ac50"
    sha256 cellar: :any,                 monterey:       "cee9cee4fa5db3d0add21233bbb1f8fc9c1854831f6230b049c9d1cbfa721ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf86e4ff6314479928337ac10251ff828a1e6f727367c7114d44d0f22c77c29e"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.12"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/b7/c3/112f2f992aeb321de483754c1c5acab08c8ac3388c9c7e6f3e4f45ec1c42/aiohappyeyeballs-2.3.5.tar.gz"
    sha256 "6fa48b9f1317254f122a07a131a86b71ca6946ca989ce6326fff54a99a920105"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/45/11/36ba898823ab19e49e6bd791d75b9185eadef45a46fc00d3c669824df8a0/aiohttp-3.10.2.tar.gz"
    sha256 "4d1f694b5d6e459352e5e925a42e05bac66655bfde44d81c59992463d2897014"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/c7/bf/25cf92a83e1fe4948d7935ae3c02f4c9ff9cb9c13e977fba8af11a5f642c/bitarray-2.9.2.tar.gz"
    sha256 "a8f286a51a32323715d77755ed959f94bef13972e9a2fe71b609e40e6d27957e"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/fe/da/6e62e701797c627e8d8cb3d5cc0cdcb6f4a876083386ee1b1a35321fdac7/cbor2-5.6.4.tar.gz"
    sha256 "1c533c50dde86bef1c6950602054a0ffa3c376e8b0e20c7b8f5b108793f6983e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "ckzg" do
    url "https://files.pythonhosted.org/packages/13/bf/ddd817e8b455b577b206fbfee951df1f4964826e9d4f2fc3148550d592c4/ckzg-1.0.2.tar.gz"
    sha256 "4295acc380f8d42ebea4a4a0a68c424a322bb335a33bad05c72ead8cbb28d118"
  end

  resource "crytic-compile" do
    url "https://files.pythonhosted.org/packages/54/f8/6833fb37702900711e5617e0594e2eeccbb0b716993e84b00ee186907e1c/crytic-compile-0.3.7.tar.gz"
    sha256 "c7713d924544934d063e68313da8d588a3ad82cd4f40eae30d99f2dd6e640d4b"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/70/d8/8df71050b214686591241a1826d2e6934b5c295c5bc57f643e4ed697f1eb/cytoolz-0.12.3.tar.gz"
    sha256 "4503dc59f4ced53a54643272c61dc305d1dbbfbd7d6bdf296948de9f34c3a282"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/91/f7/dc714b95d07ee825f60fc62c26822a5da44b4930d362f8f5ab69eb2d7403/eth_abi-5.1.0.tar.gz"
    sha256 "33ddd756206e90f7ddff1330cc8cac4aa411a824fe779314a0a52abea2c8fc14"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/fe/f8/b61f045fd2b018e1967b1f46921396e469fb78314699f35f7f6db2059c24/eth-account-0.11.2.tar.gz"
    sha256 "b43daf2c0ae43f2a24ba754d66889f043fae4d3511559cb26eb0122bae9afbbd"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/c6/b6/57c89b91cf2dbb02b3019337f97bf346167d06cd23d3bde43c9fe52cae7e/eth-hash-0.7.0.tar.gz"
    sha256 "bacdc705bfd85dadd055ecd35fd1b4f846b671add101427e089a4ca2e8db310a"
  end

  resource "eth-keyfile" do
    url "https://files.pythonhosted.org/packages/35/66/dd823b1537befefbbff602e2ada88f1477c5b40ec3731e3d9bc676c5f716/eth_keyfile-0.8.1.tar.gz"
    sha256 "9708bc31f386b52cca0969238ff35b1ac72bd7a7186f2a84b86110d3c973bec1"
  end

  resource "eth-keys" do
    url "https://files.pythonhosted.org/packages/1f/89/127b102953f30068d6868183055d321a428d517184788a0f03afc209af0d/eth_keys-0.5.1.tar.gz"
    sha256 "2b587e4bbb9ac2195215a7ab0c0fb16042b17d4ec50240ed670bbb8f53da7a48"
  end

  resource "eth-rlp" do
    url "https://files.pythonhosted.org/packages/9b/2e/fb9c2e0a2d0e249b61abf462828f3f8039305dfbe5844e138ab1a3b3a413/eth-rlp-1.0.1.tar.gz"
    sha256 "d61dbda892ee1220f28fb3663c08f6383c305db9f1f5624dc585c9cd05115027"
  end

  resource "eth-typing" do
    url "https://files.pythonhosted.org/packages/9e/24/b913ef5d1a9ff300b05de0f0c06a4d00caa2b1b81f8c7448d069f94a4168/eth_typing-4.4.0.tar.gz"
    sha256 "93848083ac6bb4c20cc209ea9153a08b0a528be23337c889f89e1e5ffbe9807d"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/7b/54/ec65cf194c9b035df5cc00596a9eedcb430eabaf5486207e5ce859fe2aaf/eth_utils-4.1.1.tar.gz"
    sha256 "71c8d10dec7494aeed20fa7a4d52ec2ce4a2e52fdce80aab4f5c3c19f3648b25"
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
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
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/7b/91/abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7/parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/4c/90/e1c8c06235d53c3adaae74d295669612beea5f5a2052b3184a763e7bdd62/prettytable-3.10.2.tar.gz"
    sha256 "29ec6c34260191d42cd4928c28d56adec360ac2b1208a26c7e4f14b90cc8bc84"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/1b/61/0671db2ab2aee7c92d6c1b617c39b30a4cd973950118da56d77e7f397a9d/protobuf-5.27.3.tar.gz"
    sha256 "82460903e640f2b7e34ee81a947fdaad89de796d324bcbc38ff5430bcdead82c"
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
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/3f/51/64256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478/regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/0f/49/bcd4d3f9210ed78749eab04d236eeb98f98fbcc16977f308ee4637c1bad8/rlp-4.0.1.tar.gz"
    sha256 "bcefb11013dfadf8902642337923bd0c786dc8a27cb4c21da6e154e52869ecb1"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
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
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/69/c1/9fc3a82718e5de39454e8b1558d4b2d41b947c860eb8f4850bebff5ee00a/web3-6.20.1.tar.gz"
    sha256 "a29bc1863734e1c05f128ddbc56878f299ea71776806e667b581a83b5d5be0ed"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
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
