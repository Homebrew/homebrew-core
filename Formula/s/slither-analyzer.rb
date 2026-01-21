class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/b0/e8/bf6efe567dffbab0d850bd2395a7a1db68fe1a95bfb507854be00571832c/slither_analyzer-0.11.5.tar.gz"
  sha256 "d90af76b86bdf7ced56fc4c8eea8792cde1ec2c375372d5e70298c2ff998d5e1"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f17aeaa976e408924e20bd3923538c90cc9a238b20aa2a1c0d00c1fbda19c7e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "136b072b1288d77c9781722e914c72718d13aa96f2b4a8b0093653155f6a9692"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e537ba28925d3f9fd928cca443f30d4c4058cc6afbb0e5d84909254f98f4c876"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b443adeeb07c785bbad7f228727ac857471547087d6ac01f9861807c2186a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ca48f6b8798e2f03ec3f80eb71af11e8139dad8dbb748788d625487371436a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e45d967f4569886b658a7ebce8dd44a1afea6eee9794b9a2338bba725a28945"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/50/42/32cf8e7704ceb4481406eb87161349abb46a57fee3f008ba9cb610968646/aiohttp-3.13.3.tar.gz"
    sha256 "a949eee43d3782f2daae4f4a2819b2cb9b0c5d3b7f7a927067cc84dafdbb9f88"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/95/06/92fdc84448d324ab8434b78e65caf4fb4c6c90b4f8ad9bdd4c8021bfaf1e/bitarray-3.8.0.tar.gz"
    sha256 "3eae38daffd77c9621ae80c16932eea3fb3a4af141fb7cc724d4ad93eff9210d"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/8e/8b4fdde28e42ffcd741a37f4ffa9fb59cd4fe01625b544dfcfd9ccb54f01/cbor2-5.8.0.tar.gz"
    sha256 "b19c35fcae9688ac01ef75bad5db27300c2537eb4ee00ed07e05d8456a0d4931"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "ckzg" do
    url "https://files.pythonhosted.org/packages/b1/e8/b262fff67d6bcaecd19c71d19ebea9184a1204e00368664e1544a2511bd8/ckzg-2.1.5.tar.gz"
    sha256 "e48e092f9b89ebb6aaa195de2e2bb72ad2d4b35c87d3a15e4545f13c51fbbe30"
  end

  resource "crytic-compile" do
    url "https://files.pythonhosted.org/packages/f4/cb/669ed02fbfe17091998f52a7e3326ac276409117ea10a2c36b2a852a22f9/crytic_compile-0.3.11.tar.gz"
    sha256 "d4e2253d5d81ec3a75deb3ab9fc2c2d2db56e835001cf07f3703911d74b56716"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/bd/d4/16916f3dc20a3f5455b63c35dcb260b3716f59ce27a93586804e70e431d5/cytoolz-1.1.0.tar.gz"
    sha256 "13a7bf254c3c0d28b12e2290b82aed0f0977a4c2a2bf84854fcdc7796a29f3b0"
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
    url "https://files.pythonhosted.org/packages/e6/e1/ee3a8728227c3558853e63ff35bd4c449abdf5022a19601369400deacd39/eth_utils-5.3.1.tar.gz"
    sha256 "c94e2d2abd024a9a42023b4ddc1c645814ff3d6a737b33d5cfd890ebf159c2d1"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "hexbytes" do
    url "https://files.pythonhosted.org/packages/7f/87/adf4635b4b8c050283d74e6db9a81496063229c9263e6acc1903ab79fbec/hexbytes-1.3.1.tar.gz"
    sha256 "a657eebebdfe27254336f98d8af6e2236f3f83aed164b87466b6cf6c5f5a4765"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
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
    url "https://files.pythonhosted.org/packages/79/45/b0847d88d6cfeb4413566738c8bbf1e1995fad3d42515327ff32cc1eb578/prettytable-3.17.0.tar.gz"
    sha256 "59f2590776527f3c9e8cf9fe7b66dd215837cca96a9c39567414cbc632e8ddb0"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pyunormalize" do
    url "https://files.pythonhosted.org/packages/25/ab/b912c484cfb96ba4834efe050bbf10c9e157bd8189eb859aefba8712b136/pyunormalize-17.0.0.tar.gz"
    sha256 "0949a3e56817e287febcaf1b0cc4b5adf0bb107628d379335938040947eec792"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/0b/86/07d5056945f9ec4590b518171c4254a5925832eb727b56d3c38a7476f316/regex-2026.1.15.tar.gz"
    sha256 "164759aa25575cbc0651bef59a0b18353e54300d79ace8084c818ad8ac72b7d5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/1b/2d/439b0728a92964a04d9c88ea1ca9ebb128893fbbd5834faa31f987f2fd4c/rlp-4.1.0.tar.gz"
    sha256 "be07564270a96f3e225e2c107db263de96b5bc1f27722d2855bd3459a08e95a9"
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
    url "https://files.pythonhosted.org/packages/0f/f3/a0663907082280664d745929205a89d41dffb29e89a50f753af7d57d0a96/types_requests-2.32.4.20260107.tar.gz"
    sha256 "018a11ac158f801bfa84857ddec1650750e393df8a004a8a9ae2a9bec6fcb24f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/4c/85/1515644dc1b0170e43e8c26531a3cec8ebc916185fbe2db0020e450b7114/web3-7.14.0.tar.gz"
    sha256 "d82c78007c280e478b3920cd56658df17f2f76af584ee3318df6b60d4944b8a2"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
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
