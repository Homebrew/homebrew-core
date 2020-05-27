class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://github.com/flosell/trailscraper/archive/0.5.1.tar.gz"
  sha256 "6793353bef9cf17379d556e7811d225ee852c6c2e975deb7219d684be7b12c5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d86bcf1d9bbb2b3f32c2fd096f79ad92e417ed2defc7b4c3606842ed3dae3fc2" => :catalina
    sha256 "5bcf661b1dc5be7ba1d3a75f48cf6cbcc23f9130a85918111a3e3b42bcec960e" => :mojave
    sha256 "dcf453b4faf51fbd81fdc73ad354a119fc4089291b604c02aedd9f29ae1d5248" => :high_sierra
  end

  depends_on "python@3.8"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ee/b9/482d396fdbfab0e83f4c5f11b46a74b01a3ccdfdd84d54dd069083670b52/boto3-1.13.11.tar.gz"
    sha256 "a7c5c7251b76336e697ccf368f125720e1947d58b218c228b61b5b654187fe4e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ec/ce/12ad4123cc3dc0284408ad6dead2f0490ec38998a3b01a357e04106b655c/botocore-1.16.11.tar.gz"
    sha256 "b82083f1ba65624017d53fa2d2a44aa801ea3da0948fba56ccf4d29a88ef0b71"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/89/03/e8890489fe1c458f155e88f92cfc4d399894ff38721629fda925c3793b66/dateparser-0.6.0.tar.gz"
    sha256 "f8c24317120b06f71691d28076764ec084a132be2a250a78fdf54f6b427cac95"
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
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
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
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
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
