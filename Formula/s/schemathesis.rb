class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/53/2c/71294d06b86c27522d7524738b40e6f00683616f12c8f03f3f9bb2b49de1/schemathesis-4.21.1.tar.gz"
  sha256 "58e1530d0fa8b9c96b65bc0952ffbc7dff61e2ca86b46156716fe471aefd28b0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5782134d0eb5b8ca2efc68d7f5b91df3053bfdb97a6bf00f29956f27fd825b9d"
    sha256 cellar: :any, arm64_sequoia: "a653ba84e5346d52ade1843bac17429a0aa35ef6822bebe1b14a8d21be6c5a9c"
    sha256 cellar: :any, arm64_sonoma:  "a4621725efa87f9ccb08895fd105a89fac6b878928b555292a88f579bcf0ad50"
    sha256 cellar: :any, sonoma:        "30c331e8a3d38361583652c8876a7b93102b0a7d11dbb3904375eed03aba54b1"
    sha256 cellar: :any, arm64_linux:   "58f86fe4df22928863261b0b6bf5445fa502fedbd4ed9ea778b50a05ec5dcf29"
    sha256 cellar: :any, x86_64_linux:  "a142b3a95725dd37d8672f8282bba2f71d7dad8526dff68e1495119d4d30ab51"
  end

  depends_on "rust" => :build # for jsonschema-rs
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  conflicts_with "st", because: "both install `st` binaries"

  pypi_packages exclude_packages: %w[certifi rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/4d/90/f2aff026ab4aebd80eb71905106a0885f4cfde85dcf965543f45bed0d9ee/graphql_core-3.2.11.tar.gz"
    sha256 "e7e156d10beb127cab5c89ff0da71416fc73d27c484a4757d3b2d35633774802"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "harfile" do
    url "https://files.pythonhosted.org/packages/8a/0e/ffbb98cd1910f1f898ddc62d649dbf0e3d68026ee9313d3cff035206b727/harfile-0.5.0.tar.gz"
    sha256 "c1524b8f0a39dd9f19365760aefb3adbba951818310d17b2eaa293de1f4c170a"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/f5/04/64032a1dccd2233615c8a3f701bbb563558575ed017496a24b6d81762c91/hypothesis-6.155.2.tar.gz"
    sha256 "ae36880287c9c5defe9f199d3d2b67d9947a4da2a46e6c57373cbdf2345b20e1"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/6b/8c/3f0ebc9b557073986234c42bd21ea9c7ea146e7e2616b7b0739f5e81cf2b/hypothesis_graphql-0.13.0.tar.gz"
    sha256 "788d89be1bbb561f27616f3a7077290054e4f664f88315a0ad03edee93e5d681"
  end

  resource "hypothesis-jsonschema" do
    url "https://files.pythonhosted.org/packages/4f/ad/2073dd29d8463a92c243d0c298370e50e0d4082bc67f156dc613634d0ec4/hypothesis-jsonschema-0.23.1.tar.gz"
    sha256 "f4ac032024342a4149a10253984f5a5736b82b3fe2afb0888f3834a31153f215"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-rs" do
    url "https://files.pythonhosted.org/packages/1b/43/a125326948974c980caf457857b88def52c36c596a5a5467acfee31ec31d/jsonschema_rs-0.46.5.tar.gz"
    sha256 "857e37e075a2d9f6f23dea58a559a55b663d3879a252170004b569073dab1ef3"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/ab/38/e6cd98b345e4a476d00d28c30e767ea2456cc6a77fd721603ab0c45df62b/pyrate_limiter-4.2.0.tar.gz"
    sha256 "d28fab36fde5c9ab84848c972f13e8e6e81e928e4cc26a7fd2aaee9ae63206b4"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/7d/0d/549bd94f1a0a402dc8cf64563a117c0f3765662e2e668477624baeec44d5/pytest-9.0.3.tar.gz"
    sha256 "b86ada508af81d19edeb213c681b1d48246c1a91d304c6c81a427674c17eb91c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/25/44/ec35f1b6e83094b997da438a02c8c9b0ade2b1e84cfc48bd4656780760a6/starlette-1.2.1.tar.gz"
    sha256 "9b9b5ebb992e67d6093741e63c2f59e4f6fff986f81163c087867bd7b924b3f6"
  end

  resource "starlette-testclient" do
    url "https://files.pythonhosted.org/packages/cd/64/6debec8fc6e9abde0c7042145dc27a562bd1cd79350a55b80bf612a10ccb/starlette_testclient-0.4.1.tar.gz"
    sha256 "9e993ffe12fab45606116257813986612262fe15c1bb6dc9e39cc68693ac1fc5"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
  end

  def install
    venv = virtualenv_install_with_resources without: "jsonschema-rs"
    resource("jsonschema-rs").stage do
      # Use ring instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace "crates/jsonschema-py/Cargo.toml",
                /^(jsonschema = .*), features = \[/,
                '\1, default-features = false, features = ["resolve-http", "resolve-file", "tls-ring",'
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"st", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/st --version")
    openapi_url = "https://httpbin.dmuth.org/openapi.json"
    output = shell_output("#{bin}/st run #{openapi_url} --phases examples --include-path /ip")
    assert_match "Specification:    Open API 3.1.0", output
    assert_match "No test cases were generated", output
  end
end
