class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https://github.com/bloomreach/s4cmd"
  url "https://files.pythonhosted.org/packages/42/b4/0061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34/s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  head "https://github.com/bloomreach/s4cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f74b744af2e66f08ed24a849997fddf69f335833ae4e1491051ab2965f620677"
    sha256 cellar: :any_skip_relocation, big_sur:       "d53e697f8e5deb40ebb6bec040e02557cdc9789939fcd1bd202f6cac299aee62"
    sha256 cellar: :any_skip_relocation, catalina:      "f381fd7d18bf02b9310987a7c6bab7e856648328764ea339700be2c5ff740a8c"
    sha256 cellar: :any_skip_relocation, mojave:        "9bdd1cc24f552c01e5cdd0258cbfc64c7d585dcc3972efc345d127ea72a65e23"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/51/07/4a40d0188a51398138d4abff7b3c26da476b139a19f24299e71626d98091/boto3-1.17.101.tar.gz"
    sha256 "77ebaa3645ae153978a0f2c492502fef3804fe0e693abc7dc74620e4884afe67"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/73/37/27b163e4bb3da2356ba826481c573dddee19616a5f5871e9cade3b211378/botocore-1.20.101.tar.gz"
    sha256 "f7a44fab1a3739ca54e7f72e8625b71574f8218f05349e59d3b871c887444edd"
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

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}/s4cmd ls s3://brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/s4cmd --version")
  end
end
