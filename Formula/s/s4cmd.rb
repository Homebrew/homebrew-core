class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https://github.com/bloomreach/s4cmd"
  url "https://files.pythonhosted.org/packages/42/b4/0061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34/s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bloomreach/s4cmd.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4330aa16ed535e58baec539539457273ca137b7fd940381a5ece53b5ed264377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61b5e9c004791b55d9b448c58823c8e64766b8aae3f98b41d85c9225ea8d3a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc21a20e8b4e7fc2df9e5f8f4be01ef866cb9c5ea2b59ffbc9912baf8b1a9f0e"
    sha256 cellar: :any_skip_relocation, ventura:        "89921083aec7aecee35c209b8f9507a4ca2d7a1b2ea1d8a025c63221f0751700"
    sha256 cellar: :any_skip_relocation, monterey:       "02ba6c7b38706ba52e55eb92017eaab34ae59f9c5ae70742f5aeb6b015a8fb68"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e8c0d2faf3f76e97c7821d4c99b01d2751bc4d55bc9a2fb368b6dd15c2da4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ea903e1a7f0904623d53ed6f1b16dd33affcdd1c8c9a8db55f4b955b050f91"
  end

  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b8/0e/3a271954247f48ee2bc586aaa0d25467da722dff7059426311a3f9e81e93/boto3-1.26.3.tar.gz"
    sha256 "b81e4aa16891eac7532ce6cc9eb690a8d2e0ceea3bcf44b5c5a1309c2500d35f"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/61/d0/864d19810c779c8f2cc4e64030414c2056178863c6a61d2f831ab031cc35/botocore-1.29.3.tar.gz"
    sha256 "ac7986fefe1b9c6323d381c4fdee3845c67fa53eb6c9cf586a8e8a07270dbcfe"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}/s4cmd ls s3://brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/s4cmd --version")
  end
end
