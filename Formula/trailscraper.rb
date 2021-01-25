class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/ee/5f/67657d646b3a6fdd9059f72cf9f13cb9ed677d92c881bc83b67179c20178/trailscraper-0.6.4.tar.gz"
  sha256 "3e076fc97addddfd8b64ea51a6cc9e2af9d9bffcc68423772ff6cb7b63a009d6"
  license "Apache-2.0"
  revision 1
  head "https://github.com/flosell/trailscraper.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "5fd16ca0386356df5caf782b3f25a33447f1887e654f612587ff2bef17b716a0" => :big_sur
    sha256 "8ebb97f86a9ef08e5fbd763ac922910e457c9ee3691a15cd280284a89a543c8f" => :arm64_big_sur
    sha256 "50ff3c4f3d6c4b832530230b75b16dcb01e871abac30dd732e655b2850356d8a" => :catalina
    sha256 "4ee380a299a7c96115c1cf9f89812d16243853fc2f02e9f84c2ab69fd6e89b90" => :mojave
  end

  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2b/56/09a936e798a8b6b8ba1006f14b438dc1ec5791d7780e46a5a0749c7fc198/boto3-1.14.14.tar.gz"
    sha256 "87beffba2360b8077413f2d473cb828d0a5bda513bd1d6fb7b137c57b686aeb6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/98/89/388651fcd98d8b9be63c44e356e28c24f742259cea507c13f501e623a4fc/botocore-1.17.20.tar.gz"
    sha256 "d1bf8c2085719221683edf54913c6155c68705f26ab4a72c45e4de5176a8cf7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/86/6e/9a47cf3841bcfd1dd07a20b2aca42d4e02822ea7121aeb022869855b8d2f/dateparser-0.7.6.tar.gz"
    sha256 "e875efd8c57c85c2d02b238239878db59ff1971f5a823457fcc69e493bf6ebfa"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b8/7b/01510a6229c2176425bda54d15fba05a4b3df169b87265b008480261d2f9/regex-2020.6.8.tar.gz"
    sha256 "e9b64e609d37438f7d6e68c2546d2cb8062f3adb27e6336bc129b51be20773ac"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/16/8b/54a26c1031595e5edd0e616028b922d78d8ffba8bc775f0a4faeada846cc/ruamel.yaml-0.16.10.tar.gz"
    sha256 "099c644a778bf72ffa00524f78dd0b6476bca94a1da344130f4bf3381ce5b954"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/92/28/612085de3fae9f82d62d80255d9f4cf05b1b341db1e180adcf28c1bf748d/ruamel.yaml.clib-0.2.0.tar.gz"
    sha256 "b66832ea8077d9b3f6e311c4a53d06273db5dc2db6e8a908550f3c14d67e718c"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/22/8e/037b9ba5c6a5739ef0dcde60578c64d49f45f64c5e5e886531bfbc39157f/toolz-0.10.0.tar.gz"
    sha256 "08fdd5ef7c96480ad11c12d472de21acd32359996f69a5259299b540feba4560"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ce/73/99e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710/tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trailscraper --version")

    test_input = '{"Records": []}'
    output = shell_output("echo '#{test_input}' | trailscraper generate")
    assert_match "Statement", output
  end
end
