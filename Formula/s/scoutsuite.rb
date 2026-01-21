class Scoutsuite < Formula
  include Language::Python::Virtualenv

  desc "Open source multi-cloud security-auditing tool"
  homepage "https://github.com/nccgroup/ScoutSuite"
  url "https://files.pythonhosted.org/packages/a9/41/4f375fac81c66e1475c3ae18753a86191f253cdf24c29f28c8861d6bb984/scoutsuite-5.14.0.tar.gz"
  sha256 "b021ad340196865093fb5d6e247f2596ec856e24cb39eb6e3e886923befd1208"
  license "GPL-2.0-only"
  revision 7
  head "https://github.com/nccgroup/ScoutSuite.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c978a1862c02ae74391c73a700e2f265c364bdb207c01ba5a32b0930dbb001a"
    sha256 cellar: :any,                 arm64_sequoia: "1cbc0e8fcb0631c115de9c0621af8234cac9b983b3d94259b4b8890cfa465db8"
    sha256 cellar: :any,                 arm64_sonoma:  "f28a4604b7f9e7874633f76627297bb8889abdba48a47089718961dd7a898882"
    sha256 cellar: :any,                 sonoma:        "0d29cf05a6e0baa800d6b9b1eccdef1007a65791d8b47777d54bebfd2b2d5b6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c40a022a77e92feb324d29dcc320797bd22fcc6d47e36a6c289a2025302897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f3002e5075a6b35f11341855d18558ae7aeaa89c9528cc1ebc1557fc224fe1"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

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
    url "https://files.pythonhosted.org/packages/9c/7e/3da459ddb990d15cd42a0097ff5d6cd979e738eac1cb0ee708bae5d588b5/aliyun-python-sdk-rds-2.7.53.tar.gz"
    sha256 "057b4da4e3b645477e5702dfe010a5aa9ef21b96b4d0df8be395db39e0a4de0e"
  end

  resource "aliyun-python-sdk-sts" do
    url "https://files.pythonhosted.org/packages/0c/64/65ad5261c2d65aac910c41a7aeee80643a6393024f838e28f52d48cddf4c/aliyun-python-sdk-sts-3.1.3.tar.gz"
    sha256 "22fedb8bad13f966e711a1f4662eed7b9db33441bc05aa4b0f918aa01e09b967"
  end

  resource "aliyun-python-sdk-vpc" do
    url "https://files.pythonhosted.org/packages/cc/c8/a8e82462e756e44ffe513bdce3d6b495f3af1afc65b9fa4ffa90aa8bfa17/aliyun-python-sdk-vpc-3.0.47.tar.gz"
    sha256 "ca31a5e278615279eb2f1bcd1f8b5abde032181e7d2d6ae3a84915646e2b4a31"
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
    url "https://files.pythonhosted.org/packages/dc/1b/e503e08e755ea94e7d3419c9242315f888fc664211c90d032e40479022bf/azure_core-1.38.0.tar.gz"
    sha256 "8194d2682245a3e4e3151a667c686464c3786fed7918b394d035bdcd61bb5993"
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
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
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
    url "https://files.pythonhosted.org/packages/42/79/2dac8b7cb075cfa43908ee9af3f8ee06880d84b86013854c5cca8945afac/boto3-1.42.30.tar.gz"
    sha256 "ba9cd2f7819637d15bfbeb63af4c567fcc8a7dcd7b93dd12734ec58601169538"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/44/38/23862628a0eb044c8b8b3d7a9ad1920b3bfd6bce6d746d5a871e8382c7e4/botocore-1.42.30.tar.gz"
    sha256 "9bf1662b8273d5cc3828a49f71ca85abf4e021011c1f0a71f41a2ea5769a5116"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/68/e4/5c2020b60a55aca8d79ed55b62ad1cd7fc47ea44ad6b584e83f5f1bf58b0/cheroot-11.1.2.tar.gz"
    sha256 "bfb70c49663f63b0440f2b54dbc6b0d1650e56dfe4e2641f59b2c6f727b44aca"
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
    url "https://files.pythonhosted.org/packages/a8/d7/14613c7efbab5b428b400961f5dbac46ad9e019c44e1f3fd14d67c33111c/google_api_python_client-2.188.0.tar.gz"
    sha256 "5c469db6614f071009e3e5bb8b6aeeccae3beb3647fa9c6cd97f0d551edde0b6"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/60/3c/ec64b9a275ca22fa1cd3b6e77fefcf837b0732c890aa32d2bd21313d9b33/google_auth-2.47.0.tar.gz"
    sha256 "833229070a9dfee1a353ae9877dcd2dec069a8281a4e72e72f77d4a70ff945da"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/d5/ad/c1f2b1175096a8d04cf202ad5ea6065f108d26be6fc7215876bde4a7981d/google_auth_httplib2-0.3.0.tar.gz"
    sha256 "177898a0175252480d5ed916aeea183c2df87c1f9c26705d74ae6b951c268b0b"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/65/38/89317773c64b5a7e9b56b9aecb2e39ac02d8d6d09fb5b276710c6892e690/google_cloud_appengine_logging-1.8.0.tar.gz"
    sha256 "84b705a69e4109fc2f68dfe36ce3df6a34d5c3d989eee6d0ac1b024dda0ba6f5"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/c7/d2/ad96950410f8a05e921a6da2e1a6ba4aeca674bbb5dda8200c3c7296d7ad/google_cloud_audit_log-0.4.0.tar.gz"
    sha256 "8467d4dcca9f3e6160520c24d71592e49e874838f174762272ec10e7950b6feb"
  end

  resource "google-cloud-container" do
    url "https://files.pythonhosted.org/packages/00/6e/0eee176b31231b8c18d51c19dbb1b0609ae394a85895e23967657904c2ff/google_cloud_container-2.62.0.tar.gz"
    sha256 "3bae3b270deff640f53e7d2768fbc03ffbf3531a886560fb9e4f7b55146cd53f"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/a6/03/ef0bc99d0e0faf4fdbe67ac445e18cdaa74824fd93cd069e7bb6548cb52d/google_cloud_core-2.5.0.tar.gz"
    sha256 "7c1b7ef5c92311717bd05301aa1a91ffbc565673d3b0b4163a52d8413a186963"
  end

  resource "google-cloud-iam" do
    url "https://files.pythonhosted.org/packages/aa/0b/037b1e1eb601646d6f49bc06d62094c1d0996b373dcbf70c426c6c51572e/google_cloud_iam-2.21.0.tar.gz"
    sha256 "fc560527e22b97c6cbfba0797d867cf956c727ba687b586b9aa44d78e92281a3"
  end

  resource "google-cloud-kms" do
    url "https://files.pythonhosted.org/packages/65/d9/67638b16326a689e5fc6d3e99d77500f008b6d830e912e67e984470de3f7/google-cloud-kms-1.3.0.tar.gz"
    sha256 "ef62aba9f91d590755815e3e701aa5b09f507ee9b7a0acce087f5c427fe1649e"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/7f/47/31ef0261802fe8b37c221392e1d6ff01d30b03dce5e20e77fc7d57ddf8a3/google_cloud_logging-3.13.0.tar.gz"
    sha256 "3aae0573b1a1a4f59ecdf4571f4e7881b5823bd129fe469561c1c49a7fa8a4c1"
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
    url "https://files.pythonhosted.org/packages/03/41/4b9c02f99e4c5fb477122cd5437403b552873f014616ac1d19ac8221a58d/google_crc32c-1.8.0.tar.gz"
    sha256 "a428e25fb7691024de47fecfbff7ff957214da51eddded0da0ae0e0f03a2cf79"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/64/d7/520b62a35b23038ff005e334dba3ffc75fcf583bee26723f1fd8fd4b6919/google_resumable_media-2.8.0.tar.gz"
    sha256 "f1157ed8b46994d60a1bc432544db62352043113684d4e030ee02e77ebe9a1ae"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/05/6b/13dfa4e7e0551377b6ec234ab70f4e5d26779573a2b3bf41b3a8c86255a4/grpc-google-iam-v1-0.12.7.tar.gz"
    sha256 "009197a7f1eaaa22149c96e5e054ac5934ba7241974e92663d8d3528a21203d1"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/0b/bb/d89b2f8ed062af360e872746cab9d5a98acf80f9fec537536203695cce63/grpcio-1.78.0rc2.tar.gz"
    sha256 "d624592c82a19a5898c5576fbda43c28d7062bac04ea6f33bbd8871bc0639e64"
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
    url "https://files.pythonhosted.org/packages/77/df/6eb1d485a513776bbdbb1c919b72e59b5acc51c5e7ef28ad1cd444e252a3/httplib2-0.31.1.tar.gz"
    sha256 "21591655ac54953624c6ab8d587c71675e379e31e2cfe3147c83c11e9ef41f92"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f3/49/3b30cad09e7771a4982d9975a8cbf64f00d4a1ececb53297f1d9a7be1b10/importlib_metadata-8.7.1.tar.gz"
    sha256 "49fef1ae6440c182052f407c8d34a68f72efc36db9ca90dc0113398f2fdde8bb"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jaraco-collections" do
    url "https://files.pythonhosted.org/packages/fa/d2/751000cf702676dbb78f97728f4d52b029e817e2b3c94088dfe5c70ff46d/jaraco_collections-5.2.1.tar.gz"
    sha256 "dab81970bad6f0ab53b20745f1b01da37926e4c0fcd425046aa45e0d8efa18ed"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/cb/9c/a788f5bb29c61e456b8ee52ce76dbdd32fd72cd73dd67bc95f42c7a8d13c/jaraco_context-6.1.0.tar.gz"
    sha256 "129a341b0a85a7db7879e22acd66902fda67882db771754574338898b2d5d86f"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
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
    url "https://files.pythonhosted.org/packages/2c/8f/85bf51ad4150f64e8c665daf0d9dfe9787ae92005efb9a4d1cba592bd79d/kubernetes-35.0.0.tar.gz"
    sha256 "3d00d344944239821458b9efd484d6df9f011da367ecb155dadf9513f05f09ee"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/cf/0e/c857c46d653e104019a84f22d4494f2119b4fe9f896c92b4b864b3b045cc/msal-1.34.0.tar.gz"
    sha256 "76ba83b716ea5a6d75b0279c0ac353a0e05b820ca1f6682c0eb7f45190c43c2f"
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
    url "https://files.pythonhosted.org/packages/7a/20/7cab8a81f81fa1c185e5fa659fc12066a894393bd05920c2523142ba58a3/oci-2.165.0.tar.gz"
    sha256 "c04586994bad57b3d929ba3f0e640dcd80c7122a074e4fe54f2b4886e2b27529"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/97/b9/3161be15bb8e3ad01be8be5a968a9237c3027c5be504362ff800fca3e442/opentelemetry_api-1.39.1.tar.gz"
    sha256 "fbde8c80e1b937a2c61f20347e91c0c18a1940cecf012d62e65a7caf08967c9c"
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
    url "https://files.pythonhosted.org/packages/01/89/9cbe2f4bba860e149108b683bc2efec21f14d5f7ed6e25562ad86acbc373/proto_plus-1.27.0.tar.gz"
    sha256 "873af56dd0d7e91836aee871e5799e1c6f1bda86ac9a983e0bb9f0c266a568c4"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/fe/b6/6e630dff89739fcd427e3f72b3d905ce0acb85a45d4ec3e2678718a3487f/pyasn1-0.6.2.tar.gz"
    sha256 "9b59a2b25ba7e4f8197db7686c09fb33e658b98339fadb826e9512629017833b"
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
    url "https://files.pythonhosted.org/packages/86/7e/365f6fea7d67e0d4ce8329559723ba900ecc37bab7b65aa2aba88ae8ab12/pydo-0.24.0.tar.gz"
    sha256 "67fb4b1e30e882f5b55e3e2de96720c162228ba0890498c2c3672fa872b80c2f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/33/c1/1d9de9aeaa1b89b0186e5fe23294ff6517fce1bc69149185577cd31016b2/pyparsing-3.3.1.tar.gz"
    sha256 "47fad0f17ac1e2cad3de3b458570fbc9b03560aa029ed5e16ee5554da9a2251c"
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
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
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
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
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
    url "https://files.pythonhosted.org/packages/24/64/a255efe5edd367d12b770b3514194efdc1c97e5ed6ce6e8105d834750dfc/tempora-5.8.1.tar.gz"
    sha256 "abb5d9ec790cc5e4f9431778029ba3e3d9ba9bd50cb306dad824824b2b362dcd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/10/9a/2fef89272d98b799e4daa50201c5582ec76bdd4e92a1a7e3deb74c52b7fa/zc_lockfile-4.0.tar.gz"
    sha256 "d3ab0f53974296a806db3219b9191ba0e6d5cbbd1daa2e0d17208cb9b29d2102"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  # Fix to support Python 3.14
  # PR ref: https://github.com/nccgroup/ScoutSuite/pull/1718
  patch do
    url "https://github.com/nccgroup/ScoutSuite/commit/e1ae94ea0ccb5fafd27645baff5570fd0bac4030.patch?full_index=1"
    sha256 "8bae83f393c06c5927567504d5d4d9c361e48b6115154f583be187f022e65ed9"
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
