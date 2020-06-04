class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://github.com/flosell/trailscraper/archive/0.6.1.tar.gz"
  sha256 "9ca2535d397282ffc09e5ca05af19bc36dd3da02235df963c3016b9f2dc4d151"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d91cab0673155227938faa11a4eb961bcd13c20ffc96b013ae7873c1a5a2435" => :catalina
    sha256 "19e452793c27d450ae9b010ae44bab6221e993e86c824883908fcda6007e0d90" => :mojave
    sha256 "df511d725019e58f9d3e6945fe4cac6c6b54a665028ca64c337fc461397720ff" => :high_sierra
  end

  depends_on "python@3.8"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/29/7f/5f76466f99177245e8fc405d6604b206ef85872817bed429a846d34d12d0/boto3-1.13.19.tar.gz"
    sha256 "c774003dc13d6de74b5e19d2b84d625da4456e64bd97f44baa1fcf40d808d29a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/94/23/dddd1e62449b0c3669632079ecb8fd4d8c3c628480b6619b57234f4aabe1/botocore-1.16.22.tar.gz"
    sha256 "eb077e2da1654558c9d97888a2e0710b92cc3162a6641959545451e1a21eea8a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/e2/da/c58ecd3b4183849b7373e6bbe140fdc0e0cc4640b960a1ddb5f550c2b283/dateparser-0.7.4.tar.gz"
    sha256 "fb5bfde4795fa4b179fe05c2c25b3981f785de26bec37e247dee1079c63d5689"
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
    url "https://files.pythonhosted.org/packages/14/8d/d44863d358e9dba3bdfb06099bbbeddbac8fb360773ba73250a849af4b01/regex-2020.5.14.tar.gz"
    sha256 "ce450ffbfec93821ab1fea94779a8440e10cf63819be6e176eb1973a6017aff5"
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
