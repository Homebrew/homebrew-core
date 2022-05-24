class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/4.0.3.tar.gz"
  sha256 "d4f1bb1cb0e3aa124489b5e71f6b9980a5054d48bcae2209b38a7aec1880e670"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/laramies/theHarvester.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c01d75b9afd1cc9d8276e4d6c8abd7067e1ef6a67f9be8c7d0a6a4023dfa3920"
    sha256 cellar: :any,                 arm64_big_sur:  "dc44a2ca9c42e9e1871cf137dcdf1197964be70d88d3893c6a4d05927b15cca8"
    sha256 cellar: :any,                 monterey:       "1b65e4ba8faac81b34b25ebb6d3ff06a96f493b1c44c81d7df0f344993fd20b9"
    sha256 cellar: :any,                 big_sur:        "19bd48d157841ef1ee9abd55541bbefabf6107aaa1b5be6da2d2bb1a739c9f96"
    sha256 cellar: :any,                 catalina:       "ed2bd4cddadf322c1311b016a8dd0cb1a7c41bb64dfdb50eb107aa0b6b626e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fefa2c447aad1c51561b75d1707da6a6eed83ef070fd12590ab93b0ef37f5c71"
  end

  depends_on "maturin" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # How to update the resources
  # tar -zxvf theHarvester-4.0.3.tar.gz
  # cd theHarvester-4.0.3 && virtualenv -p python3.10 . && source bin/activate && pip install -r requirements/base.txt
  # pip freeze > dependencies.log
  # run homebrew-pypi-poet on the freezed dependencies
  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/27/79/df72e25df0fdd9bf5a5ab068539731d27c5f2ae5654621ae0c92ceca94cf/aiodns-3.0.0.tar.gz"
    sha256 "946bdfabe743fceeeb093c8a010f5d1645f708a241be849e17edfb0e49e08cd6"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/06/f0/af90f3fb4066b0707b6a5af3ffd5fd9b3809bbb52f0153a3c7550e594de3/aiofiles-0.7.0.tar.gz"
    sha256 "a1c4fc9b2ff81568c83e21392a82f344ea9d23da906e4f6a52662764545e19d4"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/5a/86/5f63de7a202550269a617a5d57859a2961f3396ecd1739a70b92224766bc/aiohttp-3.8.1.tar.gz"
    sha256 "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/59/30/64e01ec7ecb4aa1123b54401ffc36c16bb1d7155b924f7430a651fb956c1/aiomultiprocess-0.9.0.tar.gz"
    sha256 "07e7d5657697678d9d2825d4732dfd7655139762dee665167380797c02c68848"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/40/e0/ad1edd74311831ca71b32a5b83352b490d78d11a90a1cde04e1b6830e018/aiosqlite-0.17.0.tar.gz"
    sha256 "f0e6acc24bc4864149267ac82fb46dfb3be4455f99fe21df82609cc6e6baee51"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/dc/e7/7452227e8c091db6838d7f1b50dc4e6323e8463ed8c2d0b651ac9b7f7fce/anyio-3.4.0.tar.gz"
    sha256 "24adc69309fb5779bc1e06158e143e0b6d2c56b302a3ac3de3083c705a6ed39d"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/07/93/3618b68b4ba6b54bc97b5fd7d90e4981471edfaf51c8321a29a3c76cf47c/asgiref-3.4.1.tar.gz"
    sha256 "4ef1ab46b484e3c706329cedeff284a5d40824200638503f5768edb6de7d58e9"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/ce/cf/9452ab2a5936f96aa94e3c1cf21e8038b643cd27f33aeebc3aea5d25bcd1/async-timeout-4.0.1.tar.gz"
    sha256 "b930cb161a39042f9222f6efb7301399c87eeab394727ec5437924a36d6eef51"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/27/d2/9d2d0f0d6bbe17628b031040b1dadaee616286267e660ad5286a5ed657da/backoff-1.11.1.tar.gz"
    sha256 "ccb962a2378418c667b3c979b504fdeb7d9e0d29c0579e3b13b86467177728cb"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "censys" do
    url "https://files.pythonhosted.org/packages/39/7d/1d8fcaf0b589cbd48f6655efaf5c12eb85dd2fdcd0838d9f5a2b5fa74a77/censys-2.0.9.tar.gz"
    sha256 "5a062f2b97f806879896c6a2a350fd36cae5724ae240abf0c2de40895b043a61"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "dataclasses" do
    url "https://files.pythonhosted.org/packages/59/e4/2f921edfdf1493bdc07b914cbea43bc334996df4841a34523baf73d1fb4f/dataclasses-0.6.tar.gz"
    sha256 "6988bd2b895eef432d562370bb707d540f32f7360ab13da45340101bc2307d84"
  end

  resource "dataclasses-json" do
    url "https://files.pythonhosted.org/packages/b1/fe/b0e2720f03125b64c0d0bf9078923f535ccd11a92abba6967920c33091a0/dataclasses-json-0.5.6.tar.gz"
    sha256 "1f60be3405dee30b86ffbf6a436db8ba5efaeeb676bfda358e516a97aa7dfce4"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/13/27/5277de856f605f3429d752a39af3588e29d10181a3aa2e2ee471d817485a/dnspython-2.1.0.zip"
    sha256 "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/e6/35/384bc3bf9a4926a45052037e0bf0806ffeda237b8b731cb04a5e1e1c6a45/fastapi-0.70.0.tar.gz"
    sha256 "66da43cfe5185ea1df99552acffd201f1832c6b364e0f4136c0a99f933466ced"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/5c/ee/7c6287928ba776567603248e160387cf4143641ecf734e393ad9b2c82475/frozenlist-1.2.0.tar.gz"
    sha256 "68201be60ac56aff972dc18085800b6ee07973c49103a8aba669dee3d71079de"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/2e/6d/4508b1922b1610f6646fd95681fa1b0c092df35ec14018218f4638b7342a/importlib_metadata-4.8.2.tar.gz"
    sha256 "75bdec14c397f528724c1bfd9709d660b33a4d2e77387a3358f20b848bb5e5fb"
  end

  resource "limiter" do
    url "https://files.pythonhosted.org/packages/b2/e1/2aa236d8d3f257515604ab66e5a13a59ca1b27fce8412848f17750702e90/limiter-0.1.2.tar.gz"
    sha256 "5608e4b6c0990b30a3477effe1fb48c969bf037963da689b946654944da4f997"
  end

  resource "limits" do
    url "https://files.pythonhosted.org/packages/f8/80/3e208b8cfdcf9bf85006097a53c93f53a0c23bc711f1e6abfc180ebb4bca/limits-1.6.tar.gz"
    sha256 "6c0a57b42647f1141f5a7a0a8479b49e4367c24937a01bd9d4063a595c2dd48a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/fe/4c/a4dbb4e389f75e69dbfb623462dfe0d0e652107a95481d40084830d29b37/lxml-4.6.4.tar.gz"
    sha256 "daf9bd1fee31f1c7a5928b3e1059e09a8d683ea58fb3ffc773b6c88cb8d1399c"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/ff/04/9a03e7e8e68b1cee2396f51d41cd8741920a8c7b74b32a9e6b29da56e40f/marshmallow-3.14.1.tar.gz"
    sha256 "4c05c1684e0e97fe779c62b91878f173b937fe097b356cd82f793464f5bc6138"
  end

  resource "marshmallow-enum" do
    url "https://files.pythonhosted.org/packages/8e/8c/ceecdce57dfd37913143087fffd15f38562a94f0d22823e3c66eac0dca31/marshmallow-enum-1.5.1.tar.gz"
    sha256 "38e697e11f45a8e64b4a1e664000897c659b60aa57bfa18d44e226a9920b6e58"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/8e/7c/e12a69795b7b7d5071614af2c691c97fbf16a2a513c66ec52dd7d0a115bb/multidict-5.2.0.tar.gz"
    sha256 "0dd1c93edb444b33ba2274b66f63def8a327d607c6c790772f448a53b6ea59ce"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/83/61/17bd0cfb9c4dc8c3738484d604b50d47c78fe4fcfe0ca2c58a61a106f578/pycares-4.1.2.tar.gz"
    sha256 "03490be0e7b51a0c8073f877bec347eff31003f64f57d9518d419d9369452837"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b9/d2/12a808613937a6b98cd50d6467352f01322dc0d8ca9fb5b94441625d6684/pydantic-1.8.2.tar.gz"
    sha256 "26464e57ccaafe72b7ad156fdaa4e9b9ef051f69e175dbbb463283000c05ab7b"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/e6/88/a917aaa0da1915292022745184275e095516b490a85d89fc48fd4de1c01a/pyee-8.2.2.tar.gz"
    sha256 "5c7e60f8df95710dbe17550e16ce0153f83990c00ef744841b43f371ed53ebea"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "pyppeteer" do
    url "https://files.pythonhosted.org/packages/d9/bd/aee9896b82f5c74612586743a006fbdc02515277ffb62409b57e68934f6a/pyppeteer-0.2.6.tar.gz"
    sha256 "4621bb890e54f43dce84f5139ea4d484a62886be1903c2fcb393af607943538f"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/b3/17/1e567ff78c83854e16b98694411fe6e08c3426af866ad11397cddceb80d3/redis-3.5.3.tar.gz"
    sha256 "0e7e0cfca8660dea8b7d5cd8c4f6c5e29e11f31158c0b0ae91a397f00e5a05a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/35/fc/d58c1464a38b9455a4bedb36d5e345b11b5158c3af10efac7e6df4bf0551/responses-0.13.4.tar.gz"
    sha256 "9476775d856d3c24ae660bbebe29fb6d789d4ad16acd723efbfb6ee20990b899"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/3b/5a90d0f197087896472757ebd9ac29d802ccc4f6953d99a535b1a8db2bf6/rich-10.16.1.tar.gz"
    sha256 "4949e73de321784ef6664ebbc854ac82b20ff60b2865097b93f3b9b41e30da27"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c8/87/ba5671b333f1016a306f2e762fe762fbc9c3696614f6db3ce6171641005f/shodan-1.25.0.tar.gz"
    sha256 "7e2bddbc1b60bf620042d0010f4b762a80b43111dbea9c041d72d4325e260c23"
  end

  resource "slowapi" do
    url "https://files.pythonhosted.org/packages/75/0b/9a7399a27c9d18b983fb5843cff3e45b632ed2f7ba5db006e3190408c8c9/slowapi-0.1.5.tar.gz"
    sha256 "bad09be48446dede7f5db3dba87802b3a1166a395fbbe6d920598067d1f36ce3"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/e1/25/a3005eedafb34e1258458e8a4b94900a60a41a2b4e459e0e19631648a2a0/soupsieve-2.3.1.tar.gz"
    sha256 "b8d49b1cd4f037c7082a9683dfa1801aa2597fb11c3a1155b7a5b94829b4f1f9"
  end

  resource "spyse-python" do
    url "https://files.pythonhosted.org/packages/95/4b/4153143ff130e4f60266bd514472884e1dbfcb62fdf91f58e052971776a6/spyse-python-2.2.3.tar.gz"
    sha256 "d193e29e0d70112043d1a9c1ee98984dc4843fd2ee29fce632f2896843bab533"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/f8/df/a8d016fd23b72cd0264f48bdf9897179156e8c30118978b40460a1e18bd2/starlette-0.16.0.tar.gz"
    sha256 "e1904b5d0007aee24bdd3c43994be9b3b729f4f58e740200de1d623f8c3a8870"
  end

  resource "token-bucket" do
    url "https://files.pythonhosted.org/packages/74/fb/5c7681fce00acca5df34d63f1b4ee441df72157a92b24e4992f00e69e6c1/token_bucket-0.2.0.tar.gz"
    sha256 "76305d9dbe875d3b033b5bf208cc2cf78c003129378108ab1bae919a42b108da"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e3/c1/b3e42d5b659ca598508e2a9ef315d5eef0a970f874ef9d3b38d4578765bd/tqdm-4.62.3.tar.gz"
    sha256 "d359de7217506c9851b7869f3708d8ee53ed70a1b8edbba4dbcb47442592920d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/c3/da/864ce66818e308b38209d4b1ef0585921d28eb07621ba7d905a0e96bcc80/typing_inspect-0.7.1.tar.gz"
    sha256 "047d4097d9b17f46531bf6f014356111a1b6fb821a24fe7ac909853ca2a782aa"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/21/93/ba928551a83251be01f673755819f95a568cda0bfb9e0859be80086dce93/ujson-4.3.0.tar.gz"
    sha256 "baee56eca35cb5fbe02c28bd9c0936be41a96fa5c0812d9d4b7edeb5c3d568a0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/3c/06/758c0ce8fe0053a86c99824c69eaabf0dacf2a0d935a9cfde18bbef9360a/uvicorn-0.15.0.tar.gz"
    sha256 "d9a3c0dd1ca86728d3e235182683b4cf94cd53a867c288eaeca80ee781b2caff"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/ab/d9/22bbffa8f8d7e075ccdb29e8134107adfb4710feb10039f9d357db8b589c/uvloop-0.16.0.tar.gz"
    sha256 "f74bc20c7b67d1c27c72601c78cf95be99d5c2cdd4514502b4f3eb0933ff1228"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/0d/bd/5262054455ab2067e51de331bfbc53a1dfa9071af7c424cf7c0793c4349a/websockets-9.1.tar.gz"
    sha256 "276d2339ebf0df4f45df453923ebd2270b87900eda5dfd4a6b0cfa15f82111c3"
  end

  resource "XlsxWriter" do
    url "https://files.pythonhosted.org/packages/cc/52/336ea010eda5cc4246c2696fc8d679634b1cbe5971a5cc8c151c051f0b4b/XlsxWriter-3.0.2.tar.gz"
    sha256 "53005f03e8eb58f061ebf41d5767c7495ee0772c2396fe26b7e0ca22fa9c2570"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/02/bf/0d03dbdedb83afec081fefe86cae3a2447250ef1a81ac601a9a56e785401/zipp-3.6.0.tar.gz"
    sha256 "71c644c5369f4a6e07636f0aa966270449561fcea2e3d6747b8d23efaa9d7832"
  end

  def install
    inreplace "setup.py", "/etc/theHarvester", etc/"theharvester"
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/theHarvester" => "theharvester"
  end

  test do
    (testpath/"proxies.yaml").write <<~EOS
      http:
      - ip:port
    EOS

    output = shell_output("#{bin}/theharvester -d brew.sh -l 1 -b google 2>&1")
    assert_match "docs.brew.sh:", output
  end
end
