class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/c9/e0/bba6582674338e217d3f21b989dd761c90e613f115aa16c0801c8eb415b6/schemathesis-4.25.0.tar.gz"
  sha256 "656b945fd3ec4fc13fbf9922be0bf2b75234d02067ae2c8b4d399bd3a5b8f8aa"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f310fb3ecbab7d2359c37f3d100e5ade845fbb4cc568c768d5a3f58a2719256d"
    sha256 cellar: :any, arm64_sequoia: "27e88e0fa9973836a62f9c5aeb96e4bb8474fae7a7b1ba7dea84a9d197184e85"
    sha256 cellar: :any, arm64_sonoma:  "8ff9d43167ebc1f9b54a7ee70c756eeae8cc0ac872784707b34175b4c111fd85"
    sha256 cellar: :any, sonoma:        "fc4876cffa18bcadd41215948b8af336a3a34852ea1cf48b03cbecf49f215aaf"
    sha256 cellar: :any, arm64_linux:   "a7d50aa22ec567fdf2c4fcebaf8af36c57de0f04f558eea44f7ac41008b532a8"
    sha256 cellar: :any, x86_64_linux:  "85ba5a8215433af0a504babbd203387a0355358d193aba8554b471854e400a4a"
  end

  depends_on "rust" => :build # for jsonschema-rs
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  conflicts_with "st", because: "both install `st` binaries"

  pypi_packages exclude_packages: %w[certifi rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/4d/90/f2aff026ab4aebd80eb71905106a0885f4cfde85dcf965543f45bed0d9ee/graphql_core-3.2.11.tar.gz"
    sha256 "e7e156d10beb127cab5c89ff0da71416fc73d27c484a4757d3b2d35633774802"
  end

  resource "harfile" do
    url "https://files.pythonhosted.org/packages/8a/0e/ffbb98cd1910f1f898ddc62d649dbf0e3d68026ee9313d3cff035206b727/harfile-0.5.0.tar.gz"
    sha256 "c1524b8f0a39dd9f19365760aefb3adbba951818310d17b2eaa293de1f4c170a"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/5c/e2/0fad246d2b6330e1f78479bfc566b5c22be82aee8a865cde9a08f648487d/hypothesis-6.165.10.tar.gz"
    sha256 "68b45e09834cd80523cb1eb274463073c7a9af4e4ef7cff34d9615f355572d32"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/54/1d/b0b5167874abfbc41d3558efeffc74ec1b676ab2557c40a6640919f9647d/hypothesis_graphql-0.13.1.tar.gz"
    sha256 "b0b34f0accb87af40140f5dd54a784ab899401db37ba52fac39a4b37c24b2f6c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "jsonschema-rs" do
    url "https://files.pythonhosted.org/packages/dc/4c/884abc9056018c2867da5769cf233813cad8273a2c882dd06aacec156d7b/jsonschema_rs-0.50.0.tar.gz"
    sha256 "35e332764f46f5250fc752ea7ac7c975117f1727c324dbff09eb3d162a42b734"
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
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/19/27/e564f33ea085c63d5540f707b31aeb50a4992eac2da655dc02435a760a07/pyrate_limiter-4.4.0.tar.gz"
    sha256 "2c0c720c4fa16c5d8199e4821bf34507fb49c007a25b786cec6fb94ffd0844aa"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e4/47/b9efed96c114afcfa3c9d3fe98a76a1d14c74a9e266d397cf6eb64be5e01/pytest-9.1.1.tar.gz"
    sha256 "1088fbde8f2b49d95a549a195707afa7a76a3ce9bcadc26b6d71f0ffda5fe313"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "starlette-testclient" do
    url "https://files.pythonhosted.org/packages/cd/64/6debec8fc6e9abde0c7042145dc27a562bd1cd79350a55b80bf612a10ccb/starlette_testclient-0.4.1.tar.gz"
    sha256 "9e993ffe12fab45606116257813986612262fe15c1bb6dc9e39cc68693ac1fc5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
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
