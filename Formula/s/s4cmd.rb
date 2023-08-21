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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56fbd838e588d65381bbf8aed3502dc32f8ebfb72cc4853ee2ed31af2cc8a9ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579c89b3b9fa40c0ac1a426e55bd5b9a88f9f8e0560e08f89f5faccafa1d797c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bddd00a80e1ebe79b113c0f7f5d42158f438f5c4382dfe7c7a25eb24a453c65a"
    sha256 cellar: :any_skip_relocation, ventura:        "b5f8276bab65617391c6ec39c73481cd318c2b914beb729b29eea4343e89face"
    sha256 cellar: :any_skip_relocation, monterey:       "4fb07106e61b0d9317a091193d4a221053f24a5f02dc81e106c34710f749457e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bb2576ce8c56705a123814b30d90e20f0361fb763aadf6c141fef33b3b64b06"
    sha256 cellar: :any_skip_relocation, catalina:       "ff4ceeea473f6e83f1a9c59c16a056d6d6c1829bf3aad1770aeb82248f883ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82f269866cfadecf803bbf8901c120760a63efc5bd21bfe9d86073ea11370f43"
  end

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

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
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
