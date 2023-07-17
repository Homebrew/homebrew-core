class Sgr < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for Splitgraph, a version control system for data"
  homepage "https://www.splitgraph.com/docs/sgr-advanced/getting-started/introduction"
  url "https://files.pythonhosted.org/packages/dd/61/7d6cf822edb39d2426f6f185c7fc4de0ad4b80e0da3e5f50d94952795c11/splitgraph-0.3.12.tar.gz"
  sha256 "76a4476002b5ac5a2b9fba36b6fcffd85b878bcc25f5aae411387e04a5532459"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b44d47425142aab7bbe52fd908ba6ed8ff3bc44bcaa35653bd25b02e681ee29f"
    sha256 cellar: :any,                 arm64_monterey: "e6ad108bade39a26f5cb36b864f53937d6c89ec2d26a6720601febc795536bcd"
    sha256 cellar: :any,                 arm64_big_sur:  "6da3bd99ff1bafffc35d44b9907ba18f4c748422c751e104df77ee08a02753c3"
    sha256 cellar: :any,                 ventura:        "c15d2d45921e7d7163523bc1d6baab1f3b3874c3e5192562576876f7480df664"
    sha256 cellar: :any,                 monterey:       "d1c01e594a1de42afdf765e755281a04c72e9bb1532ec3a8f005144f7421f54f"
    sha256 cellar: :any,                 big_sur:        "fb1721e0962179b51d40fa6afec2f1c64c32cc50978f9456b7e3c6e700a8e0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8733322e07aea535dffddfa8153f0ccf155f7cbe8881e42139badb2c1c935172"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for cryptography
  depends_on "libpq" # for psycopg2-binary
  depends_on "openssl@3"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  # Manually update `pglast` from ==3.4 to support python 3.11
  # https://github.com/splitgraph/sgr/pull/814

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/42/97/41ccb6acac36fdd13592a686a21b311418f786f519e5794b957afbcea938/annotated_types-0.5.0.tar.gz"
    sha256 "47cdc3490d9ac1506ce92c7aaa76c579dc3509ff11e098fc867e5130ab7be802"
  end

  resource "asciitree" do
    url "https://files.pythonhosted.org/packages/2d/6a/885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913/asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
    sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/71/f6/fbe4661d202d11c9399d6bec6b2ad381f11e9643ae25236c3904cf46a331/joblib-1.3.1.tar.gz"
    sha256 "1f937906df65329ba98013dc9692fe22a4c5e4a648112de500508b18a21b41e3"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/7e/6b/38c38d113b5f215029cbe8133e7f907540fefa918d872fa3256416e477bf/jsonschema-4.18.3.tar.gz"
    sha256 "64b7104d72efe856bea49ca4af37a14a9eba31b40bb7238179f3803130fd34d9"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/9a/8c/3d028449ac15cba52db3e1c95ca53b9240b4707fbe17f43e01cc73dd9336/jsonschema_specifications-2023.6.1.tar.gz"
    sha256 "ca1c4dd059a9e7b34101cf5b3ab7ff1d18b139f35950d598d629837ef66e8f28"
  end

  resource "minio" do
    url "https://files.pythonhosted.org/packages/cc/70/138926e7477f57ba32d2c0700517813234b0f5cd8f0a48e21641c9288ef1/minio-7.1.15.tar.gz"
    sha256 "fcf8ac2cef310d5ddff2bef2c42f4e5a8bb546b87bca5bf8832135db054ca4e1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/02/fc/067a3f89869a41009e1a7cdfb14725f8ddd246f30f63c645e8ef8a1c56f4/parsimonious-0.8.1.tar.gz"
    sha256 "3add338892d580e0cb3b1a39e4a1b427ff9f687858fdd61097053742391a9f6b"
  end

  resource "pglast" do
    url "https://files.pythonhosted.org/packages/3b/a8/4d85067f06f13e8199dcf1efc57668e7e45160f618ae47864e98560c7b16/pglast-3.17.tar.gz"
    sha256 "0b6496b97e8bb7847adab90d27da8ea152b9d23f93524868194c3eb1e5a34d0c"
  end

  resource "psycopg2-binary" do
    url "https://files.pythonhosted.org/packages/98/3e/05ab0922422c91ca0ecb5939a100f8dc2b5d15f5978433beadc87c5329bf/psycopg2-binary-2.9.6.tar.gz"
    sha256 "1f64dcfb8f6e0c014c7f55e51c9759f024f70ea572fbdef123f85318c297947c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/11/07/106b00ae62297bb3c89b6fbeb571feaf7cbbf6b2ada0e513d756daafd4ce/pydantic-2.0.3.tar.gz"
    sha256 "94f13e0dcf139a5125e88283fc999788d894e14ed90cf478bcc2ee50bd4fc630"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/57/ea/edff47ad42857534f3abcc87472802b3181041f4e4fbeac988a5ecfcffae/pydantic_core-2.3.0.tar.gz"
    sha256 "5cfb5ac4e82c47d5dc25b209dd4c3989e284b80109f9e08b33c895080c424b4f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/20/93/45213b5b6e3eeab03e3f6eb82cc516a81fbf257586a25f9eb1d21af96e1b/referencing-0.29.1.tar.gz"
    sha256 "90cb53782d550ba28d2166ef3f55731f38397def8832baac5d45235f1995e35e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e6/fe/7d07bc08cce2ccae2c7e5c96d9b3976c4e1fa5e248989dca0a58bc7628f8/rpds_py-0.8.10.tar.gz"
    sha256 "13e643ce8ad502a0263397362fb887594b49cf84bf518d6038c16f235f2bcea4"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "sodapy" do
    url "https://files.pythonhosted.org/packages/ad/1e/d01ef2bc1b6199edfb0d00302fe3642d61a09175dd3e78832c78301b2ab6/sodapy-2.2.0.tar.gz"
    sha256 "58af376d3bb0dc3a1edc7c8cf9938f5de8f558b35e240438dd83647ac3621981"
  end

  resource "splitgraph-pipelinewise-target-postgres" do
    url "https://files.pythonhosted.org/packages/59/54/de6a8a2b6bdb24de8d8fd4a2465532f3523abc750af4dd9d6e5c17ce6a53/splitgraph-pipelinewise-target-postgres-2.1.0.tar.gz"
    sha256 "9d100ac65288ce24a90da159bbbb06f0fdc0871c2815c63bb6417fea7df4894f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # Remove when merged/released: https://github.com/splitgraph/sgr/pull/813
  patch do
    url "https://github.com/splitgraph/sgr/commit/234bcc12d21860852a40e78a22976ae33d2f2f57.patch?full_index=1"
    sha256 "1308f9172de2268cadc7ae7521a0f109df3cdc40d60f4908d69934acb777a2d5"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    sgr_status = shell_output("#{bin}/sgr cloud login --username homebrewtest --password correcthorsebattery 2>&1", 2)

    expected_output = <<~EOS
      error: splitgraph.exceptions.AuthAPIError: {"error_code":"INVALID_CREDENTIALS","error":"Invalid username or password"}
    EOS

    assert_equal expected_output, sgr_status
  end
end
