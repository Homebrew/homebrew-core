class WeaviateCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing and interacting with Weaviate"
  homepage "https://pypi.org/project/weaviate-cli/"
  url "https://files.pythonhosted.org/packages/c9/c5/2d1129ff8515e037c77bbaca2df691352d7406579d96cd1b791323153093/weaviate_cli-3.2.3.tar.gz"
  sha256 "286bdeaefde91a93863f3b3f200f5eae8e07f94fa1c7e996f4c5d48091084294"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3de7161a7c4d1be8efccc28ba2b3747eef86ffa978a4c0f6830c607e7feec38e"
    sha256 cellar: :any,                 arm64_sequoia: "df2977b1a7f4eb1a76db921261e8e2d9e980d224169852dc4ce568551f7c99fa"
    sha256 cellar: :any,                 arm64_sonoma:  "595f3b018079e0f1a2d4384aca5e8fe2bd88866e9f7f439e2e983b589719d9cb"
    sha256 cellar: :any,                 arm64_ventura: "bef85ab7a3ffbf295d9274fabc0e6d7a209ca78f56bb9c208c7329dba528a6d2"
    sha256 cellar: :any,                 sonoma:        "40f425b2c25bc16fcb6513b84a24682557eb5c3b50291aba243bf6351637d0e8"
    sha256 cellar: :any,                 ventura:       "fa6bf6e000aaf944e9ca77093e9cccdc5dc9c868280d7bea8dead8b3bd983418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc9e58adfb242c393c7c48193dd08182db06aa42bce86b1e8c06d01b933b8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9fd460efd8b6e9188f5d9ff2cbf96b09bef299863938eb72838e58289c3588d"
  end

  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/8e/a1/d8d1c6f8bc922c0b87ae0d933a8ed57be1bef6970894ed79c2852a153cd3/authlib-1.6.1.tar.gz"
    sha256 "4dffdbb1460ba6ec8c17981a4c67af7d8af131231b5a36a88a1e8c80c111cdfd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/65/95/da573e055608e180086e2ac3208f8c15d8b44220912f565a9821b9bff33a/faker-37.4.2.tar.gz"
    sha256 "8e281bbaea30e5658895b8bea21cc50d27aaf3a43db3f2694409ca5701c56b0a"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/79/e8/b43b851537da2e2f03fa8be1aef207e5cbfb1a2e014fbb6b40d24c177cd3/grpcio-1.73.1.tar.gz"
    sha256 "7fce2cd1c0c1116cf3850564ebfc3264fba75d3c74a7414373f1238ea365ef87"
  end

  resource "grpcio-health-checking" do
    url "https://files.pythonhosted.org/packages/72/d8/81b0e9b2e3cf82c61bd66e7e572878e7402d4ff3f793da18385dfcdb4113/grpcio_health_checking-1.73.1.tar.gz"
    sha256 "352753713edeba3f23ea8a3320c5752bee186002d9475a654f5f815ff4e06345"
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

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/cf/8c/f834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7/importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/2e/19/d7c972dfe90a353dbd3efbbe1d14a5951de80c99c9dc1b93cd998d51dc0f/numpy-2.3.1.tar.gz"
    sha256 "1ec9ae20a4226da374362cca3c62cd753faf2f951440b0e3b98e93c235441d2b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/99/b1/85e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94f/prettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/52/f3/b9655a711b32c19720253f6f06326faf90580834e2e83f840472d752bc8b/protobuf-6.31.1.tar.gz"
    sha256 "d8cac4c982f0b957a4dc73a80e2ea24fab08e679c0de9deb835f4a12d69aca9a"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/53/66/a435d9ae49850b2f071f7ebd8119dd4e84872b01630d6736761e6e7fd847/validators-0.35.0.tar.gz"
    sha256 "992d6c48a4e77c81f1b4daba10d16c3a9bb0dbb79b3a19ea847ff0928e70497a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "weaviate-client" do
    url "https://files.pythonhosted.org/packages/43/09/fefbffd499da6d46d897eecde4942a5ce4880dc8fdccbbd2363704a6ba32/weaviate_client-4.16.3.tar.gz"
    sha256 "e0c7f160787623fefcee0bfe2d160ad1b2f0178c5d1d92fea41de124a0cb1b2a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"weaviate-cli", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weaviate-cli --version")
    assert_match "Error: Connection to Weaviate failed.", shell_output("#{bin}/weaviate-cli get collection", 1)
  end
end
