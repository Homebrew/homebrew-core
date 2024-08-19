class Scoutsuite < Formula
  include Language::Python::Virtualenv

  desc "Open source multi-cloud security-auditing tool"
  homepage "https://github.com/nccgroup/ScoutSuite"
  url "https://files.pythonhosted.org/packages/a9/41/4f375fac81c66e1475c3ae18753a86191f253cdf24c29f28c8861d6bb984/scoutsuite-5.14.0.tar.gz"
  sha256 "b021ad340196865093fb5d6e247f2596ec856e24cb39eb6e3e886923befd1208"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/nccgroup/ScoutSuite.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "45e2e45097b4002245ed11bcb901ae503d9f618bcc3aef3e829b402d2d4ef0e4"
    sha256 cellar: :any,                 arm64_ventura:  "29202f92735d58c192f98b529303b20a8fb8880707392297f5fefe89b5347df1"
    sha256 cellar: :any,                 arm64_monterey: "6f09032bc650ce9511c7dceb08dde90f9d2ac18f1e97e4a25fbb8d9f27ff2756"
    sha256 cellar: :any,                 sonoma:         "83163acfc0d3dcb240cb251822a1182e021a436c6bc6c9791eb5a8ac1c794f53"
    sha256 cellar: :any,                 ventura:        "0ce53c07dd755bae61c4260699ac5f0c30910b53cbcd9f6e8ee2761b775e5941"
    sha256 cellar: :any,                 monterey:       "ea01ff4982410c7435be5c95ec6e0fcbe75a6d29ec7b882b2599a42dfb197ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e094ad28b2565f574c2a87adf151f07716eb2a6e501f1af7c70a78a97d7d3973"
  end

  depends_on "rust" => :build # for pydantic-core
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "aliyun-python-sdk-actiontrail" do
    url "https://files.pythonhosted.org/packages/69/ec/76d2733699ffb003dffa0da0f0b1cbc34ea48e535f7639deb079b73bd5ed/aliyun-python-sdk-actiontrail-2.2.0.tar.gz"
    sha256 "572e3049529fd6c21974fd2e4fc98b057d2c85ca1d90ca23425c22288d265a37"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/3a/e6/f579e8a5e26ef1066f6fb11074cedc9f668cb5f722c85cf7adc0f7e2e23e/aliyun-python-sdk-core-2.15.1.tar.gz"
    sha256 "518550d07f537cd3afac3b6c93b5c997ce3440e4d0c054e3acbdaa8261e90adf"
  end

  resource "aliyun-python-sdk-ecs" do
    url "https://files.pythonhosted.org/packages/0d/0d/b1b6f58abdd847d48822171925ca4ea24c8cb781d530ab7ab85ce4e83bd1/aliyun-python-sdk-ecs-4.24.73.tar.gz"
    sha256 "df591ac9e89be09a30bf616ca0f8fe34e93c352b0d4763fa879ec6e6d4a20aee"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/c5/a6/f958162647f2f581a5d767a5cf1b9e172183863559abfbe594face7141f7/aliyun-python-sdk-kms-2.16.3.tar.gz"
    sha256 "c31b7d24e153271a3043e801e7b6b6b3f0db47e95a83c8d10cdab8c11662fc39"
  end

  resource "aliyun-python-sdk-ocs" do
    url "https://files.pythonhosted.org/packages/71/1b/33792adaea4a1dfaf8a1224fe28ab07f99faddd9ab1c86d6613647897d92/aliyun-python-sdk-ocs-0.0.4.tar.gz"
    sha256 "361a3c2db0245894de80678366307def76141324d6ce32eb7f119aa981d3ec01"
  end

  resource "aliyun-python-sdk-ram" do
    url "https://files.pythonhosted.org/packages/28/89/382d69161f458879ff6066db61c511de8fa642e1ce1782994a095a51d365/aliyun-python-sdk-ram-3.3.0.tar.gz"
    sha256 "0809c078d1af2ee47736d1f2af161e1ba96b998a5d484e7b3ed71addec55cb43"
  end

  resource "aliyun-python-sdk-rds" do
    url "https://files.pythonhosted.org/packages/6a/cb/4027923848165536cdf85da6fd5b7df9ef3ccdc8d1307bcf90d3f582bc57/aliyun-python-sdk-rds-2.7.48.tar.gz"
    sha256 "e85abd31c8b1a3ea96e60959d044c5d41683c6a9c032d54b135a0f85f218c634"
  end

  resource "aliyun-python-sdk-sts" do
    url "https://files.pythonhosted.org/packages/1a/6a/05667dac3aba64cb1807c1c459b77eeae65006c3a9bc5813e8efacdc59a3/aliyun-python-sdk-sts-3.1.2.tar.gz"
    sha256 "18bce27805f48ff68429e2a3dfb3ed050272ddcdb35a0cb59e8eff957898494d"
  end

  resource "aliyun-python-sdk-vpc" do
    url "https://files.pythonhosted.org/packages/6a/7c/a0da9607bc8a230b53db074b58b62b1f2ca441ee2a60aaa00e9ba65c0f8d/aliyun-python-sdk-vpc-3.0.45.tar.gz"
    sha256 "e26b9905be31755727e0b61d3f70090a12ecb0f6a0bfeaa7be369a78d04ebeb1"
  end

  resource "asyncio-throttle" do
    url "https://files.pythonhosted.org/packages/c2/b4/0b6bd59151d979c3d9902d9b35c992aa1e55ab0f60d8b0b7fbbf61dd3138/asyncio_throttle-0.1.1-py3-none-any.whl"
    sha256 "a01a56f3671e961253cf262918f3e0741e222fc50d57d981ba5c801f284eccfe"
  end

  resource "autocommand" do
    url "https://files.pythonhosted.org/packages/5b/18/774bddb96bc0dc0a2b8ac2d2a0e686639744378883da0fc3b96a54192d7a/autocommand-2.2.2.tar.gz"
    sha256 "878de9423c5596491167225c2a455043c3130fb5b7286ac83443d45e74955f34"

    # Fix compatibility issue with setuptools 69
    patch do
      url "https://github.com/Lucretiel/autocommand/commit/cf98b8bc024f536565a67369a9f9a506fe67b942.patch?full_index=1"
      sha256 "c705aa78d4fcd5fb960243d06332cef6c1a48a2c648c903dc2ac07da77ea83e7"
    end
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/99/d4/1f469fa246f554b86fb5cebc30eef1b2a38b7af7a2c2791bce0a4c6e4604/azure-core-1.30.2.tar.gz"
    sha256 "a14dc210efcd608821aa472d9fb8e8d035d29b68993819147bc290a8ac224472"
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
    url "https://files.pythonhosted.org/packages/14/95/2b2085e40f4b9de88ad256428a669583066d8ab348fc19110c7d04c3189b/azure-mgmt-core-1.4.0.zip"
    sha256 "d195208340094f98e5a6661b781cde6f6a051e79ce317caabd8ff97030a9b3ae"
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
    url "https://files.pythonhosted.org/packages/4d/59/ab0f2464a8887ef15ee6d65c7e7fda939a8187523f96bf4ce21e4c08f993/boto3-1.34.153.tar.gz"
    sha256 "db9f2ac64582d847003a71720cd28dfffff61e2882e5d3db8e0c1fe1902ebb5b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4b/b1/68e0b6c8c93b55833a8c21d3708f4e8e516b6808cfcb3ce010e3fe2aaffd/botocore-1.34.153.tar.gz"
    sha256 "1634a00f996cfff67f0fd4d0ddc436bc3318b2202dfd82ad0bc11c7169694092"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/a7/3f/ea907ec6d15f68ea7f381546ba58adcb298417a59f01a2962cb5e486489f/cachetools-5.4.0.tar.gz"
    sha256 "b8adc2e7c07f105ced7bc56dbb6dfbe7c4a00acce20e2227b3f355be89bc6827"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/92/ec/7f1dd19e3878f5391afb508e6a2fd8d9e5b176ca2992b90b55926c7341d8/circuitbreaker-1.4.0.tar.gz"
    sha256 "80b7bda803d9a20e568453eb26f3530cd9bf602d6414f6ff6a74c611603396d2"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/63/09/1da37a51b232eaf9707919123b2413662e95edd50bace5353a548910eb9d/coloredlogs-10.0.tar.gz"
    sha256 "b869a2dda3fa88154b9dd850e27828d8755bfab5a838a1c97fbc850c6e377c36"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c8/b0/7c8d4a03960da803a4c471545fd7b3404d2819f1585ba3f3d97e887aa91d/google-api-core-1.34.1.tar.gz"
    sha256 "3399c92887a97d33038baa4bfd3bf07acc05d474b0171f333e1f641c1364e552"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/d9/a1/0bd557922bd9cf8b544547f3e91346fda767c11831250cf90f1d7ec920d5/google_api_python_client-2.139.0.tar.gz"
    sha256 "ed4bc3abe2c060a87412465b4e8254620bbbc548eefc5388e2c5ff912d36a68b"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/8c/a3/cc4dc2e8a7f67012a26dec5b6b1fdf5261b12e7d54981c88de2580315726/google_auth-2.32.0.tar.gz"
    sha256 "49315be72c55a6a37d62819e3573f6b416aca00721f7e3e31a008d928bf64022"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/c9/e7/8439212aae2af478c40ea535affe5f1a6132e52b49cec0700e35a8b39813/google_cloud_appengine_logging-1.4.5.tar.gz"
    sha256 "de7d766e5d67b19fc5833974b505b32d2a5bbdfb283fd941e320e7cfdae4cb83"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/b1/3d/48e8b2c0cc7113d1674526b609944ef77d7182f233b23c50fec7106b2e2c/google-cloud-audit-log-0.2.5.tar.gz"
    sha256 "86e2faba3383adc8fd04a5bd7fd4f960b3e4aedaa7ed950f2f891ce16902eb6b"
  end

  resource "google-cloud-container" do
    url "https://files.pythonhosted.org/packages/ce/44/1a31b9650280675bfdb8a1bde0f816436c8301be1f6ce0e2401ae98c11a1/google_cloud_container-2.50.0.tar.gz"
    sha256 "c6af26e2333a45c54025519d3f471986b8994264fbdc01090cb957a3dae36908"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/b8/1f/9d1e0ba6919668608570418a9a51e47070ac15aeff64261fb092d8be94c0/google-cloud-core-2.4.1.tar.gz"
    sha256 "9b7749272a812bde58fff28868d0c5e2f585b82f37e09a1f6ed2d4d10f134073"
  end

  resource "google-cloud-iam" do
    url "https://files.pythonhosted.org/packages/36/3a/312612a3d81080783f374298ee2774fff73e894f248f6822749fd80a71ef/google_cloud_iam-2.15.2.tar.gz"
    sha256 "09b135d96ba2cf6f80a7ed8011436e89d2588e8bb23cd6145c476302f4871a82"
  end

  resource "google-cloud-kms" do
    url "https://files.pythonhosted.org/packages/65/d9/67638b16326a689e5fc6d3e99d77500f008b6d830e912e67e984470de3f7/google-cloud-kms-1.3.0.tar.gz"
    sha256 "ef62aba9f91d590755815e3e701aa5b09f507ee9b7a0acce087f5c427fe1649e"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/eb/61/743eb849427e81f95b9b62e5aaff5e487cd77437d77b8b3d39b8810f6b82/google_cloud_logging-3.11.0.tar.gz"
    sha256 "e53205510652df5794f04176ea395c6cc1862a8e8d2bd0678370a2defeb74bff"
  end

  resource "google-cloud-monitoring" do
    url "https://files.pythonhosted.org/packages/0a/d8/2cb15aa01ace523422fed8bc4aa4fbfac81a31fa0591f01cbb0b72a194e0/google-cloud-monitoring-1.1.0.tar.gz"
    sha256 "30632fa7aad044a3b4e2b662e6ba99f29f60064c1cfc88bbf4d175c1a12ced66"
  end

  resource "google-cloud-resource-manager" do
    url "https://files.pythonhosted.org/packages/62/32/14d345dee1f290a26bd639da8edbca30958865b7cc7207961e10d2f32282/google_cloud_resource_manager-1.12.5.tar.gz"
    sha256 "b7af4254401ed4efa3aba3a929cb3ddb803fa6baf91a78485e45583597de5891"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/16/88/fc34f8c177ad56408d42f4b54c10402366d309737fae206d59fa16a4a27a/google-cloud-storage-2.14.0.tar.gz"
    sha256 "2d23fcf59b55e7b45336729c148bb1c464468c69d5efbaee30f7201dd90eb97e"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/d3/a5/4bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352/google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/d6/3d/d51e8c691d24e08cbf5b1924a4f950c492d44f7e3ccbacf362f1de04ce2b/google-resumable-media-2.7.1.tar.gz"
    sha256 "eae451a7b2e2cdbaaa0fd2eb00cc8a1ee5e95e16b55597359cbc3d27d7d90e33"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/0b/1a/41723ae380fa9c561cbe7b61c4eef9091d5fe95486465ccfc84845877331/googleapis-common-protos-1.63.2.tar.gz"
    sha256 "27c5abdffc4911f28101e635de1533fb4cfd2c37fbaa9174587c799fac90aa87"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/05/6b/13dfa4e7e0551377b6ec234ab70f4e5d26779573a2b3bf41b3a8c86255a4/grpc-google-iam-v1-0.12.7.tar.gz"
    sha256 "009197a7f1eaaa22149c96e5e054ac5934ba7241974e92663d8d3528a21203d1"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/cf/e7/739849982ca7fa1bf5e52a472803618e4f1f2963e9a73b1ca2cb056f95c7/grpcio-1.65.4.tar.gz"
    sha256 "2a4f476209acffec056360d3e647ae0e14ae13dcf3dfb130c227ae1c594cbe39"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/22/62/a86443ec8f7bf635fe0b48abe56cd699816bdc0b29d24e0bcb5cada42d4a/grpcio-status-1.48.2.tar.gz"
    sha256 "53695f45da07437b7c344ee4ef60d370fd2850179f5a28bb26d8e2aa1102ec11"
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/20/ff/bd28f70283b9cca0cbf0c2a6082acbecd822d1962ae7b2a904861b9965f8/importlib_metadata-8.0.0.tar.gz"
    sha256 "188bd24e4c346d3f0a933f275c2fec67050326a856b9a359881d7c2a697e8812"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jaraco-collections" do
    url "https://files.pythonhosted.org/packages/53/87/93c02af0d3ca4c0195242ab74ba6fc4f1f32046e17d5494abdebf7827322/jaraco.collections-5.0.1.tar.gz"
    sha256 "808631b174b84a4e2a592490d62f62dfc15d8047a0f715726098dc43b81a6cfa"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/c9/60/e83781b07f9a66d1d102a0459e5028f3a7816fdd0894cba90bee2bbbda14/jaraco.context-5.3.0.tar.gz"
    sha256 "c2f67165ce1f9be20f32f650f25d8edfc1646a8aeee48ae06fb35f90763576d2"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/03/b1/6ca3c2052e584e9908a2c146f00378939b3c51b839304ab8ef4de067f042/jaraco_functools-4.0.2.tar.gz"
    sha256 "3460c74cd0d32bf82b9576bbb3527c4364d5b27a21f5158a62aed6c4b42e23f5"
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
    url "https://files.pythonhosted.org/packages/82/3c/9f29f6cab7f35df8e54f019e5719465fa97b877be2454e99f989270b4f34/kubernetes-30.1.0.tar.gz"
    sha256 "41e4c77af9f28e7a6c314e3bd06a8c6229ddd787cad684e0ab9f69b498e98ebc"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/01/33/77f586de725fc990d12dda3d4efca4a41635be0f99a987b9cc3a78364c13/more-itertools-10.3.0.tar.gz"
    sha256 "e5d93ef411224fbcef366a6e8ddc4c5781bc6359d43412a65dd5964e46111463"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/03/ce/45b9af8f43fbbf34d15162e1e39ce34b675c234c56638277cc05562b6dbf/msal-1.30.0.tar.gz"
    sha256 "b4bf00850092e465157d814efa24a18f788284c9a479491024d62903085ea2fb"
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
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/d7/dc/61d74a2c355def7c32c24840b72296706f60652c7dc82bbacfc4621d110a/oci-2.130.0.tar.gz"
    sha256 "478a0cdfe910c84b95c35164d7e49b64a51576a6a3fc7e4f6f1c8dc778ec5eee"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/48/d4/e9a0ddef6eed086c96e8265d864a46da099611b7be153b0cfb63fd47e1b4/opentelemetry_api-1.26.0.tar.gz"
    sha256 "2bd639e4bed5b18486fef0b5a520aaffde5a18fc225e808a1ac4df363f43a1ce"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/bf/af/b2d6dee157e56cfd4489173d3a2aebdf57fc70a8e9901edc140e516065ac/oss2-2.18.6.tar.gz"
    sha256 "a9137269a4466cecd61356fc26b6f5cad24c7e79f49bc1589eefbccaebea5104"
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
    url "https://files.pythonhosted.org/packages/8f/fc/bcfc768996b438d6e4bde7a6c8cfd62089847b0f5381a0e0ec2d8ee6b202/portend-3.2.0.tar.gz"
    sha256 "5250a352c19c959d767cac878b829d93e5dc7625a5143399a2a00dc6628ffb72"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/3e/fc/e9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29/proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/f7/00/e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971/pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/ed/19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239/pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pydo" do
    url "https://files.pythonhosted.org/packages/86/b7/661c88bac0ce726848ef4a4f261f5bc3776086953143f17d668663ac4fa6/pydo-0.4.0.tar.gz"
    sha256 "7c6d847d5623f2b20d6b3d283bac8d986d84ddd480b6da05ca1ab395099f857a"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/fb/68/ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020e/pyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/cb/67/94c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fab/s3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlitedict" do
    url "https://files.pythonhosted.org/packages/12/9a/7620d1e9dcb02839ed6d4b14064e609cdd7a8ae1e47289aa0456796dd9ca/sqlitedict-2.1.0.tar.gz"
    sha256 "03d9cfb96d602996f1d4c2db2856f1224b96a9c431bdd16e78032a72940f9e8c"
  end

  resource "tempora" do
    url "https://files.pythonhosted.org/packages/5d/52/b4ff0ca21695a4f8ac0f158d884587b5eba08b0e95356b0ea210e00446ac/tempora-5.7.0.tar.gz"
    sha256 "888190a2dbe3255ff26dfa9fcecb25f4d38434c0f1943cd61de98bb41c410c50"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/5b/83/a5432aa08312fc834ea594473385c005525e6a80d768a2ad246e78877afd/zc.lockfile-3.0.post1.tar.gz"
    sha256 "adb2ee6d9e6a2333c91178dcb2c9b96a5744c78edb7712dc784a7d75648e81ec"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d3/20/b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1/zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
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
