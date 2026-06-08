class Scoutsuite < Formula
  include Language::Python::Virtualenv

  desc "Open source multi-cloud security-auditing tool"
  homepage "https://github.com/nccgroup/ScoutSuite"
  url "https://files.pythonhosted.org/packages/a9/41/4f375fac81c66e1475c3ae18753a86191f253cdf24c29f28c8861d6bb984/scoutsuite-5.14.0.tar.gz"
  sha256 "b021ad340196865093fb5d6e247f2596ec856e24cb39eb6e3e886923befd1208"
  license "GPL-2.0-only"
  revision 13
  head "https://github.com/nccgroup/ScoutSuite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5cc0bbf582786ce9fccf0afc3f823a8097b719414e269a661a71ab2a9bc26b6c"
    sha256 cellar: :any, arm64_sequoia: "3193221f405c32442448a95fa3cb07b0ef88c4d5d6fc11aca28e826e2ed42441"
    sha256 cellar: :any, arm64_sonoma:  "e4a490979555da9745a890c8a4542fd9a26659d1c36bb65df6eb5938b07d76be"
    sha256 cellar: :any, sonoma:        "e0585233c4ab8db1c067df71a89d48d12cf8b74b0db9e4848e6e36895f675c0f"
    sha256 cellar: :any, arm64_linux:   "3c3cd6eee8bd5f3d0ce65008d8fb4654fb0569c23a5b732013c171a2ca3ef74f"
    sha256 cellar: :any, x86_64_linux:  "f61ad6d6d1359cea984b01de8c27bd155b1ae024b722d9c76ba7787d80c24072"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/33/c6/61a2d7b7572279226bb2e7f61d7a19ca7c90da0329c93fa0d560cbf288d8/aiohappyeyeballs-2.6.2.tar.gz"
    sha256 "e202810ee718bd01fc6ef49e8ea53d023d5cb6b581076d7925aa499fa55dbe64"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ee/ab/93ce242f899b68c51b0578c027aafa791ab3614cb9345fa5d37b5f5c8e3e/aiohttp-3.14.0.tar.gz"
    sha256 "2882de819734c715fd1b9c11c97e09fa020d14438203d1d354d8ed1702791c9b"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

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
    url "https://files.pythonhosted.org/packages/16/17/f24706df5024db2aa7707596b43504a1ea88e043bcf5350392c034e4e136/aliyun_python_sdk_vpc-3.0.48-py2.py3-none-any.whl"
    sha256 "b3915d281bb75e6b1a23f081426721fa902eb606f5820dc2f9a71cfa710c46e1"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "asyncio-throttle" do
    url "https://files.pythonhosted.org/packages/c2/b4/0b6bd59151d979c3d9902d9b35c992aa1e55ab0f60d8b0b7fbbf61dd3138/asyncio_throttle-0.1.1-py3-none-any.whl"
    sha256 "a01a56f3671e961253cf262918f3e0741e222fc50d57d981ba5c801f284eccfe"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
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
    url "https://files.pythonhosted.org/packages/97/da/229987ebb70daf5928f959aa8f4dd77dfcf425e6b0e7ff03aaef61ccc333/boto3-1.43.19.tar.gz"
    sha256 "8b84704719dd3960ac12a8f37d9ff5adb853715baa9742f84fdbe2de0305c4cb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e2/a7/298986789785b74a954e2347114993be7e6b070417159125a6865f2687b6/botocore-1.43.19.tar.gz"
    sha256 "18ac2fdd76c89b940707eb10493ff58678adad337d03215caec2d408ccd43cc0"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
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

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/9d/a4/e44218c2b394e31a6dd0d6b095c4e1f32d0be54c2a4b250032d717647bab/durationpy-0.10.tar.gz"
    sha256 "1fa6893409a6e739c9c72334fc65cca1f355dbdd93405d30f726deb5bde42fba"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c8/b0/7c8d4a03960da803a4c471545fd7b3404d2819f1585ba3f3d97e887aa91d/google-api-core-1.34.1.tar.gz"
    sha256 "3399c92887a97d33038baa4bfd3bf07acc05d474b0171f333e1f641c1364e552"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/22/09/081d66357118bd260f8f182cb1b2dd5bd32ca88e3714d7c93896cab946fc/google_api_python_client-2.197.0.tar.gz"
    sha256 "32e03977eda4a66eafc6ae58dc9ec46426b6025636d5ef019c5703013eddd4e5"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/c6/ad/ff781329bbbdc0974a098d996e89c9e1f7024262f9e3eec442fbb9ad1ac6/google_auth-2.53.0.tar.gz"
    sha256 "e7e6aa16f6bee7b2b264830fd04f08087a1d5a836df516251a5d15327b246c9c"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/1c/b3/f192c8bc7e41e0ebdbd95afcae4783417a34b6a6af62d22daf22c3fd38fc/google_auth_httplib2-0.4.0.tar.gz"
    sha256 "d5b030a204b7a4b4d553ba9ca701b62481ee2b74419325580be70f7d85ffed35"
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
    url "https://files.pythonhosted.org/packages/d8/1c/56a191ced537a1f8bc45aeee76658f4d651ef4cc8e6f0d3f321cb8f66fa6/google_cloud_container-2.63.0.tar.gz"
    sha256 "6d634073cfd01623639b6b2e5b9b9cc34ae2075121bf88c136e440bb6a3a2f87"
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
    url "https://files.pythonhosted.org/packages/9d/ce/0d3539008dc33b436e7c5c644abc8f8a7ec5900911d14a8e34e145f0ebe5/google_cloud_logging-3.14.0.tar.gz"
    sha256 "361e83cd692fecc7da10351f641c474591f586f234fc49394db4ba5c8c5994a7"
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
    url "https://files.pythonhosted.org/packages/00/4b/0b235beccc310d0a48adbc7246b719d173cca6c88c572dfa4b090e39143c/google_resumable_media-2.9.0.tar.gz"
    sha256 "f7cfb224846a9dd444d125115dfbe8ef02a2b893e78f087762fe716a255a734b"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/99/96/a0205167fa0154f4a542fd6925bdc63d039d88dab3588b875078107e6f06/googleapis_common_protos-1.73.0.tar.gz"
    sha256 "778d07cd4fbeff84c6f7c72102f0daf98fa2bfd3fa8bea426edc545588da0b5a"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/05/6b/13dfa4e7e0551377b6ec234ab70f4e5d26779573a2b3bf41b3a8c86255a4/grpc-google-iam-v1-0.12.7.tar.gz"
    sha256 "009197a7f1eaaa22149c96e5e054ac5934ba7241974e92663d8d3528a21203d1"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/15/f3/23f47b24f8d8c2028eba501db3acfbb2f592cbb5995eaa6e363a627b74d7/grpcio-1.81.0.tar.gz"
    sha256 "a5acd7efd3b1fe9b4eb0bcaaa1507eed68a0ad0678b654c3f7b464df9ba9dca5"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/62/5e/7b4c5c6e0adeeb981f1e7e1a39da3d75ff8f45bc24a74171f5eb1557d2e7/grpcio-status-1.49.0rc1.tar.gz"
    sha256 "9a9253d863dba4c573a1734055c5f63fe5b9fc49feff55099fe79866ae64c877"
  end

  resource "httpagentparser" do
    url "https://files.pythonhosted.org/packages/f8/44/028b51ff3a2a5c67af2ea929ead36f2d90e9efda1932ff4e45a36aae58eb/httpagentparser-1.9.9.tar.gz"
    sha256 "23bcaf09325b17af7634283ca64da23f485c5d83b9481ff6d88413a7c5bc6de9"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c1/1f/e86365613582c027dda5ddb64e1010e57a3d53e99ab8a72093fa13d565ec/httplib2-0.31.2.tar.gz"
    sha256 "385e0869d7397484f4eab426197a4c020b606edd43372492337c0b4010ae5d24"
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
    url "https://files.pythonhosted.org/packages/b9/28/99c51f664567218d824af024c0251650fb27e4ca066df188dab0769c5b91/idna-3.17.tar.gz"
    sha256 "5eb0cb53bc467c12eadcf6de83163ad8527cec9416f44b9b61b19caedad2b87f"
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
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/36/cf/ea4ef2920830dea3f5ab2ea4da6fb67724e6dca80ee2553788c3607243d0/jaraco_functools-4.5.0.tar.gz"
    sha256 "3bb5665ea4a020cf78a7040e89154c77edadb3ca74f366479669c5999aa70b03"
  end

  resource "jaraco-text" do
    url "https://files.pythonhosted.org/packages/f2/20/f071dfb40f06fd0395167a40218c10adb7164635f65ebdafe45e0c714935/jaraco_text-4.2.0.tar.gz"
    sha256 "194e386aa5b15a6616019df87a6b29c00fd3c9c8b0475731b64633ca7afd495b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/2f/57/8b538af5076bc3372949d76f70ba3449bdfe52f9e6488170fa5d4f7cbe70/kubernetes-36.0.2.tar.gz"
    sha256 "03551fcb49cae1f708f63624041e37403545b7aaed10cbf54e2b01a37a5438e3"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/9a/99/d840198ecf6e8057bbc937f129ae940404485d736cda73253bbff9537f01/msal-1.37.0.tar.gz"
    sha256 "1b1672a33ee467c1d70b341bb16cafd51bb3c817147a95b93263794b03971bec"
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

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
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
    url "https://files.pythonhosted.org/packages/96/eb/f4e9a840c2c703bf78f1ca8506514bb1195792715dcf52fbb92cab4a6cec/oci-2.177.0.tar.gz"
    sha256 "941c15283677ec5ca65d82a4bc71bae28692d73e79abbaf5eccb305a0ddb1251"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/b4/1c/125e1c936c0873796771b7f04f6c93b9f1bf5d424cea90fda94a99f61da8/opentelemetry_api-1.42.1.tar.gz"
    sha256 "56c63bea9f77b62856be8c47600474acad853b2924b99b1687c4cb6297166716"
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

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/3a/02/8832cde80e7380c600fbf55090b6ab7b62bd6825dbedde6d6657c15a1f8e/proto_plus-1.27.1.tar.gz"
    sha256 "912a7460446625b792f6448bade9e55cd4e41e6ac10e27009ef71a7f317fa147"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"

    # Fix for the usage of pkg_resources, removed in setuptools 82. Drop when protobuf >= 4.22.
    patch :DATA
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
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
    url "https://files.pythonhosted.org/packages/4a/dc/6d5c162cfdacce6406b7c7cf36ac3cb8574852ebb4aaaa95888e0ab04f91/pydo-0.34.0.tar.gz"
    sha256 "21788f218b53af2af722c5d9e54ecc382b149aa4cc590c33245abcc6c7a0e41b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/1a/51/27a5ad5f939d08f690a326ef9582cda7140555180db71695f6fb747d6a36/pyopenssl-26.2.0.tar.gz"
    sha256 "8c6fcecd1183a7fc897548dfe388b0cdb7f37e018200d8409cf33959dbe35387"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e0/1f/12417f7f493fc45e1f9fd5d4a9b6c125cf8d2cf3f8ddbdfab3e76406e9d6/s3transfer-0.18.0.tar.gz"
    sha256 "3760b8b7ec1315da54048b2d626276732bee4300d054d492d4e1d43e20d4ecbd"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
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
    url "https://files.pythonhosted.org/packages/5a/e8/20e489ba55092e0d737dc54a5c43424a7762d38f59efce54ed86f4fc51bc/tempora-5.9.0.tar.gz"
    sha256 "66e6ddee320c38f4b253a7d8039337424c699916451b9271e0ccce770a4e8f62"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/eb/1a/2cf40b65b1d9c254fe5814bb0519f9b8f2ac38059df0810f9b866300c04a/typer-0.26.5.tar.gz"
    sha256 "9b9b39e35c3afc9e1e51a06f21155246e457c0911279b09b35d8210ca74b935c"
  end

  resource "typer-slim" do
    url "https://files.pythonhosted.org/packages/a7/a7/e6aecc4b4eb59598829a3b5076a93aff291b4fdaa2ded25efc4e1f4d219c/typer_slim-0.24.0.tar.gz"
    sha256 "f0ed36127183f52ae6ced2ecb2521789995992c521a46083bfcdbb652d22ad34"
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
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/10/9a/2fef89272d98b799e4daa50201c5582ec76bdd4e92a1a7e3deb74c52b7fa/zc_lockfile-4.0.tar.gz"
    sha256 "d3ab0f53974296a806db3219b9191ba0e6d5cbbd1daa2e0d17208cb9b29d2102"
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

__END__
--- a/setup.py
+++ b/setup.py
@@ -8,7 +8,6 @@
 import fnmatch
 import glob
 import os
-import pkg_resources
 import re
 import subprocess
 import sys
@@ -267,8 +266,8 @@
     # deployment target of macOS 10.9 or later, or iOS 7 or later.
     if sys.platform == 'darwin':
       mac_target = str(sysconfig.get_config_var('MACOSX_DEPLOYMENT_TARGET'))
-      if mac_target and (pkg_resources.parse_version(mac_target) <
-                         pkg_resources.parse_version('10.9.0')):
+      mac_target_parts = [int(x) for x in re.findall(r'\d+', mac_target)]
+      if mac_target_parts and mac_target_parts < [10, 9]:
         os.environ['MACOSX_DEPLOYMENT_TARGET'] = '10.9'
         os.environ['_PYTHON_HOST_PLATFORM'] = re.sub(
             r'macosx-[0-9]+\.[0-9]+-(.+)', r'macosx-10.9-\1',
