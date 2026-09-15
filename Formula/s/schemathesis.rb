class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/46/d0/e0ab1d87068e0fbc2d5319ae040279cdde22eee2b94dfa954280b3a6ff2e/schemathesis-4.27.1.tar.gz"
  sha256 "f83b8b735634d4f202bd820517481f97cb3c48c350c09166b362d67934c1a52e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e22ce2337df3f2d9e127f35945a27a3dfd32381191d2772cd7547d232304750a"
    sha256 cellar: :any, arm64_tahoe:       "7f0c79bc666e73e9873379cc017dce8c6e28502dac89e35a33981f114b17a6f5"
    sha256 cellar: :any, arm64_sequoia:     "c627bffa4faeefe4762a71e9349c4bc79e0be2ad1159207cab52e2c8c9ec299a"
    sha256 cellar: :any, arm64_linux:       "9f0d828e8a1abb309aa9ca21c8b3cb213d37bdd2cd6a363804ef0984caa8732a"
    sha256 cellar: :any, x86_64_linux:      "a94236d1a631dd99de81d63e042e08e9bd0474e2ea72ffc1845233bd4bc44a92"
  end

  depends_on "rust" => :build # for jsonschema-rs
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  conflicts_with "st", because: "both install `st` binaries"

  pypi_packages exclude_packages: %w[certifi rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/11/7f/671c1046fe72ba5b62be2de3979ea9e61cb3dba8f1edfb880b811f8bdf8b/graphql_core-3.2.12.tar.gz"
    sha256 "4579094d5fc8a1a59555a9b18e51b320779d9bbc63e2302c519af0c4919d9543"
  end

  resource "harfile" do
    url "https://files.pythonhosted.org/packages/8a/0e/ffbb98cd1910f1f898ddc62d649dbf0e3d68026ee9313d3cff035206b727/harfile-0.5.0.tar.gz"
    sha256 "c1524b8f0a39dd9f19365760aefb3adbba951818310d17b2eaa293de1f4c170a"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/5a/ce/c0946bebffb99b62426a6a7643d4272cc6c5cf777a488b3b4d0ee724e960/hypothesis-6.168.0.tar.gz"
    sha256 "72af51087b7b5ab21c49f0d502f803c20897678652835596bd2a8b169a39135e"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/a8/b8/aa6cfa4d99a5a451c71db6120cdb67850b6fe0b86bfb8df7e1affc565274/hypothesis_graphql-0.13.2.tar.gz"
    sha256 "6d6f8a7c28aa2aa78830713cb1fff49bd3ea0b0045a5490c216ead7dc02e0276"
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
    url "https://files.pythonhosted.org/packages/16/b0/fca4c04d71ff6a31062afaa7086be0e1b85646f814a934d2c1624a5e6022/jsonschema_rs-0.56.0.tar.gz"
    sha256 "c51593e1f3ad6e874dadcf54a813292c8ace0101fce25f2e9de60f6c7038c6eb"
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
    url "https://files.pythonhosted.org/packages/62/43/48693393af06b9fffbaea6bb8fe03be3c3f17be5d1423dab347d1aad1dde/pyrate_limiter-4.5.0.tar.gz"
    sha256 "098345fff3a52b84dee9bcf6973f184c8b3ef8d34e1f4f781ac0773e3984598b"
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
