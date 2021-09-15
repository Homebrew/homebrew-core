class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/f4/89/392581eaa901f2690f5d9b0c9589f41ad03606371f16bedd9680a12413aa/trailscraper-0.7.0.tar.gz"
  sha256 "8aade831f331d5f3b3780478473c4dbe45dc2018026df0112624cd37bbdc3605"
  license "Apache-2.0"
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46c7ffef4119889f37fd539e1393e2687f0de946b59f113c25c013974120dd9c"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcc8f34d8de268cf3388f01cc35238523e9b53fac436c45510b00cebc435ce0c"
    sha256 cellar: :any_skip_relocation, catalina:      "7e2f9f9e0a1a3e8937910ccd7ef1747d9281fad36a3448c426e99dcb1ff90ed6"
    sha256 cellar: :any_skip_relocation, mojave:        "2dca7531e0558cdd62843ba6aef85871dc43b4de932e5bb87c646e86e21fd7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "545c2ec464d3a4dcf2561dc3c817783fbd0dda810af641bcbe8cf7dd899744de"
  end

  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c5/d6/af0c15b601e38bff38d975a231d8c4401d29e1385bf1ebb65b97cefa91e1/boto3-1.17.62.tar.gz"
    sha256 "d856a71d74351649ca8dd59ad17c8c3e79ea57734ff4a38a97611e1e10b06863"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/cb/29/043bafa9c268b3fbcc12f25f1d9a7d963272e6ec386045c4425323002f80/botocore-1.20.93.tar.gz"
    sha256 "aae0f08627ef411a9579ae2a588a15f0859b2b40cecd5cde6055f0354712dd6f"
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
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/38/3f/4c42a98c9ad7d08c16e7d23b2194a0e4f3b2914662da8bc88986e4e6de1f/regex-2021.4.4.tar.gz"
    sha256 "52ba3d3f9b942c49d7e4bc105bb28551c44065f139a65062ab7912bef10c9afb"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/fd/6b/b83bdc8fb9aad62f6469117874e7c11b64d94ba9e8557f73ca1f28c2df7d/ruamel.yaml-0.17.7.tar.gz"
    sha256 "5c3fa739bbedd2f23769656784e671c6335d17a5bf163c3c3901d8663c0af287"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
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
    url "https://files.pythonhosted.org/packages/ce/73/99e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710/tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
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
