class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  # Pull from git tag to get submodules, https://github.com/semgrep/semgrep/issues/10877
  url "https://github.com/semgrep/semgrep.git",
      tag:      "v1.165.0",
      revision: "4cc850aff696dce0f6beddd4bb72db7f4c9abbc0"
  license "LGPL-2.1-only"
  head "https://github.com/semgrep/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fdb3edf188038b047b05789b0870ae79c01ad5df1d9fdd08eece31f0731082ba"
    sha256 cellar: :any, arm64_sequoia: "0cdd1597e29dcd26cab4781b12f35a90b82fe23bbc08242551d57cdcbfbfb32b"
    sha256 cellar: :any, arm64_sonoma:  "698f24dc2c07684fc77d7943e136e2e4aa590e2996200fb4c323ee423d1a9c7b"
    sha256 cellar: :any, sonoma:        "5da9a1c9c89c62b6f67269bf98d2bc5b0265bd81690f837b0298d393ea67edb9"
    sha256               arm64_linux:   "4a6030964062a8d7eed14081e3d6d525cb73612a862a0b89fba6f43b8174dd11"
    sha256               x86_64_linux:  "ebad958f1edf6b69178eea4b6a62b74be1650d8dbbefe2deade584f7aa139273"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "dwarfutils"
  depends_on "gmp"
  depends_on "libev"
  depends_on "pcre2"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage
  depends_on "sqlite"
  depends_on "tree-sitter"
  depends_on "zstd"

  uses_from_macos "rsync" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "elfutils"
    depends_on "libunwind"
  end

  pypi_packages package_name:     "semgrep",
                exclude_packages: %w[certifi cryptography pydantic rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/ad/1f/6c0608d86e0fc77c982a2923ece80eef85f091f2332fc13cbce41d70d502/boltons-21.0.0.tar.gz"
    sha256 "65e70a79a731a7fe6e98592ecfb5ccf2115873d01dbc576079874629e5c90f13"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/ef/ff/d291d66595b30b83d1cb9e314b2c9be7cfc7327d4a0d40a15da2416ea97b/click_option_group-0.5.9.tar.gz"
    sha256 "f94ed2bc4cf69052e0f29592bd1e771a1789bd7bfc482dd0bc482134aff95823"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/09/35/2495c4ac46b980e4ca1f6ad6db102322ef3ad2410b79fdde159a4b0f3b92/exceptiongroup-1.2.2.tar.gz"
    sha256 "47c2edf7c6738fafb49fd34290706d1a1a2f4d1c6df275526b62cbb4aa5393cc"
  end

  resource "face" do
    url "https://files.pythonhosted.org/packages/24/4e/0e106b0ba486cc38c858fb5efe899002f2ec4765e0808b298d8e19a16efb/face-26.0.0.tar.gz"
    sha256 "ae12136ff0052f124811f5319670a8d9d29b7d2caaaabe542813690967cc6bca"
  end

  resource "glom" do
    url "https://files.pythonhosted.org/packages/78/74/8387f95565ba7c30cd152a585b275ebb9a834d1d32782425c5d2fe0a102c/glom-25.12.0.tar.gz"
    sha256 "1ae7da88be3693df40ad27bdf57a765a55c075c86c971bcddd67927403eb0069"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f3/49/3b30cad09e7771a4982d9975a8cbf64f00d4a1ececb53297f1d9a7be1b10/importlib_metadata-8.7.1.tar.gz"
    sha256 "49fef1ae6440c182052f407c8d34a68f72efc36db9ca90dc0113398f2fdde8bb"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/a7/a4/d06a303f45997e266f2c228081abe299bbcba216cb806128e2e49095d25f/mcp-1.23.3.tar.gz"
    sha256 "b3b0da2cc949950ce1259c7bfc1b081905a51916fcd7c8182125b85e70825201"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/63/04/05040d7ce33a907a2a02257e601992f0cdf11c73b33f13c4492bf6c3d6d5/opentelemetry_api-1.37.0.tar.gz"
    sha256 "540735b120355bd5112738ea53621f8d5edb35ebcd6fe21ada3ab1c61d1cd9a7"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/dc/6c/10018cbcc1e6fff23aac67d7fd977c3d692dbe5f9ef9bb4db5c1268726cc/opentelemetry_exporter_otlp_proto_common-1.37.0.tar.gz"
    sha256 "c87a1bdd9f41fdc408d9cc9367bb53f8d2602829659f2b90be9f9d79d0bfe62c"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/5d/e3/6e320aeb24f951449e73867e53c55542bebbaf24faeee7623ef677d66736/opentelemetry_exporter_otlp_proto_http-1.37.0.tar.gz"
    sha256 "e52e8600f1720d6de298419a802108a8f5afa63c96809ff83becb03f874e44ac"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/f6/36/7c307d9be8ce4ee7beb86d7f1d31027f2a6a89228240405a858d6e4d64f9/opentelemetry_instrumentation-0.58b0.tar.gz"
    sha256 "df640f3ac715a3e05af145c18f527f4422c6ab6c467e40bd24d2ad75a00cb705"
  end

  resource "opentelemetry-instrumentation-requests" do
    url "https://files.pythonhosted.org/packages/36/42/83ee32de763b919779aaa595b60c5a7b9c0a4b33952bbe432c5f6a783085/opentelemetry_instrumentation_requests-0.58b0.tar.gz"
    sha256 "ae9495e6ff64e27bdb839fce91dbb4be56e325139828e8005f875baf41951a2e"
  end

  resource "opentelemetry-instrumentation-threading" do
    url "https://files.pythonhosted.org/packages/70/a9/3888cb0470e6eb48ea17b6802275ae71df411edd6382b9a8e8f391936fda/opentelemetry_instrumentation_threading-0.58b0.tar.gz"
    sha256 "f68c61f77841f9ff6270176f4d496c10addbceacd782af434d705f83e4504862"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/dd/ea/a75f36b463a36f3c5a10c0b5292c58b31dbdde74f6f905d3d0ab2313987b/opentelemetry_proto-1.37.0.tar.gz"
    sha256 "30f5c494faf66f77faeaefa35ed4443c5edb3b0aa46dad073ed7210e1a789538"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/f4/62/2e0ca80d7fe94f0b193135375da92c640d15fe81f636658d2acf373086bc/opentelemetry_sdk-1.37.0.tar.gz"
    sha256 "cc8e089c10953ded765b5ab5669b198bbe0af1b3f89f1007d19acd32dc46dda5"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/aa/1b/90701d91e6300d9f2fb352153fb1721ed99ed1f6ea14fa992c756016e63a/opentelemetry_semantic_conventions-0.58b0.tar.gz"
    sha256 "6bd46f51264279c433755767bb44ad00f1c9e2367e1b42af563372c5a6fa0c25"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/c6/5f/02f31530faf50ef8a41ab34901c05cbbf8e9d76963ba2fb852b0b4065f4e/opentelemetry_util_http-0.58b0.tar.gz"
    sha256 "de0154896c3472c6599311c83e0ecee856c4da1b17808d39fdc5cce5312e4d89"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "peewee" do
    url "https://files.pythonhosted.org/packages/88/b0/79462b42e89764998756e0557f2b58a15610a5b4512fbbcccae58fba7237/peewee-3.19.0.tar.gz"
    sha256 "f88292a6f0d7b906cb26bca9c8599b8f4d8920ebd36124400d0cbaaaf915511f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/07/60/1d1e59c9c90d54591469ada7d268251f71c24bdb765f1a8a832cee8c6653/pydantic_settings-2.14.1.tar.gz"
    sha256 "e874d3bec7e787b0c9958277956ed9b4dd5de6a80e162188fdaff7c5e26fd5fa"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/4b/82/c8cd43a6e0719bf5a3b034f6726dd701f75829c08944c83d4b95d02ed0e8/python_multipart-0.0.30.tar.gz"
    sha256 "0edfe0475c1f46ddd3ff7785a626f6118af32bdcf359bb21260367313bb32118"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/ea/97/60fda20e2fb54b83a61ae14648b0817c8f5d84a3821e40bfbdae1437026a/ruamel_yaml_clib-0.2.15.tar.gz"
    sha256 "46e4cc8c43ef6a94885f72512094e482114a8a706d3c555a34ed4b0d20200600"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/f7/2b/58abc2d1fd397e7dde08e947e05c884d8ef2f78d5e2588c17a12d42d6994/sse_starlette-3.4.4.tar.gz"
    sha256 "07e0fa0460138baf25cdd5fb28683472c3995dc1642225191b3832d62526bcb0"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/25/44/ec35f1b6e83094b997da438a02c8c9b0ade2b1e84cfc48bd4656780760a6/starlette-1.2.1.tar.gz"
    sha256 "9b9b5ebb992e67d6093741e63c2f59e4f6fff986f81163c087867bd7b924b3f6"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/22/de/48c59722572767841493b26183a0d1cc411d54fd759c5607c4590b6563a6/tomli-2.4.1.tar.gz"
    sha256 "7c7e1a961a0b2f2472c1ac5b69affa0ae1132c39adcb67aba98568702b9cc23f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c4/1f/fa18009dea8469069cca78a4e877a008ab78f08b064bfc9ab891579077ff/uvicorn-0.49.0.tar.gz"
    sha256 "ebf4271aa580d9de97f93192d4595176df6e91f9aae919ca73e4fc07df1e66a3"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/ea/c4/55e0d36da61d7b8b2a49fd273e6b296fd5e8471c72ebbe438635d1af3968/wcmatch-8.5.2.tar.gz"
    sha256 "a70222b86dea82fb382dd87b73278c10756c138bd6f8f714e2183128887b9eb2"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/b9/d8/eab98a517c14134c0b2eb4e2387bc5f457334293ec5d2dd3857ec2966802/zipp-4.1.0.tar.gz"
    sha256 "4cb57381f544315db7688e976e922a2b18cdb513d21cc194eb42232ba2a3e602"
  end

  # Due to the popularity of Semgrep, we provide an exception to bundle a copy of
  # EOL `pcre` until the upstream has completely migrated to `pcre2`. This allows
  # us to deprecate the `pcre` formula and avoid unwanted usage in core formulae.
  resource "pcre" do
    url "https://downloads.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.bz2"
    mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.45.tar.bz2"
    sha256 "4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8"

    livecheck do
      skip "PCRE was declared end of life in 2021-06"
    end

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  def install
    resource("pcre").stage do
      # Only need to build 8 bit static library (libpcre.a)
      args = %w[--disable-shared --disable-cpp --enable-unicode-properties --with-pic]
      args << "--enable-jit" if OS.mac? && !Hardware::CPU.arm?

      system "./configure", *args, *std_configure_args(prefix: buildpath/"pcre")
      system "make", "install"
      ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"pcre/lib/pkgconfig"
    end

    # Ensure dynamic linkage to our libraries
    inreplace "src/main/flags.sh" do |s|
      s.gsub!("$(brew --prefix libev)/lib/libev.a", Formula["libev"].opt_lib/shared_library("libev"))
      s.gsub!("$(brew --prefix zstd)/lib/libzstd.a", Formula["zstd"].opt_lib/shared_library("libzstd"))
      s.gsub!("$(pkg-config gmp --variable libdir)/libgmp.a", Formula["gmp"].opt_lib/shared_library("libgmp"))
      s.gsub!(
        "$(pkg-config tree-sitter --variable libdir)/libtree-sitter.a",
        Formula["tree-sitter"].opt_lib/shared_library("libtree-sitter"),
      )
      s.gsub!(
        "$(pkg-config libpcre2-8 --variable libdir)/libpcre2-8.a",
        Formula["pcre2"].opt_lib/shared_library("libpcre2-8"),
      )
      s.gsub!(
        '"$(brew --prefix dwarfutils)/lib/libdwarf.a"',
        Formula["dwarfutils"].opt_lib/shared_library("libdwarf"),
      )
    end

    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      # `--no-depexts` prevents opam from attempting to automatically search for
      # and install system dependencies using the os-native package manager.
      # On Linux, this leads to confusing and inaccurate `Missing dependency`
      # errors due to querying `apt`. See:
      #   https://github.com/Homebrew/homebrew-core/pull/82693
      #   https://github.com/Homebrew/homebrew-core/pull/176636
      #   https://github.com/ocaml/opam/pull/4548
      ENV["OPAMNODEPEXTS"] = ENV["OPAMYES"] = "1"
      # Set library path so opam + lwt can find libev
      ENV["LIBRARY_PATH"] = "#{HOMEBREW_PREFIX}/lib"
      # Opam's solver times out when it is set to the default of 60.0
      # See: https://github.com/Homebrew/homebrew-core/pull/191306
      ENV["OPAMSOLVERTIMEOUT"] = "1200"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.5.3.0" }

      # We can't use `make install-deps-for-semgrep-core` directly because it runs
      # `./scripts/install-tree-sitter-lib` which would conflict with Homebrew's
      # tree-sitter dependency. Instead, we manually replicate its steps:
      # 1. Configure tree-sitter (using homebrew's tree-sitter)
      cd "./libs/ocaml-tree-sitter-core" do
        system "./configure"
      end

      # 2. Proceed with installing opam dependencies (taken from the --deps-only
      # invocation in the Semgrep Makefile's `install-opam-deps` target)
      system "opam", "update", "-y"
      ENV["LWT_DISCOVER_ARGUMENTS"] = "--use-libev true"
      system "opam", "install", "--locked", "--update-invariant",
             "--confirm-level=unsafe-yes", "-y", "--deps-only",
             "./semgrep.opam", "./dev/required.opam"

      # 3. Finally build semgrep-core using the usual Makefile targets
      system "opam", "exec", "--", "make", "core"
      system "opam", "exec", "--", "make", "copy-core-for-cli"

      bin.install "_build/install/default/bin/semgrep-core" => "semgrep-core"
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources.reject { |r| r.name == "pcre" }

    venv.pip_install_and_link buildpath/"cli"
  end

  test do
    system bin/"semgrep", "--help"
    (testpath/"script.py").write <<~PYTHON
      def silly_eq(a, b):
        return a + b == a + b
    PYTHON

    output = shell_output("#{bin}/semgrep script.py -l python -e '$X == $X'")
    assert_match "a + b == a + b", output

    (testpath/"script.ts").write <<~TYPESCRIPT
      function test_equal() {
        a = 1;
        b = 2;
        //ERROR: match
        if (a + b == a + b)
            return 1;
        return 0;
      }
    TYPESCRIPT

    output = shell_output("#{bin}/semgrep script.ts -l ts -e '$X == $X'")
    assert_match "a + b == a + b", output
  end
end
