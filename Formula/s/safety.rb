class Safety < Formula
  include Language::Python::Virtualenv

  desc "Checks Python dependencies for known vulnerabilities and suggests remediations"
  homepage "https://safetycli.com/product/safety-cli"
  url "https://files.pythonhosted.org/packages/dc/55/873096606ff9cfad99cb3de8377461fb05217f65ad0690b9fe6a6e3afe95/safety-3.3.1.tar.gz"
  sha256 "679834432d0ad64c54e0b864ac6715d4743a65f8db67512380ee7ee2011c206a"
  license "MIT"
  revision 1
  head "https://github.com/pyupio/safety.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b5f859f34943efa6af4e6fdda6b1046c01b8d29fd28b1bcb2a83136907cafeff"
    sha256 cellar: :any,                 arm64_sonoma:  "943ffb4f36191bba5cf888c69c0b0eb3d6d585ed8a8e3934a5f5edae22ae57e4"
    sha256 cellar: :any,                 arm64_ventura: "e322642821107f4f995381075dd8ab28c2170b6a0d8bc2f313269d989a28d9aa"
    sha256 cellar: :any,                 sonoma:        "024728a332e4ea14aeacc9923e0a9d48504707598898087a435d292d5e1dfcba"
    sha256 cellar: :any,                 ventura:       "024841eb53bae6c8fb0743d3a3449b0044c61b8c9a82dfe289065a2209d70b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b0857ee18129fb598663d744e56cc17f284fc357a45985cfb3004dd7abf778e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/36/aa/e1c199d27ea06a13f9641746a9b19f15bd75b04b40b6bd72a89156c75d10/authlib-1.5.1.tar.gz"
    sha256 "5cbc85ecb0667312c1cdc2f9095680bb735883b123fb509fde1e65b1c5df972e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "dparse" do
    url "https://files.pythonhosted.org/packages/29/ee/96c65e17222b973f0d3d0aa9bad6a59104ca1b0eb5b659c25c2900fccd85/dparse-0.6.4.tar.gz"
    sha256 "90b29c39e3edc36c6284c82c4132648eaf28a01863eb3c231c2512196132201a"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/64/33/60135848598c076ce4b231e1b1895170f45fbcaeaa2c9d5e38b04db70c35/joblib-1.4.2.tar.gz"
    sha256 "2382c5816b2636fbd20a09e0f4e9dad4736765fdfb7dca582943b9c1366b3f0e"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/ab/5e/5e53d26b42ab75491cda89b871dab9e97c840bf12c63ec58a1919710cd06/marshmallow-3.26.1.tar.gz"
    sha256 "e6d8affb6cb61d39d26402096dc0aee12d5a26d490a121f118d2e81dc0719dc6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/3c/87/db8be88ad32c2d042420b6fd9ffd4a149f9a0d7f0e86b3f543be2eeeedd2/nltk-3.9.1.tar.gz"
    sha256 "87d127bd3de4bd89a4f81265e5fa59cb1b199b27440175370f7417d2bc7ae868"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1f/5a/07871137bb752428aa4b659f910b399ba6f291156bdea939be3e96cae7cb/psutil-6.1.1.tar.gz"
    sha256 "cf8496728c18f2d0b45198f06895be52f36611711746b7f30c464b422b50e2f5"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/a9/b7/d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30/pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e2/aa/6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3/pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "safety-schemas" do
    url "https://files.pythonhosted.org/packages/91/a2/e75f7de6a0872ed80b4b09221a9640d5856a8c3730ba59534d3007c9ae3a/safety_schemas-0.0.11.tar.gz"
    sha256 "10804372e077ca5a95e740cc507e73d9173663284006fcaaf5756179ba13ac9d"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d1/53/43d99d7687e8cdef5ab5f9ec5eaf2c0423c2b35133a2b7e7bc276fc32b21/setuptools-75.8.2.tar.gz"
    sha256 "4880473a969e5f23f2a2be3646b2dfd84af9028716d398e46192f84bc36900d2"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/8b/6f/3991f0f1c7fcb2df31aef28e0594d8d54b05393a0e4e34c65e475c2a5d41/typer-0.15.2.tar.gz"
    sha256 "ab2fab47533a813c49fe1f16b1a370fd5819099c00b119e0633df65f22144ba5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin/"safety --version")

    assert_match "Safety is not authenticated, please first authenticate and try again.",
      shell_output(bin/"safety check-updates", 1)
  end
end
