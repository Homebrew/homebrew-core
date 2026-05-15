class Safety < Formula
  include Language::Python::Virtualenv

  desc "Checks Python dependencies for known vulnerabilities and suggests remediations"
  homepage "https://safetycli.com/product/safety-cli"
  url "https://files.pythonhosted.org/packages/6f/e8/1cfffa0d8836de8aa31f4fa7fdeb892c7cfa97cd555039ad5df71ce0e968/safety-3.7.0.tar.gz"
  sha256 "daec15a393cafc32b846b7ef93f9c952a1708863e242341ab5bde2e4beabb54e"
  license "MIT"
  revision 11
  head "https://github.com/pyupio/safety.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f34cbecd173d13418d2e14e4e7717f7387b1328e44ce7e8aa5bf48dde77262eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38fd9e599a38fdb03f06d7a2b51735fde2771a1500967a51940868eb62542721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4396f8be0b2dc8a3a904044ddb686ad04e0da26e6231cb070ceeded5695132a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9a4e1f0a7567df3042faac17a5fca4c9c687c3bf0ed4ecd08310e64aafd5635"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70e0eff650c4e1de2db9c3da39df573523074a23ca6c597c5a28074a22415b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0393111515eb6524d14fedb2cf255ff4c915483b6f4fe649c20b8c3934a2140b"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/36/98/7d93f30d029643c0275dbc0bd6d5a6f670661ee6c9a94d93af7ab4887600/authlib-1.7.2.tar.gz"
    sha256 "2cea25fefcd4e7173bdf1372c0afc265c8034b23a8cd5dcb6a9164b826c64231"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "dparse" do
    url "https://files.pythonhosted.org/packages/29/ee/96c65e17222b973f0d3d0aa9bad6a59104ca1b0eb5b659c25c2900fccd85/dparse-0.6.4.tar.gz"
    sha256 "90b29c39e3edc36c6284c82c4132648eaf28a01863eb3c231c2512196132201a"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
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
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/41/f2/d34e8b3a08a9cc79a50b2208a93dce981fe615b64d5a4d4abee421d898df/joblib-1.5.3.tar.gz"
    sha256 "8561a3269e6801106863fd0d6d84bb737be9e7631e33aaed3fb9ce5953688da3"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/3b/dc/5f768c2e391e9afabe5d18e3221346deb5fb6338565f1ccc9e7c6d7befdd/joserfc-1.6.5.tar.gz"
    sha256 "1482a7db78fb4602e44ed89e51b599d052e091288c7c532c5b694e20149dec48"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/25/7e/1dbd4096eb7c148cd2841841916f78820bb85a4d80a0c25c02d30815a7fb/marshmallow-4.3.0.tar.gz"
    sha256 "fb43c53b3fe240b8f6af37223d6ef1636f927ad9bea8ab323afad95dff090880"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/74/a1/b3b4adf15585a5bc4c357adde150c01ebeeb642173ded4d871e89468767c/nltk-3.9.4.tar.gz"
    sha256 "ed03bc098a40481310320808b2db712d95d13ca65b27372f8a403949c8b523d0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "safety-schemas" do
    url "https://files.pythonhosted.org/packages/c2/ef/0e07dfdb4104c4e42ae9fc6e8a0da7be2d72ac2ee198b32f7500796de8f3/safety_schemas-0.0.16.tar.gz"
    sha256 "3bb04d11bd4b5cc79f9fa183c658a6a8cf827a9ceec443a5ffa6eed38a50a24e"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/51/db/03eaf4331631ef6b27d6e3c9b68c54dc6f0d63d87201fed600cc409307fd/tomlkit-0.15.0.tar.gz"
    sha256 "7d1a9ecba3086638211b13814ea79c90dd54dd11993564376f3aa92271f5c7a3"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/safety --version")

    assert_match "Safety is not authenticated, please first authenticate and try again.",
                 shell_output("#{bin}/safety check-updates", 1)
  end
end
