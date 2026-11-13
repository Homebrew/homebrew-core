class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/0f/15/6012017d650cbd543355eec7b51540c4e523fad87e37d3f059b3cab97634/schemathesis-4.33.3.tar.gz"
  sha256 "0651700aba86b355acc087233002583b08d454823a8d44763299dc9ff7a5ff4f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fb65700a8037b7fb3a249257d14881b383b2263a9626d220196b0e5d0e1a3278"
    sha256 cellar: :any, arm64_tahoe:       "14713beab0d1fc24c915c15b35ec5c7b1d3e9d04677bcb6b73e11bda0126d866"
    sha256 cellar: :any, arm64_sequoia:     "298b9bb7097f336b06cccda7c48abd6383145eb70c99e57172c21ee303eef787"
    sha256 cellar: :any, arm64_linux:       "54ea7d201f7afc53a082fed471ce0d67097b5aa009f356889a1c80b80c2e20ba"
    sha256 cellar: :any, x86_64_linux:      "9eec31a2824f2b82f8010fdc6f97a6e485592c8859972f722300bb64ae3a67fc"
  end

  depends_on "rust" => :build # for jsonschema-rs
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  conflicts_with "st", because: "both install `st` binaries"

  pypi_packages exclude_packages: %w[certifi rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/0d/11/511b9487dd338a9cd98a8040a1f20feaa99b2f2e4921c049cb9cbbff2870/graphql_core-3.3.2.tar.gz"
    sha256 "15d6eee7d4364fbc202833bc6bd0d504004d8ae7c0aaf620fa884d8e437622f2"
  end

  resource "harfile" do
    url "https://files.pythonhosted.org/packages/42/03/d0c14a45c41820731e537ae92586d1aebe1a333a3347cef4f69a467c2d90/harfile-0.6.0.tar.gz"
    sha256 "3e5751d52c59bda35789748256cbac097b664e65315d15ded67b006c173e34b3"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/96/ec/59f14eb701087710888b66bfef2dc8bee9dd4a364c69a732db0cc1d3d2dc/hypothesis-6.170.15.tar.gz"
    sha256 "a4a57e5fb106ecb29cad37e22e411d957e20d933bfb9fb029e1999b1deb8a0b6"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/0d/b2/12fcce1eb8aec4a3e75097079da23729f38d9858a3ba9dc387036569a526/hypothesis_graphql-0.13.6.tar.gz"
    sha256 "8902f9ca57752466bf53d46cb1a9ab7bc45769838dd668c18379b867cc688435"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/01/e1/2069291243c926a2ff1cd706c7f3eeb9b62144bf60f77c9fb9ff2fb26bd3/iniconfig-2.3.1.tar.gz"
    sha256 "67f4b9c50da0dedf52af349e7749a80a9057a5031199791b906c3bb3ae878960"
  end

  resource "jsonschema-rs" do
    url "https://files.pythonhosted.org/packages/30/d3/fedab55fadf17359ed45d7c347e13839b79aa5c85c083c417b6a0e8b12a9/jsonschema_rs-0.61.2.tar.gz"
    sha256 "8ea236493450c013f095d5d4d9d3b8e56fa0153fb305107f9a7134ea16bcf56b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
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
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/2b/0b/f69f1614940f29d51e31d4fe8de69b2b4d411094ba3c77f50da34dfb63c6/pyrate_limiter-4.5.1.tar.gz"
    sha256 "7f03c6a9235b00a4ba3c7b1e8cb6b23fbacc9d40b09f326220917a12ef22cc09"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/79/42/bb4641652e58dedeac2ec51abc1f8cae4fee4ec63899a0999016229a0f2a/pytest-9.2.0.tar.gz"
    sha256 "97c4f3b1f3c7414aa36465e09b8220f1d03627993bd51b1282e193753c80557b"
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
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/a4/34/4dd12fc8bb7d61c91467ec3efe415ffa7d5456f799954b40c5bbaeae470e/werkzeug-3.1.9.tar.gz"
    sha256 "55ca7c70a75689be937aa27f8ff4b018f06ff4838fc73045560bf0f5a1291060"
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
    output = shell_output("#{bin}/st run #{openapi_url} --phases examples --include-path /ip", 2)
    assert_match "Specification:    Open API 3.1.0", output
    assert_match "No test cases were generated", output
  end
end
