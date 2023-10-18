class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https://github.com/bloomreach/s4cmd"
  url "https://files.pythonhosted.org/packages/42/b4/0061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34/s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 2
  head "https://github.com/bloomreach/s4cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ee35d4a4d11c4297df0b6bf56ff1448616960db0a3f0afbd67291b66c353e65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0e2d3884cd5a992cd9423e76561be1e0de1fabaa724b7a7bfc2963fb6577b26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f5bdce73e592f7f2cab9b54e0d8b0b9540b4ebfb3419eee3ee5522c3ed8c2dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "8752f2baff2da9bcabc021c1d683ca543331ee3f0e01564c458e115b2cfaa026"
    sha256 cellar: :any_skip_relocation, ventura:        "dd08c43715a3175b6e4f4a16111cf13e86f8848a58fad720bed8e5887d5d058d"
    sha256 cellar: :any_skip_relocation, monterey:       "bf90beebe88af4bddecbdc0417c5f5d7ed19de6291717621b64f79081062ae47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251decd2246f8d66a5aca060fcd18300ba378993e8f1a59292e362f74ae500ca"
  end

  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/42/56/633b5f5b930732282e8dfb05c02a3d19394d41f4e60abfe85d26497e8036/boto3-1.28.61.tar.gz"
    sha256 "7a539aaf00eb45aea1ae857ef5d05e67def24fc07af4cb36c202fa45f8f30590"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/2e/9cb8adca433af2bb6240514448b35fa797c881975ea752242294d6e0b79f/botocore-1.31.61.tar.gz"
    sha256 "39b059603f0e92a26599eecc7fe9b141f13eb412c964786ca3a7df5375928c87"
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
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}/s4cmd ls s3://brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/s4cmd --version")
  end
end
