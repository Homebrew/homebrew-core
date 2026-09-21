class SnowflakeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for snowflake"
  homepage "https://docs.snowflake.com/developer-guide/snowflake-cli/index"
  url "https://files.pythonhosted.org/packages/66/84/ba3b207c081ab06e4c872a819d58f3b2b6f2b480bf8a83770466829a0d28/snowflake_cli-3.27.0.tar.gz"
  sha256 "06b619a8565813be78eff46e48e6b912cddf9c381e226a5545a91d91d0511f81"
  license "Apache-2.0"
  head "https://github.com/snowflakedb/snowflake-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b29c22f482d9e4fb8f3ab963c1c7d861ea7aebf94aece517fa1d9c054bf69944"
    sha256 cellar: :any, arm64_tahoe:       "c1f8c964f0b18eff7aa7a372b00c598da72b3aa13b0f5777af185de79966f02f"
    sha256 cellar: :any, arm64_sequoia:     "cc36d0b5e1095818d6227e92fc576887e93cc26cd504e1a50b4ed837904a2e03"
    sha256 cellar: :any, arm64_sonoma:      "a2935d7b1cb267fa5ad3199a884b1e44b281adae80fa5d8a5aa25f54ec51d300"
    sha256 cellar: :any, arm64_linux:       "39f45893762ad2a757e0e441a72e1102e74a81fc6620e09d72816c873c29c8aa"
    sha256 cellar: :any, x86_64_linux:      "eb8faec01ef77edce64e9526ad8621ccb78d9a58263b49e992f92afe1442a392"
  end

  depends_on "protobuf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13" # `snowflake-*-python` doesn't support Python 3.14, https://github.com/snowflakedb/snowflake-cli/issues/2669

  conflicts_with "snow", because: "both install `snow` binaries"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic],
                extra_packages:   %w[jeepney mypy-protobuf secretstorage]

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/67/0b/53f833efea7331aab106a65f1156e0035beed9bacbfcb309b128204468d4/boto3-1.43.90.tar.gz"
    sha256 "4b669742d5b45b8fd20ca50ac414a4e4cf995ebb8f280d21be28676e71c97594"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6b/3e/29872261075d878581a31e9e98c512c0b85322a36e6d6784b9f0694a918d/botocore-1.43.90.tar.gz"
    sha256 "a139ed601e8b8fb1d730022355fe2b284b8c15cfe9ac0f100254a35d2273e1d3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cloudpickle" do
    url "https://files.pythonhosted.org/packages/52/39/069100b84d7418bc358d81669d5748efb14b9cceacd2f9c75f550424132f/cloudpickle-3.1.1.tar.gz"
    sha256 "b216fa8ae4019d5482a8ac3c95d8f6346115d8835911fd4aefd1a445e4242c64"

    # flit-core 4 dropped the legacy `[tool.flit.metadata]` table this uses
    patch do
      url "https://github.com/cloudpipe/cloudpickle/commit/465ac44aa0c85c81fa21324a8c698ad86be38d18.patch?full_index=1"
      sha256 "35f578d5709b32811fe7cdceec6e9df2ddc90578f39e29de8df54bfe323f25f6"
      type :unofficial
      resolves "https://github.com/cloudpipe/cloudpickle/pull/598"
    end
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/46/126b1831dca12060d4a8296bf9c4fe5c93c4f22197fa239cb0cc82042bba/filelock-3.32.6.tar.gz"
    sha256 "a3f55a18af3652a94d8f47d6055df434f254ca1d02ef2524850c6d249ca2512c"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/ca/dc/126b28e76b24a9268ba931ad3e012f71ebdadf62fd9f17758f7074bb0b20/gitpython-3.1.59.tar.gz"
    sha256 "0a1475cfdc38a5bfba1a3e9a4a9da52a39749ecec322b772915c019f94e5b7e4"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/22/11/102da08f88412d875fa2f1a9a469ff7ad4c874b0ca6fed0048fe385bdb3d/id-1.5.0.tar.gz"
    sha256 "292cb8a49eacbbdbce97244f47a97b4c62540169c976552e497fd57df0734c1d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
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

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "mypy-protobuf" do
    url "https://files.pythonhosted.org/packages/87/07/7ffb897eee5c01e816e037f51a6720bf1a0a8c17cca1a2382ae554f43044/mypy_protobuf-5.1.0.tar.gz"
    sha256 "8493758852a9cdc075a11dbe96c6e37ea2feba5fd5f33ef7442b9a275322a94c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/53/18/f3bb8ef0d3b930692343da8aa4d3cbcd6749477c053959395ac81965a6e9/platformdirs-4.11.8.tar.gz"
    sha256 "f23abafea7dd4276d1f29104b83598d7dcc567cafd07c9c951e66665645437fc"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/7e/57/394a763c103e0edf87f0938dafcd918d53b4c011dfc5c8ae80f3b0452dbb/protobuf-5.29.6.tar.gz"
    sha256 "da9ee6a5424b6b30fd5e45c5ea663aef540ca95f9ad99d1e887e819cdf9b8723"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/fb/48/fb042503b6ca6cd271261dc559fd6432f7d8c713153e9ec5c591af4dfc1c/pytz-2026.3.post1.tar.gz"
    sha256 "2211d3fcf9a797d3405cac96ac7f61d80e6a644f72a3309607282fe8a2010c5d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "requirements-parser" do
    url "https://files.pythonhosted.org/packages/95/96/fb6dbfebb524d5601d359a47c78fe7ba1eef90fc4096404aa60c9a906fbb/requirements_parser-0.13.0.tar.gz"
    sha256 "0843119ca2cb2331de4eb31b10d70462e39ace698fd660a915c247d2301a4418"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "snowflake-connector-python" do
    url "https://files.pythonhosted.org/packages/00/2c/bb5ecbd0af9f24b743de2d4a44497be2bdab0e4afcdcd23d96998a2f8d18/snowflake_connector_python-4.7.3.tar.gz"
    sha256 "0f93139c3502c3d23139561b123492c09c33ab12a30956649a01e2cb04f06583"
  end

  resource "snowflake-core" do
    url "https://files.pythonhosted.org/packages/70/6e/35682a0f5c427386a5520dffff09cd70dd2738c1c7bc4d58a30397deb84d/snowflake_core-1.10.0.tar.gz"
    sha256 "242d9635aea06dc2a5e5494ceb6077c76da93bd102ef6e5b477d6820c7d209d9"
  end

  resource "snowflake-snowpark-python" do
    url "https://files.pythonhosted.org/packages/67/98/38189e919c54fc6f09a43e778d850ebf2116ced491595971ae5f9ca01b0c/snowflake_snowpark_python-1.53.0.tar.gz"
    sha256 "6eab04d5703fac72982f3666140c006d6fb9964d46a04fd953766410af8fc62e"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/dd/82/f4bfed3bc18c6ebd6f828320811bbe4098f92a31adf4040bee59c4ae02ea/typer-0.17.3.tar.gz"
    sha256 "0c600503d472bcf98d29914d4dcd67f80c24cc245395e2e00ba3603c9332e8ba"
  end

  resource "types-protobuf" do
    url "https://files.pythonhosted.org/packages/e1/6c/e3e5b3e10bc328126a39637c138f9ebfd734bf14342b9f3540039b4ab995/types_protobuf-7.35.1.20260906.tar.gz"
    sha256 "efd1a3862d4c967dad5512ef8d56b1530ac84f182c41735b94004756518c4998"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/36/57/ed58088fafdf4c55a0ad6bde846502567645424d7ebf325230b9237f4085/wcwidth-0.8.3.tar.gz"
    sha256 "d128512515fbf4612e0ff21fd6380399210318b7b54a9af59dff8454cf9730eb"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/d8/cb/a5abcc2891249f393827c650c6296660ce40374ac22d99ab9aea41f9d2a2/websocket_client-1.9.2.tar.gz"
    sha256 "0fcb57545848be86992e128218fd96dd87a6769ffdb1a968dff79632b85604d0"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  def install
    without = %w[snowflake-snowpark-python]
    without += %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    # run separately to avoid `protoc-wheel-0` dependency
    ENV.append_path "PATH", venv.root/"bin"
    venv.pip_install(resource("snowflake-snowpark-python"), build_isolation: false)

    generate_completions_from_executable(bin/"snow", shell_parameter_format: :typer)

    # Remove pre-built libraries
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    native_subdir = "#{os}_#{arch}"
    native_subdir += "_glibc" if OS.linux?

    venv.site_packages.glob("snowflake/connector/minicore/*").each do |dir|
      next unless dir.directory?
      next if dir.basename.to_s.start_with?("__")
      next if dir.basename.to_s == native_subdir

      rm_r(dir)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snow --version")
    assert_match '"key": "SNOWFLAKE_HOME"', shell_output("#{bin}/snow --info")
    assert_match "No data", shell_output("#{bin}/snow connection list")
  end
end
