class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  # Pull from git tag to get submodules, https://github.com/semgrep/semgrep/issues/10877
  # NOTE: When bumping version, make sure to update Python resources. One way to do this is,
  # 1. comment out `pcre` resource
  # 2. run `brew update-python-resources semgrep`
  # 3. uncomment `pcre` resource
  url "https://github.com/semgrep/semgrep.git",
      tag:      "v1.146.0",
      revision: "079e05d08b86ec1b07509d2e755c631156d3705b"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/semgrep/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: "contains non-PyPI resources"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "603a50f804d5eb99c3a46c13cd044da69f38fe21c360dc8034138fb7cfcb2f6e"
    sha256 cellar: :any, arm64_sequoia: "b13bf222207312424553050ddb2b378ed7825a47fcfe59764c4cfd7ec360c6c6"
    sha256 cellar: :any, arm64_sonoma:  "fa7b435b66176a2ca00c6d7bf4a94a097b80f7fc40ef9857c8eca285c5d67023"
    sha256 cellar: :any, sonoma:        "16f0ca619861bde599dd3479681b16e509995c8dc37c55c9ca20d16ae8e685be"
    sha256               arm64_linux:   "62ea451a2aef829b84e3b157bb8703d0224c4fa5acc90e729e352df1e3218494"
    sha256               x86_64_linux:  "e83d0d6e33804a8a1eb2a0b644ba03a92e299b4f7fa381b203d540ecaac6444d"
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
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
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
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
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
    url "https://files.pythonhosted.org/packages/ac/79/2484075a8549cd64beae697a8f664dee69a5ccf3a7439ee40c8f93c1978a/face-24.0.0.tar.gz"
    sha256 "611e29a01ac5970f0077f9c577e746d48c082588b411b33a0dd55c4d872949f6"
  end

  resource "glom" do
    url "https://files.pythonhosted.org/packages/3f/d1/69432deefa6f5283ec75b246d0540097ae26f618b915519ee3824c4c5dd6/glom-22.1.0.tar.gz"
    sha256 "1510c6587a8f9c64a246641b70033cbc5ebde99f02ad245693678038e821aeb5"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
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
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "peewee" do
    url "https://files.pythonhosted.org/packages/88/b0/79462b42e89764998756e0557f2b58a15610a5b4512fbbcccae58fba7237/peewee-3.19.0.tar.gz"
    sha256 "f88292a6f0d7b906cb26bca9c8599b8f4d8920ebd36124400d0cbaaaf915511f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/cc/5c/f912bdebdd4af4160da6a2c2b1b3aaa1b8c578d0243ba8f694f93c7095f0/protobuf-6.33.3.tar.gz"
    sha256 "c8794debeb402963fddff41a595e1f649bcd76616ba56c835645cab4539e810e"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/43/4b/ac7e0aae12027748076d72a8764ff1c9d82ca75a7a52622e67ed3f765c54/pydantic_settings-2.12.0.tar.gz"
    sha256 "005538ef951e3c2a68e1c08b292b5f2e71490def8589d4221b95dab00dafcfd0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/78/96/804520d0850c7db98e5ccb70282e29208723f0964e88ffd9d0da2f52ea09/python_multipart-0.0.21.tar.gz"
    sha256 "7137ebd4d3bbf70ea1622998f902b97a29434a9e8dc40eb203bbcf7c2a2cba92"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/1d/d6/9773d48804d085962c4f522db96f6a9ea9bd2e0480b3959a929176d92f01/rich-13.5.3.tar.gz"
    sha256 "87b43e0543149efa1253f485cd845bb7ee54df16c9617b8a893650ab84b4acb6"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d8/e9/39ec4d4b3f91188fad1842748f67d4e749c77c37e353c4e545052ee8e893/ruamel.yaml.clib-0.2.14.tar.gz"
    sha256 "803f5044b13602d58ea378576dd75aa759f52116a0232608e8fdada4da33752e"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/da/34/f5df66cb383efdbf4f2db23cabb27f51b1dcb737efaf8a558f6f1d195134/sse_starlette-3.1.2.tar.gz"
    sha256 "55eff034207a83a0eb86de9a68099bd0157838f0b8b999a1b742005c71e33618"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/e7/65/5a1fadcc40c5fdc7df421a7506b79633af8f5d5e3a95c3e72acacec644b9/starlette-0.51.0.tar.gz"
    sha256 "4c4fda9b1bc67f84037d3d14a5112e523509c369d9d47b111b2f984b0cc5ba6c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/35/b9/de2a5c0144d7d75a57ff355c0c24054f965b2dc3036456ae03a51ea6264b/tomli-2.0.2.tar.gz"
    sha256 "d46d457a85337051c36524bc5349dd91b1877838e2979ac5ced3e710ed8a60ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c3/d1/8f3c683c9561a4e6689dd3b1d345c815f10f86acd044ee1fb9a4dcd0b8c5/uvicorn-0.40.0.tar.gz"
    sha256 "839676675e87e73694518b5574fd0f24c9d97b46bea16df7b8c05ea1a51071ea"
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
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  # Due to the popularity of Semgrep, we provide an exception to bundle a copy of
  # EOL `pcre` until the upstream has completely migrated to `pcre2`. This allows
  # us to deprecate the `pcre` formula and avoid unwanted usage in core formulae.
  resource "pcre" do
    url "https://downloads.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.bz2"
    mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.45.tar.bz2"
    sha256 "4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8"

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

      # Manually run steps from `opam exec -- make setup` to link Homebrew's tree-sitter
      system "opam", "update", "-y"
      system "opam", "install", "-y", "--deps-only", "./libs/ocaml-tree-sitter-core"
      system "opam", "install", "-y", "--deps-only", "./"
      cd "./libs/ocaml-tree-sitter-core" do
        system "./configure"
      end

      # Install semgrep-core and spacegrep
      system "opam", "exec", "--", "make", "core"
      system "opam", "exec", "--", "make", "copy-core-for-cli"

      bin.install "_build/install/default/bin/semgrep-core" => "semgrep-core"
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources.reject { |r| ["glom", "pcre"].include? r.name }

    # Replace `imp` usage: https://github.com/mahmoud/glom/commit/1f883f0db898d6b15fcc0f293225dcccc16b2a57
    # TODO: remove with glom>=23.4.0
    resource("glom").stage do |r|
      inreplace "setup.py", "import imp", ""
      inreplace "setup.py", "_version_mod = imp.load_source('_version', _version_mod_path)", ""
      inreplace "setup.py", "_version_mod.__version__", "'#{r.version}'"
      venv.pip_install Pathname.pwd
    end

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
