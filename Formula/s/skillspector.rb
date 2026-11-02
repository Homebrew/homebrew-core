class Skillspector < Formula
  include Language::Python::Virtualenv

  desc "Security scanner for AI agent skills"
  homepage "https://github.com/NVIDIA/SkillSpector"
  url "https://github.com/NVIDIA/SkillSpector/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "07c2952a5d065c7c1a79985e81e41c3375debff92c3a96863083b5789e2e0d7a"
  license "Apache-2.0"
  head "https://github.com/NVIDIA/SkillSpector.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a692cd3e87b4e4c8df05364313bc28011c48aff4bed30dda40a1cdfea513932"
    sha256 cellar: :any, arm64_tahoe:       "f47d3a8a89e65077bba4abfc06d1baf404db34953d6f30fac11ead56e249d595"
    sha256 cellar: :any, arm64_sequoia:     "2faefa064b19f51e5e5652aded767568a0f59f01dd0594b7af62b965428e2060"
    sha256 cellar: :any, arm64_linux:       "72240ba8ebc45af595290bde3f7cb5c6b3f66860b39b2c2b3dfb78693ece1e6b"
    sha256 cellar: :any, x86_64_linux:      "b6bd266a262108bc8e1c9a5f69c1234a352ed85a4b467d662a40f161133f1237"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "xxhash"
  depends_on "yara"
  depends_on "zstd"

  pypi_packages exclude_packages: %w[certifi cryptography numpy pydantic]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/3e/ba/4c91947e0d0062d66d371db371597287153f7685fbed512d3294d0cde3c7/anthropic-2.3.0.tar.gz"
    sha256 "edfdea1e3fa7b3ce25df1511953408b2f03bfa61eb6f6268f766101a9e18ad53"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/fc/8a/64b46f075149f9160da44aa7e1052dd18431b9ad4435beb0cfb02cc48624/boto3-1.43.123.tar.gz"
    sha256 "055fabb990c5d2f31fce4ca569255bd640cdd11a3ca68c9ecad35f4f8a5b83b5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e0/de/011fc2a47fb066c47064b122498d2fd21f55bc90ea514acbddc37ca0f8c1/botocore-1.43.123.tar.gz"
    sha256 "80948cb9b1cdf1a1a25809089a42e3a1bc4af0258d198222db6e97dcc660dd0c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/63/5b/f68319f4fe624311a744a33d10fdbcac4c971991e348223cba60d31780b2/jiter-0.18.0.tar.gz"
    sha256 "a0ca63fd9450a212e4e658d4cfe0ab4977c4f9b0003c68828b843c65e27662ff"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/31/fd/359c6b0bf41d43eba15cafcd185fd82a11250f00606599ca8f296820fae2/jsonpatch-1.38.tar.gz"
    sha256 "debc3e7bdc3d446468d64987f51a0e7a9deea42987ff90a6d1005a489b471c19"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/54/04/e35b34f4e441473e62d82d6ed9a8f748d93d895f4c05d4e645aa0fde51d7/jsonpointer-3.6.tar.gz"
    sha256 "82e839a3ba3a9e2b54394fda8b3d276c2459d80408d06ef9a6fbc369d7544ffc"
  end

  resource "langchain-anthropic" do
    url "https://files.pythonhosted.org/packages/b2/36/a8988f6344c4222da68d74bfc7756f4ff7f7f41785f7a590bc7e3b848e41/langchain_anthropic-1.7.7.tar.gz"
    sha256 "4d912c2eb6f20ede3fd38c956738b82ce30cabf5421ebb57639660031868b952"
  end

  resource "langchain-aws" do
    url "https://files.pythonhosted.org/packages/b6/bf/e0fe1e6f09ee89cd8c548565445764436c86fdc190e65e22e5b191c403d4/langchain_aws-1.9.1.tar.gz"
    sha256 "e594476409f7fd41ae0989179866758338f7e5a9abbee93c0b2cff528aee2bb8"
  end

  resource "langchain-core" do
    url "https://files.pythonhosted.org/packages/ac/90/f932d9c82d15033ae9676fb3670993e10e1b4d9c59fe1b7ae024dee11955/langchain_core-1.7.3.tar.gz"
    sha256 "77f70b81e238c981bfd8405840b03fdf143735ac93c0729c2bdb39d6f0648024"
  end

  resource "langchain-openai" do
    url "https://files.pythonhosted.org/packages/58/f5/a430230cb50b4b4ade021a5fe5df5a8c5adefa468435d460d2f77f2506ea/langchain_openai-1.7.3.tar.gz"
    sha256 "c1d2d0fbd4f542ddcdf176c07abcf4d86c3b716513929250bbef04e3efc5e0b5"
  end

  resource "langchain-protocol" do
    url "https://files.pythonhosted.org/packages/cb/8b/d908d082c3cf5368ddd1816ed114de79c873f979ba7f98b95fab0e841643/langchain_protocol-0.0.20.tar.gz"
    sha256 "0f5bd002474265648e91161771a9e0438fe9480bd55a416e51af0f60070637ec"
  end

  resource "langgraph" do
    url "https://files.pythonhosted.org/packages/ba/10/329dc49ce3fc40e36faafd407f08607fe3fab75613e709a66758b53faac2/langgraph-1.2.19.tar.gz"
    sha256 "4a00fa1aad2b5fc2d3a789a8e9eaf993f76218ca924b434902ecf1bbaaf300f6"
  end

  resource "langgraph-checkpoint" do
    url "https://files.pythonhosted.org/packages/f0/c4/f4107f50dd07169d08d95766cd69104231e694f44a1b25b68ad8b393712d/langgraph_checkpoint-4.3.1.tar.gz"
    sha256 "625e7c78a72b33e7c47f7e87ca051060fb90aa66f5fd551c472c08376fb669cb"
  end

  resource "langgraph-prebuilt" do
    url "https://files.pythonhosted.org/packages/ab/d9/e50d6e6b8d241b90564892afed8fac98d17da023c82810577cdb4530f87c/langgraph_prebuilt-1.1.1.tar.gz"
    sha256 "f1b1a4772e7f9f15ba736411aad3877183ad40cd9349748df76bd2b9f58a83c7"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/64/a8/d5807df5976f2b8e181baddbddf857cc0ba501bba274e81711b10385c65b/langgraph_sdk-0.4.11.tar.gz"
    sha256 "2550af3bc7cb78ac4facb97d141ec1a76568fa3eb3d29040cff70b45bda84740"
  end

  resource "langsmith" do
    url "https://files.pythonhosted.org/packages/f5/45/576803a72da96d9c0866b3815f08f447ed16c14acb52174129daca6847d6/langsmith-0.14.16.tar.gz"
    sha256 "4e5816cbe1541f4d04d71f652eb8f4137889861bebcf7137bcba3553ae9e335e"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/f9/ef/c17c9ca921c1991b0a7185e8282da1996d09292b0caaf2e7cffd7e051eb6/openai-3.42.0.tar.gz"
    sha256 "deffe27f9e20e4f1d9d471978d12f23aa119382494c0a9860795e66943d0fe42"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "ormsgpack" do
    url "https://files.pythonhosted.org/packages/72/ae/aea2bee05bd61645daf97515174d71d8fd978a2c395b4dd5f0a5ada7facc/ormsgpack-1.13.0.tar.gz"
    sha256 "4127e84b07816e1f36d557e95b5642041692df22bf77f2c2f563a2039ab8144e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pywhatwgurl" do
    url "https://files.pythonhosted.org/packages/c0/d2/ce0fffb9eb66ea2f88d20d7c3841b017d25559b6b617bce566811fe0bb48/pywhatwgurl-0.1.1.tar.gz"
    sha256 "65c85da35367511c12a4dd87fecaf08aa3ae564259055b37b4ae53429289fcf6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/82/9e/497c1c8ebe5a5b5d1d4a7511aea22c0bb1a97e3170d98abdef0e1b34265a/tenacity-9.2.1.tar.gz"
    sha256 "a606b5c808d0cded4a359d5b9932d867ff2a6a6b64d37350260fd01bbdf83839"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/66/62/167a842aa0429d45f5e797354fd4343a96f6043d67d0513c675c7b8d36e6/tiktoken-0.14.0.tar.gz"
    sha256 "231dec90efcdccf1b565a1416107736f1e09b1a08fe736ef9d6363e626d03874"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/d3/ae/93d16574e66dfe4c2284ffdaca4b0320ade32858cb2cc586c8dd79f127c5/typer-0.23.2.tar.gz"
    sha256 "a99706a08e54f1aef8bb6a8611503808188a4092808e86addff1828a208af0de"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uuid-utils" do
    url "https://files.pythonhosted.org/packages/f1/0f/cd9b3e495e514441e9af3a42c5c63436aee620f61412cafcce67e259228b/uuid_utils-0.19.0.tar.gz"
    sha256 "4b2996bb9d12da9b62f6f4c64a066b26926fa75dbe47b4f8e309e24e187abf1d"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/39/e6/ed6c428055ffd3f9299db3ec8671fd78b70c24173c040b8faafb6348ebbb/xxhash-4.0.2.tar.gz"
    sha256 "af3d1b3cfa5280e84d8968e9f30c9eca75781db4915eb6d6acb0dd4fc93e0f47"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/51/38/347d1fcde4edabd338d5872ca5759ccfb95ff1cf5207dafded981fd08c4f/yara_python-4.5.4.tar.gz"
    sha256 "4c682170f3d5cb3a73aa1bd0dc9ab1c0957437b937b7a83ff6d7ffd366415b9c"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    # Link against the keg rather than the copy vendored in the sdist.
    ENV["XXHASH_LINK_SO"] = "1"

    # Allow Python 3.15
    inreplace "pyproject.toml", 'requires-python = ">=3.12,<3.15"', 'requires-python = ">=3.12"'

    venv = virtualenv_install_with_resources without: %w[yara-python zstandard]

    resource("yara-python").stage do
      inreplace "setup.py", "self.dynamic_linking = None", "self.dynamic_linking = True"
      venv.pip_install Pathname.pwd
    end

    # zstandard only uses the system libzstd when told to at build time.
    resource("zstandard").stage do
      args = std_pip_args(prefix: false, build_isolation: true)
      args << "--config-settings=--build-option=--system-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", *args, "."
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillspector --version")

    (testpath/"SKILL.md").write <<~EOS
      # Test Skill
      This is a test skill for Skillspector.
    EOS

    output = shell_output("#{bin}/skillspector scan SKILL.md --no-llm")
    assert_match "SkillSpector Security Report", output
  end
end
