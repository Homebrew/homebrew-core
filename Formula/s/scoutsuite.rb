class Scoutsuite < Formula
  include Language::Python::Virtualenv

  desc "Open source multi-cloud security-auditing tool"
  homepage "https://github.com/nccgroup/ScoutSuite"
  url "https://files.pythonhosted.org/packages/a9/41/4f375fac81c66e1475c3ae18753a86191f253cdf24c29f28c8861d6bb984/scoutsuite-5.14.0.tar.gz"
  sha256 "b021ad340196865093fb5d6e247f2596ec856e24cb39eb6e3e886923befd1208"
  license "GPL-2.0-only"
  revision 4
  head "https://github.com/nccgroup/ScoutSuite.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "617a6f8b92f076b5eb121d447b2fc5e10451a00e4afe5380b80f56d40f5a09d5"
    sha256 cellar: :any,                 arm64_sonoma:  "92e3adfb05aa047a2ba078f3c741800c84011d08fb9943cf84fd37065f92fc1c"
    sha256 cellar: :any,                 arm64_ventura: "527899b1beca122c9fc6404f5d3d9cce2a0e32fab0424b3a33bcd9eca38f81ea"
    sha256 cellar: :any,                 sonoma:        "0ab89a3891bfa958b2f1bc2cb9af8a6e1c8f9ed5a618f6b660c35fda58903ada"
    sha256 cellar: :any,                 ventura:       "87e712e1c870051ff1d5bec8079bf35f6e1fc7cef2dce6332ca92ce6ed3be602"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c81f66cc8b0aad64d23f40f9775257ab4d5ec09aa6126d0483db6fad9767c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5f6a303930349211252b646046710ccfdd01d5bfe0adbb8215e67a0948a3ef"
  end

  depends_on "rust" => :build # for pydantic-core
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "aliyun-python-sdk-actiontrail" do
    url "https://files.pythonhosted.org/packages/69/ec/76d2733699ffb003dffa0da0f0b1cbc34ea48e535f7639deb079b73bd5ed/aliyun-python-sdk-actiontrail-2.2.0.tar.gz"
    sha256 "572e3049529fd6c21974fd2e4fc98b057d2c85ca1d90ca23425c22288d265a37"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/3e/09/da9f58eb38b4fdb97ba6523274fbf445ef6a06be64b433693da8307b4bec/aliyun-python-sdk-core-2.16.0.tar.gz"
    sha256 "651caad597eb39d4fad6cf85133dffe92837d53bdf62db9d8f37dab6508bb8f9"
  end

  resource "aliyun-python-sdk-ecs" do
    url "https://files.pythonhosted.org/packages/be/3b/2ccc93b89f28b6d394ee3cdeddaf58d404b47fd9bfd44d10d584c7e2db85/aliyun-python-sdk-ecs-4.24.82.tar.gz"
    sha256 "66de143670432aa87b2519b2280101832bd56cd84c21c0d6578a69e8304567e3"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/a8/2c/9877d0e6b18ecf246df671ac65a5d1d9fecbf85bdcb5d43efbde0d4662eb/aliyun-python-sdk-kms-2.16.5.tar.gz"
    sha256 "f328a8a19d83ecbb965ffce0ec1e9930755216d104638cd95ecd362753b813b3"
  end

  resource "aliyun-python-sdk-ocs" do
    url "https://files.pythonhosted.org/packages/71/1b/33792adaea4a1dfaf8a1224fe28ab07f99faddd9ab1c86d6613647897d92/aliyun-python-sdk-ocs-0.0.4.tar.gz"
    sha256 "361a3c2db0245894de80678366307def76141324d6ce32eb7f119aa981d3ec01"
  end

  resource "aliyun-python-sdk-ram" do
    url "https://files.pythonhosted.org/packages/27/9c/8248e66c6b81ede261ad6b96fbe2752c62d4fb73cf8a4e6b2afe62e82a81/aliyun-python-sdk-ram-3.3.1.tar.gz"
    sha256 "0fd482d57767862cd9dbd6c992ba3c442b8e199d43bdf2b336b5d41a4edc7957"
  end

  resource "aliyun-python-sdk-rds" do
    url "https://files.pythonhosted.org/packages/be/9e/6ba98c6e163419ef2bb5424ac7edd08e051decdb759873f556c9143998e6/aliyun-python-sdk-rds-2.7.50.tar.gz"
    sha256 "7841ca237b88d4750cca93c20519a8547c8132040680b3b722aba3a898b78e56"
  end

  resource "aliyun-python-sdk-sts" do
    url "https://files.pythonhosted.org/packages/1a/6a/05667dac3aba64cb1807c1c459b77eeae65006c3a9bc5813e8efacdc59a3/aliyun-python-sdk-sts-3.1.2.tar.gz"
    sha256 "18bce27805f48ff68429e2a3dfb3ed050272ddcdb35a0cb59e8eff957898494d"
  end

  resource "aliyun-python-sdk-vpc" do
    url "https://files.pythonhosted.org/packages/ea/15/7914a347e8a23c4c28a8c23c3eac700bc2689408756e0765912ecab33e6c/aliyun-python-sdk-vpc-3.0.46.tar.gz"
    sha256 "41b6a15b78481fe3bcb8338e2bc97d268c24a9dc454b02fa9264f46f378c3730"
  end

  resource "asyncio-throttle" do
    url "https://files.pythonhosted.org/packages/c2/b4/0b6bd59151d979c3d9902d9b35c992aa1e55ab0f60d8b0b7fbbf61dd3138/asyncio_throttle-0.1.1-py3-none-any.whl"
    sha256 "a01a56f3671e961253cf262918f3e0741e222fc50d57d981ba5c801f284eccfe"
  end

  resource "autocommand" do
    url "https://files.pythonhosted.org/packages/5b/18/774bddb96bc0dc0a2b8ac2d2a0e686639744378883da0fc3b96a54192d7a/autocommand-2.2.2.tar.gz"
    sha256 "878de9423c5596491167225c2a455043c3130fb5b7286ac83443d45e74955f34"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/c9/29/ff7a519a315e41c85bab92a7478c6acd1cf0b14353139a08caee4c691f77/azure_core-1.34.0.tar.gz"
    sha256 "bdb544989f246a0ad1c85d72eeb45f2f835afdcbc5b45e43f0dbde7461c81ece"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/09/73/a71e7bcd7e79afecf8cf5ec1a330804bc5e11f649436729d748df156d89d/azure-identity-1.5.0.zip"
    sha256 "872adfa760b2efdd62595659b283deba92d47b7a67557eb9ff48f0b5d04ee396"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/7b/39/46adcbabc61a6d91f8514b46a2b64cfba365170325a6c38c31e2c1567090/azure-mgmt-authorization-3.0.0.zip"
    sha256 "0a5d7f683bf3372236b841cdbd4677f6b08ed7ce41b999c3e644d4286252057d"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/0d/0e/e4a61d8b73fe8afdeb115d577d8417dc599a1b4d5447067b0eb02c1cb8c8/azure-mgmt-compute-18.2.0.zip"
    sha256 "599b829f189f2ed2338dad60b823818943bb236cf6e22128d988a8c787c56ebd"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/48/9a/9bdc35295a16fe9139a1f99c13d9915563cbc4f30b479efaa40f8694eaf7/azure_mgmt_core-1.5.0.tar.gz"
    sha256 "380ae3dfa3639f4a5c246a7db7ed2d08374e88230fd0da3eb899f7c11e5c441a"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/69/56/678b158efbd4b4d70151a0d688e11a529a42eac3ff426813878f253f76c4/azure-mgmt-keyvault-8.0.0.zip"
    sha256 "2c974c6114d8d27152642c82a975812790a5e86ccf609bf370a476d9ea0d2e7d"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/d1/07/6109120151e9bb768a581fccea4adfc1016bcf3cfe7a167431d400b277ac/azure-mgmt-monitor-2.0.0.zip"
    sha256 "e7f7943fe8f0efe98b3b1996cdec47c709765257a6e09e7940f7838a0f829e82"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/53/58/d8d097b24d8a73a48ad6691197ba787c6e9809f44debaab90d55a5b52663/azure-mgmt-network-17.1.0.zip"
    sha256 "f47852836a5960447ab534784a9285696969f007744ba030828da2eab92621ab"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/40/b0/024e21f57fea50338ea799d36f21c124ac0a83cb63b2e7cff2b1a51ceedc/azure-mgmt-rdbms-8.0.0.zip"
    sha256 "8b018543048fc4fddb4155d9f22246ad0c4be2fb582a29dbb21ec4022724a119"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/38/0c/1fae863867ab615c23fc62c1f1895aef20af432c79f9adf69b9a26139158/azure-mgmt-redis-12.0.0.zip"
    sha256 "8ae563e3df82a2f206d0483ae6f05d93d0d1835111c0bbca7236932521eed356"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/9b/a9/4430d728c8b1db0ff2eac5b7a2b210c5ba70a7590613664e4c8e8fb10c11/azure-mgmt-resource-15.0.0.zip"
    sha256 "80ecb69aa21152b924edf481e4b26c641f11aa264120bc322a14284811df9c14"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/ad/42/24fd912d55213fd8d54da309137a1484d41b3dea48f49d22190cbe4bcde8/azure-mgmt-security-1.0.0.zip"
    sha256 "ae1cff598dfe80e93406e524c55c3f2cbffced9f9b7a5577e3375008a4c3bcad"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/c4/1f/40af724de7a0b00f9a8986ec3554adf1c1cbc5f65c6401d3b0d7b86fc169/azure-mgmt-sql-1.0.0.zip"
    sha256 "c7904f8798fbb285a2160c41c8bd7a416c6bd987f5d36a9b98c16f41e24e9f47"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/f5/a3/c1877ded12ea772db0e8ddb374c9252ae958e38ae85301731e927cb8253b/azure-mgmt-storage-17.0.0.zip"
    sha256 "c0e3fd99028d98c80dddabe1c22dfeb3d694e5c1393c6de80766eb240739e4bc"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/c1/8d/1f785a405bbeea818020a83dedbee6075b25c7354e7bb9f45010d4357468/azure-mgmt-web-1.0.0.zip"
    sha256 "c4b218a5d1353cd7c55b39c9b2bd1b13bfbe3b8a71bc735122b171eab81670d1"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/5a/66/a26e7f20039ae3c57524baf26af43216c3959013f23308458f211cce78a5/boto3-1.38.40.tar.gz"
    sha256 "fcef3e08513d276c97d72d5e7ab8f3ce9950170784b9b5cf4fab327cdb577503"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/61/23/42cc861466a34e45bd1783c3b3a547d5f723a8d21f6151cd1e3d84adfba6/botocore-1.38.40.tar.gz"
    sha256 "aefbfe835a7ebe9bbdd88df3999b0f8f484dd025af4ebb3f3387541316ce4349"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/63/e2/f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1/cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "cherrypy" do
    url "https://files.pythonhosted.org/packages/93/e8/2f7ef142d1962d08a8885c4c9942212abecad6a80ccdd1620fd1f5c993fd/cherrypy-18.10.0.tar.gz"
    sha256 "6c70e78ee11300e8b21c0767c542ae6b102a49cac5cfd4e3e313d7bb907c5891"
  end

  resource "cherrypy-cors" do
    url "https://files.pythonhosted.org/packages/e0/c3/d62ce781e2e2be9c2d4c5670f0bff518dc1b00396e2ce135dbfdcd4f1b9d/cherrypy-cors-1.7.0.tar.gz"
    sha256 "83384cd664a7ab8b9ab7d4926fe9713acfe0bce3665ee28189a0fa04b9f212d6"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/63/09/1da37a51b232eaf9707919123b2413662e95edd50bace5353a548910eb9d/coloredlogs-10.0.tar.gz"
    sha256 "b869a2dda3fa88154b9dd850e27828d8755bfab5a838a1c97fbc850c6e377c36"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/9d/a4/e44218c2b394e31a6dd0d6b095c4e1f32d0be54c2a4b250032d717647bab/durationpy-0.10.tar.gz"
    sha256 "1fa6893409a6e739c9c72334fc65cca1f355dbdd93405d30f726deb5bde42fba"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c8/b0/7c8d4a03960da803a4c471545fd7b3404d2819f1585ba3f3d97e887aa91d/google-api-core-1.34.1.tar.gz"
    sha256 "3399c92887a97d33038baa4bfd3bf07acc05d474b0171f333e1f641c1364e552"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/8f/7e/7c6e43e54f611f0f97f1678ea567fe06fecd545bd574db05e204e5b136fe/google_api_python_client-2.173.0.tar.gz"
    sha256 "b537bc689758f4be3e6f40d59a6c0cd305abafdea91af4bc66ec31d40c08c804"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/9e/9b/e92ef23b84fa10a64ce4831390b7a4c2e53c0132568d99d4ae61d04c8855/google_auth-2.40.3.tar.gz"
    sha256 "500c3a29adedeb36ea9cf24b8d10858e152f2412e3ca37829b3fa18e33d63b77"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/e7/ea/85da73d4f162b29d24ad591c4ce02688b44094ee5f3d6c0cc533c2b23b23/google_cloud_appengine_logging-1.6.2.tar.gz"
    sha256 "4890928464c98da9eecc7bf4e0542eba2551512c0265462c10f3a3d2a6424b90"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/85/af/53b4ef636e492d136b3c217e52a07bee569430dda07b8e515d5f2b701b1e/google_cloud_audit_log-0.3.2.tar.gz"
    sha256 "2598f1533a7d7cdd6c7bf448c12e5519c1d53162d78784e10bcdd1df67791bc3"
  end

  resource "google-cloud-container" do
    url "https://files.pythonhosted.org/packages/6a/a6/9ddc3fc102d4c6f628c72d1dcd45e59c34846e972e57db6194fd94254ffd/google_cloud_container-2.57.0.tar.gz"
    sha256 "fa7e6f593f58348b98bd6dd59344c9a6038e9fba6c0b9858e23d9d278346f129"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/d6/b8/2b53838d2acd6ec6168fd284a990c76695e84c65deee79c9f3a4276f6b4f/google_cloud_core-2.4.3.tar.gz"
    sha256 "1fab62d7102844b278fe6dead3af32408b1df3eb06f5c7e8634cbd40edc4da53"
  end

  resource "google-cloud-iam" do
    url "https://files.pythonhosted.org/packages/b5/ad/ab2b822f40861c451e8d91d6f6343fcd67cdc25c4c537dee86a70c7f0c4c/google_cloud_iam-2.19.1.tar.gz"
    sha256 "f059c369ad98af6be3401f0f5d087775d775fb96833be1e9ab8048c422fb1bf4"
  end

  resource "google-cloud-kms" do
    url "https://files.pythonhosted.org/packages/65/d9/67638b16326a689e5fc6d3e99d77500f008b6d830e912e67e984470de3f7/google-cloud-kms-1.3.0.tar.gz"
    sha256 "ef62aba9f91d590755815e3e701aa5b09f507ee9b7a0acce087f5c427fe1649e"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/14/9c/d42ecc94f795a6545930e5f846a7ae59ff685ded8bc086648dd2bee31a1a/google_cloud_logging-3.12.1.tar.gz"
    sha256 "36efc823985055b203904e83e1c8f9f999b3c64270bcda39d57386ca4effd678"
  end

  resource "google-cloud-monitoring" do
    url "https://files.pythonhosted.org/packages/0a/d8/2cb15aa01ace523422fed8bc4aa4fbfac81a31fa0591f01cbb0b72a194e0/google-cloud-monitoring-1.1.0.tar.gz"
    sha256 "30632fa7aad044a3b4e2b662e6ba99f29f60064c1cfc88bbf4d175c1a12ced66"
  end

  resource "google-cloud-resource-manager" do
    url "https://files.pythonhosted.org/packages/cd/74/db14f34283b325b775b3287cd72ce8c43688bdea26801d02017a2ccded08/google_cloud_resource_manager-1.14.0.tar.gz"
    sha256 "daa70a3a4704759d31f812ed221e3b6f7b660af30c7862e4a0060ea91291db30"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/16/88/fc34f8c177ad56408d42f4b54c10402366d309737fae206d59fa16a4a27a/google-cloud-storage-2.14.0.tar.gz"
    sha256 "2d23fcf59b55e7b45336729c148bb1c464468c69d5efbaee30f7201dd90eb97e"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/19/ae/87802e6d9f9d69adfaedfcfd599266bf386a54d0be058b532d04c794f76d/google_crc32c-1.7.1.tar.gz"
    sha256 "2bff2305f98846f3e825dbeec9ee406f89da7962accdb29356e4eadc251bd472"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/58/5a/0efdc02665dca14e0837b62c8a1a93132c264bd02054a15abb2218afe0ae/google_resumable_media-2.7.2.tar.gz"
    sha256 "5280aed4629f2b60b847b0d42f9857fd4935c11af266744df33d8074cae92fe0"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/05/6b/13dfa4e7e0551377b6ec234ab70f4e5d26779573a2b3bf41b3a8c86255a4/grpc-google-iam-v1-0.12.7.tar.gz"
    sha256 "009197a7f1eaaa22149c96e5e054ac5934ba7241974e92663d8d3528a21203d1"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/8e/7b/ca3f561aeecf0c846d15e1b38921a60dffffd5d4113931198fbf455334ee/grpcio-1.73.0.tar.gz"
    sha256 "3af4c30918a7f0d39de500d11255f8d9da4f30e94a2033e70fe2a720e184bd8e"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/62/5e/7b4c5c6e0adeeb981f1e7e1a39da3d75ff8f45bc24a74171f5eb1557d2e7/grpcio-status-1.49.0rc1.tar.gz"
    sha256 "9a9253d863dba4c573a1734055c5f63fe5b9fc49feff55099fe79866ae64c877"
  end

  resource "httpagentparser" do
    url "https://files.pythonhosted.org/packages/bc/4d/1fc46c8a2c9a0ceb9e9580d7ce92bf764c373deb7af61fde2fd7b5516495/httpagentparser-1.9.5.tar.gz"
    sha256 "53cefd9d65990f6fe59c0378cad8ea1b9df8f770d2e8bd9d8762edae033be80a"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httplib2shim" do
    url "https://files.pythonhosted.org/packages/5e/bf/d2762b70dd184959ac03f1ccbb61bff5b8bbfa9c0b7cc8ed522b963cd198/httplib2shim-0.0.3.tar.gz"
    sha256 "7c61daebd93ed7930df9ded4dbf47f87d35a8f29363d6e399fbf9fec930f8d17"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jaraco-collections" do
    url "https://files.pythonhosted.org/packages/8c/ed/3f0ef2bcf765b5a3d58ecad8d825874a3af1e792fa89f89ad79f090a4ccc/jaraco_collections-5.1.0.tar.gz"
    sha256 "0e4829409d39ad18a40aa6754fee2767f4d9730c4ba66dc9df89f1d2756994c2"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jaraco-text" do
    url "https://files.pythonhosted.org/packages/4f/00/1b4dbbc5c6dcb87a4278cc229b2b560484bf231bba7922686c5139e5f934/jaraco_text-4.0.0.tar.gz"
    sha256 "5b71fecea69ab6f939d4c906c04fee1eda76500d1641117df6ec45b865f10db0"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/ae/52/19ebe8004c243fdfa78268a96727c71e08f00ff6fe69a301d0b7fcbce3c2/kubernetes-33.1.0.tar.gz"
    sha256 "f64d829843a54c251061a8e7a14523b521f2dc5c896cf6d65ccf348648a88993"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ce/a0/834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09/more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/3f/90/81dcc50f0be11a8c4dcbae1a9f761a26e5f905231330a7cacc9f04ec4c61/msal-1.32.3.tar.gz"
    sha256 "5eea038689c78a5a70ca8ecbe1245458b55a857bd096efb6989c69ba15985d35"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/a4/9c/57f1a1023b6f6560180163a92fdb307672ed50e74e2e8328b69954ccc5e9/msal-extensions-0.3.1.tar.gz"
    sha256 "d9029af70f2cbdc5ad7ecfed61cb432ebe900484843ccf72825445dbfe62d311"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/35/94/e2a15b577044b6b0e4b610a26fcd4439863d8d21bda419e0fd24580316cd/msgraph-core-0.2.2.tar.gz"
    sha256 "147324246788abe8ed7e05534cd9e4e0ec98b33b30e011693b8d014cebf97f63"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/bf/be/d429f4fbd481670deb6613d4702eb135eca903a0001478e4dc6b78c9d904/oci-2.154.2.tar.gz"
    sha256 "4927255e3a573e56ad10a904d498fc8de306eee379157ecf7dcfef1cd53713b1"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/4d/5e/94a8cb759e4e409022229418294e098ca7feca00eb3c467bb20cbd329bda/opentelemetry_api-1.34.1.tar.gz"
    sha256 "64f0bd06d42824843731d05beea88d4d4b6ae59f9fe347ff7dfa2cc14233bbb3"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/df/b5/f2cb1950dda46ac2284d6c950489fdacd0e743c2d79a347924d3cc44b86f/oss2-2.19.1.tar.gz"
    sha256 "a8ab9ee7eb99e88a7e1382edc6ea641d219d585a7e074e3776e9dec9473e59c1"
  end

  resource "policyuniverse" do
    url "https://files.pythonhosted.org/packages/03/a2/6cf14186b746fbcab73e507968e0b1927ad2e91dcb67af967f65d6cbe6c1/policyuniverse-1.5.1.20231109.tar.gz"
    sha256 "74e56d410560915c2c5132e361b0130e4bffe312a2f45230eac50d7c094bc40a"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "portend" do
    url "https://files.pythonhosted.org/packages/b7/57/be90f42996fc4f57d5742ef2c95f7f7bb8e9183af2cc11bff8e7df338888/portend-3.2.1.tar.gz"
    sha256 "aa9d40ab1f9e14bdb7d401f42210df35d017c9b97991baeb18568cedfb8c6489"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pydo" do
    url "https://files.pythonhosted.org/packages/d5/a3/18bcc6064402bc3411d569701582f731ccf8308772e6350291e1f06db52b/pydo-0.11.0.tar.gz"
    sha256 "b03ad8fa5cd321b02ce649c6b928f85964d7b9e6c6f3ecf47ec5f2d4b30751f9"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/c1/d4/1067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085/pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ed/5d/9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191a/s3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlitedict" do
    url "https://files.pythonhosted.org/packages/12/9a/7620d1e9dcb02839ed6d4b14064e609cdd7a8ae1e47289aa0456796dd9ca/sqlitedict-2.1.0.tar.gz"
    sha256 "03d9cfb96d602996f1d4c2db2856f1224b96a9c431bdd16e78032a72940f9e8c"
  end

  resource "tempora" do
    url "https://files.pythonhosted.org/packages/c3/f2/bbd6d2178791eaf8bac06857cb0ee39840e69f7b64ecb0c414bf8f46daff/tempora-5.8.0.tar.gz"
    sha256 "1e9606e65a3f2063460961d68515dee07bdaca0859305a8d3e6604168175fef1"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/5b/83/a5432aa08312fc834ea594473385c005525e6a80d768a2ad246e78877afd/zc.lockfile-3.0.post1.tar.gz"
    sha256 "adb2ee6d9e6a2333c91178dcb2c9b96a5744c78edb7712dc784a7d75648e81ec"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scout --version").chomp
    aws_output = "Authentication failure: Unable to locate credentials"
    assert_match aws_output, shell_output("#{bin}/scout aws 2>&1", 101)
    aliyun_output = "scout aliyun: error: one of the arguments --access-keys is required"
    assert_match aliyun_output, shell_output("#{bin}/scout aliyun 2>&1", 2)
  end
end
