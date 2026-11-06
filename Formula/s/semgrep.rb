class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  # Pull from git tag to get submodules, https://github.com/semgrep/semgrep/issues/10877
  url "https://github.com/semgrep/semgrep.git",
      tag:      "v1.184.0",
      revision: "ac37d1f6e47b17648b8f854d6e2f2d72fade2567"
  license "LGPL-2.1-only"
  head "https://github.com/semgrep/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f2d31e283409aac572824d1f07bbc4a2eb010704eb525cfdcb8a55783a2c5952"
    sha256 cellar: :any, arm64_tahoe:       "9c526d3c0a0ca82df6bef975890eb3846fbdd56e65ed05517457376bba6a24c3"
    sha256 cellar: :any, arm64_sequoia:     "f0e565ee68c7b1c6b8b190168ee3a5556d962bda70fe788ad3391dc348bbcb1a"
    sha256               arm64_linux:       "b50b53723ba8ed722ea8466160a94c8597544456d7c2f45e14362cd9c13dd74d"
    sha256               x86_64_linux:      "ff1c0fbe257608fcc170b2b79d53879f776efcf6f9a92497327585a6608a1136"
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
  depends_on "python@3.15"
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
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
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
    url "https://files.pythonhosted.org/packages/4d/fc/137095eb2f24ccf0b4db196abd9f5cfe74398a834af51d4bc4876e0beaf0/bracex-3.2.1.tar.gz"
    sha256 "07a9b2100ceecc0c24afa1a1714bf8d4a6abb43d592939455f662b682ac9baa4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
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
    url "https://files.pythonhosted.org/packages/53/fd/f84f0600bd72953d5a322f0dedbd4f900e2cedab718e6b6a093ae2d16aae/face-26.0.1.tar.gz"
    sha256 "8183d94bc248baaea855a9f8445f97a22a9988908e60abddccc6e251da77c4c6"
  end

  resource "glom" do
    url "https://files.pythonhosted.org/packages/78/74/8387f95565ba7c30cd152a585b275ebb9a834d1d32782425c5d2fe0a102c/glom-25.12.0.tar.gz"
    sha256 "1ae7da88be3693df40ad27bdf57a765a55c075c86c971bcddd67927403eb0069"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/62/b6/bc095b23a3e0d978e75c8c18cabe4c11f791837410670e4486f0d539bfba/googleapis_common_protos-1.76.0.tar.gz"
    sha256 "71db0e44a1d4c2dd024ebad44ca67129cc1e2892e4861df466764749d5ef8642"
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
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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
    url "https://files.pythonhosted.org/packages/30/d3/f9acc21dfc886e4f78e2add1a47db46ce16884346afde53f8a064c02c891/mcp-1.29.0.tar.gz"
    sha256 "52d01f334de1868cc3bb2d6604931126a67631f99a6c5d3b82ba47290315ec36"
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
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
    url "https://files.pythonhosted.org/packages/d0/31/21d21e0e38a8f5f7a7f0cde22820117b6d17d6bc36f348129527f915d7f4/pydantic_settings-2.16.2.tar.gz"
    sha256 "3dc08ffabed2bbd5dc2dd55ead7b78b4e4c5cd776aecd04310db5f1224caaf46"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/9f/b7/15b905f6142a9a8a68f66900788da1a32e4d4254452783b37ad1eccb0506/python_multipart-0.0.33.tar.gz"
    sha256 "b8112424a6abd162ec08d390565dd113ad699f2fe6fef3c987b8bbcbfe9e390d"
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
    url "https://files.pythonhosted.org/packages/71/7f/3b8ec4f27833f7b8c270a3ef960b6d435e1065439847bc0fcd1e58ae898b/sse_starlette-3.6.0.tar.gz"
    sha256 "623151d6c20dc0eebf1b3379c27faae91fff883bac7ab6665f16f46440a88b3a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/22/de/48c59722572767841493b26183a0d1cc411d54fd759c5607c4590b6563a6/tomli-2.4.1.tar.gz"
    sha256 "7c7e1a961a0b2f2472c1ac5b69affa0ae1132c39adcb67aba98568702b9cc23f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
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
    url "https://files.pythonhosted.org/packages/18/05/ba1458dee0ac485b2a01071c1b88f5199fe878a485df482e10e1ef2205cc/zipp-4.1.2.tar.gz"
    sha256 "cf474b90b07ea932637e17c6b9479de2b2882900b0d311bdaf4f5c000a15a97f"
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
      file "Patches/libtool/configure-big_sur.diff"
      type :unofficial
    end
  end

  # Fix semgrep-core crash on Linux with Python 3.15, where `RLIM_INFINITY` became a huge positive value
  patch do
    url "https://github.com/daeho-ro/semgrep/commit/b111bda71b66813dc44741ba9c85c17e1c1f30d9.patch?full_index=1"
    sha256 "27a2d4120e40d518ad3f267d7357c74410e6a91e4c99718879be2b0edcc3eeb5"
    type :unofficial
    resolves "https://github.com/semgrep/semgrep/issues/11979"
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
      s.gsub!("$(brew --prefix libev)/lib/libev.a", formula_opt_lib("libev")/shared_library("libev"))
      s.gsub!("$(brew --prefix zstd)/lib/libzstd.a", formula_opt_lib("zstd")/shared_library("libzstd"))
      s.gsub!("$(pkg-config gmp --variable libdir)/libgmp.a", formula_opt_lib("gmp")/shared_library("libgmp"))
      s.gsub!(
        "$(pkg-config tree-sitter --variable libdir)/libtree-sitter.a",
        formula_opt_lib("tree-sitter")/shared_library("libtree-sitter"),
      )
      s.gsub!(
        "$(pkg-config libpcre2-8 --variable libdir)/libpcre2-8.a",
        formula_opt_lib("pcre2")/shared_library("libpcre2-8"),
      )
      s.gsub!(
        '"$(brew --prefix dwarfutils)/lib/libdwarf.a"',
        formula_opt_lib("dwarfutils")/shared_library("libdwarf"),
      )
    end

    ENV.deparallelize
    ENV["OPAMROOT"] = buildpath/".opam"
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
    # `./scripts/build-static-libcurl.sh` and pins a forked OCaml compiler.
    # Instead, we manually replicate its steps:
    # 1. Install opam dependencies (taken from the --deps-only invocation in the
    # Semgrep Makefile's `install-opam-deps` target)
    system "opam", "update", "-y"
    ENV["LWT_DISCOVER_ARGUMENTS"] = "--use-libev true"
    system "opam", "install", "--locked", "--update-invariant",
           "--confirm-level=unsafe-yes", "-y", "--deps-only",
           "./semgrep.opam", "./dev/required.opam"

    # 2. Finally build semgrep-core using the usual Makefile targets, skipping
    # `tree-sitter-runtime` so it links Homebrew's tree-sitter instead of downloading one
    system "opam", "exec", "--", "make", "-o", "tree-sitter-runtime", "core",
           "TREESITTER_OUT=#{formula_opt_prefix("tree-sitter")}"
    system "opam", "exec", "--", "make", "copy-core-for-cli"

    bin.install "_build/install/default/bin/semgrep-core"

    ENV["SEMGREP_SKIP_BIN"] = "1"
    venv = virtualenv_create(libexec, python3)
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
