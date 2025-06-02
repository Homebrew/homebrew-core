class WeaviateCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing and interacting with Weaviate"
  homepage "https://pypi.org/project/weaviate-cli/"
  url "https://files.pythonhosted.org/packages/6d/55/51608eb9c5005b81c62dd6c37f50451d262018caa4001a9f4f9b82033823/weaviate_cli-3.2.0.tar.gz"
  sha256 "2f6476e25e04c2080eee6415dd817dd08a28887a268a5a54dbacbd2684ce60d7"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "782e5a5bca55ee7aef6eae6166b5b4876a2e55aff8e43f92191c0aff03c09d17"
    sha256 cellar: :any,                 arm64_sonoma:  "5bc1675d563f1c3b10704fd6ff777d66b29344af92527ebd508ad89b06c6eb29"
    sha256 cellar: :any,                 arm64_ventura: "ce1bc3d2637612166ec57d0591ca8208849800400905c5a4df6f9b0af773eac2"
    sha256 cellar: :any,                 sonoma:        "62d62a3f94647c907baa3d2e95259222d50f37c270c3950a63bf0ac6fde1d686"
    sha256 cellar: :any,                 ventura:       "87a12d6d319144012bbb68bb71f27fa8ce04066026c0841cada8ae0aed587f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f6784344aebd9817d83d84b629bbcf1dff5759a2c4567c96380a683afd4c320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29b1bae93bad9289ce198479bd713397f8b4c769fca61cdf76b1c08444a4bb50"
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
    url "https://files.pythonhosted.org/packages/09/47/df70ecd34fbf86d69833fe4e25bb9ecbaab995c8e49df726dd416f6bb822/authlib-1.3.1.tar.gz"
    sha256 "7ae843f03c06c5c0debd63c9db91f9fda64fa62a42a77419fa15fbb7e7a58917"
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
    url "https://files.pythonhosted.org/packages/ba/a6/b77f42021308ec8b134502343da882c0905d725a4d661c7adeaf7acaf515/faker-37.1.0.tar.gz"
    sha256 "ad9dc66a3b84888b837ca729e85299a96b58fdaef0323ed0baace93c9614af06"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/d1/33/bf7bf9188cfce1c626e4c5d55523fec7f2f1d905e003df5da025f532916e/grpcio-1.72.0rc1.tar.gz"
    sha256 "221793dccd3332060f426975a041d319d6d57323d857d4afc25257ec4a5a67f3"
  end

  resource "grpcio-health-checking" do
    url "https://files.pythonhosted.org/packages/8b/0e/62743c098e80dde057afc50f9d681a5ef06cfbd4be377801d0d7e2a0737d/grpcio_health_checking-1.71.0.tar.gz"
    sha256 "ff9bd55beb97ce3322fda2ae58781c9d6c6fcca6a35ca3b712975d9f75dd30af"
  end

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/05/d2/c0866a48c355a6a4daa1f7e27e210c7fa561b1f3b7c0bce2671e89cfa31e/grpcio_tools-1.71.0.tar.gz"
    sha256 "38dba8e0d5e0fb23a034e09644fdc6ed862be2371887eee54901999e8f6792a8"
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
    url "https://files.pythonhosted.org/packages/dc/b2/ce4b867d8cd9c0ee84938ae1e6a6f7926ebf928c9090d036fc3c6a04f946/numpy-2.2.5.tar.gz"
    sha256 "a9c0d994680cd991b1cb772e8b297340085466a6fe964bc9d4e80f5e2f43c291"
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
    url "https://files.pythonhosted.org/packages/17/7d/b9dca7365f0e2c4fa7c193ff795427cfa6290147e5185ab11ece280a18e7/protobuf-5.29.4.tar.gz"
    sha256 "4f1dfcd7997b31ef8f53ec82781ff434a28bf71d9102ddde14d076adcfc78c99"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/10/2e/ca897f093ee6c5f3b0bee123ee4465c50e75431c3d5b6a3b44a47134e891/pydantic-2.11.3.tar.gz"
    sha256 "7471657138c16adad9322fe3070c0116dd6c3ad8d649300e3cbdfe91f4db4ec3"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/17/19/ed6a078a5287aea7922de6841ef4c06157931622c89c2a47940837b5eecd/pydantic_core-2.33.1.tar.gz"
    sha256 "bcc9c6fdb0ced789245b02b7d6603e17d1563064ddcfc36f046b61c0c05dd9df"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/44/80/97e25f0f1e4067677806084b7382a6ff9979f3d15119375c475c288db9d7/setuptools-80.0.0.tar.gz"
    sha256 "c40a5b3729d58dd749c0f08f1a07d134fb8a0a3d7f87dc33e7c5e1f762138650"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/64/07/91582d69320f6f6daaf2d8072608a4ad8884683d4840e7e4f3a9dbdcc639/validators-0.34.0.tar.gz"
    sha256 "647fe407b45af9a74d245b943b18e6a816acf4926974278f6dd617778e1e781f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "weaviate-client" do
    url "https://files.pythonhosted.org/packages/5d/a6/e0a1634efa8bf0e761a6a146d5e822d527e3bc810074d582b979284fcf80/weaviate_client-4.14.1.tar.gz"
    sha256 "fbac4dc73cb65d811865ebb8d42c2c14207cc192f51008009cb54b571e181d1a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"weaviate-cli", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weaviate-cli --version")
    assert_match "Error: Connection to Weaviate failed.", shell_output("#{bin}/weaviate-cli get collection", 1)
  end
end
