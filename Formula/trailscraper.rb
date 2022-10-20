class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/f4/89/392581eaa901f2690f5d9b0c9589f41ad03606371f16bedd9680a12413aa/trailscraper-0.7.0.tar.gz"
  sha256 "8aade831f331d5f3b3780478473c4dbe45dc2018026df0112624cd37bbdc3605"
  license "Apache-2.0"
  revision 1
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0c3ce26fe776eda07802c2353823111f850e9288b1db5e395f74eead8b2f2ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99f410b365bfee3c011acfa4a10d653a36ad0da7ea26ec93284fa68d4b31a58e"
    sha256 cellar: :any_skip_relocation, monterey:       "c352da73c7f486f73127135bb26cd48384cf738a928c5f3cf5a08da6e29be6c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce1e82edd535e305b5aa6f3cf1d3a955cc7bddfd18ba111b359e000e5de25371"
    sha256 cellar: :any_skip_relocation, catalina:       "ea5a55b56b736464322c2a79beb7ca984e23ea09a37a173157baee29a0862322"
    sha256 cellar: :any_skip_relocation, mojave:         "d5bb6b61cbc99d8bedbe34aeab424928867c8679e2ee78fb541dbb01df615749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb3097f50c45c726158cf047dcad9582c06f8f41fb82277839311e0dbdb8bba"
  end

  depends_on "python@3.10"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c5/d6/af0c15b601e38bff38d975a231d8c4401d29e1385bf1ebb65b97cefa91e1/boto3-1.17.62.tar.gz"
    sha256 "d856a71d74351649ca8dd59ad17c8c3e79ea57734ff4a38a97611e1e10b06863"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4d/c8/2d47e502c12d4b436e5b865cc78552604888aee59570c12b1863bb09c11b/botocore-1.20.112.tar.gz"
    sha256 "d0b9b70b6eb5b65bb7162da2aaf04b6b086b15cc7ea322ddc3ef2f5e07944dcf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/a9/f3/09df53068a630a69c95ae0fe8e4fae597bcfbd5f25abb30ab94dc02a7cb2/dateparser-1.0.0.tar.gz"
    sha256 "159cc4e01a593706a15cd4e269a0b3345edf3aef8bf9278a57dac8adf5bf1e4a"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4c/69/acbf9b28cc1b699ef8d5152c40e0fc130d120ef13187f0fd54dd4afb7770/regex-2021.9.30.tar.gz"
    sha256 "81e125d9ba54c34579e4539a967e976a3c56150796674aec318b1b2f49251be7"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/fd/6b/b83bdc8fb9aad62f6469117874e7c11b64d94ba9e8557f73ca1f28c2df7d/ruamel.yaml-0.17.7.tar.gz"
    sha256 "5c3fa739bbedd2f23769656784e671c6335d17a5bf163c3c3901d8663c0af287"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/d6/0d/fdad31347bf3d058002993a094da1ca95f0f3ef9beec08856d0fe4ad9766/toolz-0.11.1.tar.gz"
    sha256 "c7a47921f07822fe534fb1c01c9931ab335a4390c782bd28c6bcc7c2f71f3fbf"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/89/e7/5fc01b31d9df0b914d5bbbea6f5d80ff76c6b5cf11bf23a8beca8407a0f1/tzlocal-3.0.tar.gz"
    sha256 "f4e6e36db50499e0d92f79b67361041f048e2609d166e93456b50746dc4aef12"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trailscraper --version")

    test_input = '{"Records": []}'
    output = pipe_output("#{bin}/trailscraper generate", test_input)
    assert_match "Statement", output
  end
end
