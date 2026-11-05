class Skillspector < Formula
  include Language::Python::Virtualenv

  desc "Security scanner for AI agent skills"
  homepage "https://github.com/NVIDIA/SkillSpector"
  url "https://github.com/NVIDIA/SkillSpector/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "0dae54aa348a2fc9dcfd870e4f73c1896c91eded7b4907a47ea596761acf3bfd"
  license "Apache-2.0"
  head "https://github.com/NVIDIA/SkillSpector.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "45744cfc2785b272644ebd360c8faa552a7f9abbf02bee37af296a4a90e04e22"
    sha256 cellar: :any, arm64_tahoe:       "ad2d5116f2261df21f5eea71808e4b21ac337d961eb6edaa287d29facb9086d9"
    sha256 cellar: :any, arm64_sequoia:     "9f51aaf164c2ac35302f67a546942c86eb5dfd1d16f9c14b0bf06432ade18a32"
    sha256 cellar: :any, arm64_linux:       "91af477198c9df1be981ab2a4395f77c9200c9dae0a748fbf8b987e6440864ac"
    sha256 cellar: :any, x86_64_linux:      "0c471bd4709df4cd938920d94da9ff347171fb0e1e19332d8ffbaf63d3b4690e"
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
    url "https://files.pythonhosted.org/packages/c8/5b/6c13b126554cfec789ce14a74f2ccfd46382a0eb296ec78ea6b80eeac3b5/anthropic-2.4.0.tar.gz"
    sha256 "c59cab76049cf581e90e2ee3a20472291029b7a6a1ee2ef32bff2b2a7010fd47"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
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
    url "https://files.pythonhosted.org/packages/67/f6/4b1c0352b99b71e80d3eac306b9431a46ff109a314ba0a48b4b4bd3b9761/jsonpatch-1.42.tar.gz"
    sha256 "8d553ab33cc1e5d3da60b8be5224355fb28cde863cc8935c40f011a8c0d72ad4"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/c2/cf/5d665216bd9dea19dd26ea93ca525ef02936a9cccd0cd856f8408eb77f0b/jsonpointer-3.8.tar.gz"
    sha256 "a627a255641390bfb4d51d4cfbb90648078ae855b45804ef7e19ea13a4cca355"
  end

  resource "langchain-anthropic" do
    url "https://files.pythonhosted.org/packages/21/0e/4f8b371a6a75d6d0a525e2db70efd684903770718d8c4d715e9414983e00/langchain_anthropic-1.7.9.tar.gz"
    sha256 "132d63718009c5738959070f12d95fb6eac10453f68108ec8865ae38b847cc0c"
  end

  resource "langchain-aws" do
    url "https://files.pythonhosted.org/packages/b6/bf/e0fe1e6f09ee89cd8c548565445764436c86fdc190e65e22e5b191c403d4/langchain_aws-1.9.1.tar.gz"
    sha256 "e594476409f7fd41ae0989179866758338f7e5a9abbee93c0b2cff528aee2bb8"
  end

  resource "langchain-core" do
    url "https://files.pythonhosted.org/packages/27/25/bd6a5092ec05f7fe7642e7fd3981c8bdfd5a7750f34520b9eee3e9e4b1c0/langchain_core-1.7.4.tar.gz"
    sha256 "a9b286e12d782dfc1eb17bdbf4228e0f71e7caa6e5d26375eb9ab6723baaf613"
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
    url "https://files.pythonhosted.org/packages/24/44/3b07ae42ebfd3cc343201a2ff708d470867082810e747ea5d8dd85de50ec/langgraph_sdk-0.4.12.tar.gz"
    sha256 "2f7ea2b9a7048e1ff9c3be7308b36eb56d6bfcccbe8100aeea6db688002219e0"
  end

  resource "langsmith" do
    url "https://files.pythonhosted.org/packages/12/4b/c91526e3038d5d5869fa5dba647215826fb8b2b8a3c042d20581a3e5d735/langsmith-0.14.17.tar.gz"
    sha256 "53efa2db8293d0a8d60efebe0945c595b635873774b302066ed0a746ddf87562"
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
    url "https://files.pythonhosted.org/packages/de/ef/639821491538e8bb4c56f3367f00787e8aadc1665ce1598e7506bcb65663/openai-3.45.0.tar.gz"
    sha256 "6cff2b5c7b463123fcb94d1bb7e4920e5fab9bb3ed4f837faa0d0bf1d6d6ea3b"
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

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-javascript" do
    url "https://files.pythonhosted.org/packages/59/e0/e63103c72a9d3dfd89a31e02e660263ad84b7438e5f44ee82e443e65bbde/tree_sitter_javascript-0.25.0.tar.gz"
    sha256 "329b5414874f0588a98f1c291f1b28138286617aa907746ffe55adfdcf963f38"
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
