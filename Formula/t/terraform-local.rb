class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/48/30/3ca48aa0615960bc891c976512df7cca1ecf72535446f4bbe9b1ac110ebf/terraform_local-0.25.0.tar.gz"
  sha256 "8730cfc92dcdbfcb10293420cafb22566d56a2af58139e8a976828b10e07c7e2"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7769f93ae62ca92910ef74f677fac98177afa1ae13ccfab7bf17b8e0f6902ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c03964a59358decef8c9ee58b926f00639c301a7858164e9c64a2348a632cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013ccf77eac65fa641c456e6fa88ec890b078273e4def36dc02ce616ab6e4aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4948a1fae033c666952dfa09f984a0ee5314158136da64d1e51f154ccdc479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e71ac39baa41b11fcfb11454020ad8cea46f6f2ef9f73045108ae6528914666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05032bd60ac470f02aea4d768c57d94ceb890db6e6d5960f326aaadbc9c6d123"
  end

  depends_on "localstack"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/29/30/755a6c4b27ad4effefa9e407f84c6f0a69f75a21c0090beb25022dfcfd3f/boto3-1.42.25.tar.gz"
    sha256 "ccb5e757dd62698d25766cc54cf5c47bea43287efa59c93cf1df8c8fbc26eeda"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2c/b5/8f961c65898deb5417c9e9e908ea6c4d2fe8bb52ff04e552f679c88ed2ce/botocore-1.42.25.tar.gz"
    sha256 "7ae79d1f77d3771e83e4dd46bce43166a1ba85d58a49cffe4c4a721418616054"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/44/79/d240524248f0e675982c52586d67ea5030cf7511af9dbc8814e1d100cd15/localstack_client-2.11.tar.gz"
    sha256 "1cbd7bf1f03b9b553ffe7ea10fe137f44e8d690a37af9c6515eba61a2379fc46"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/50/8e/f82ed407a10c2dd4228ff0fceec8a16dd6a9191a2ed119233c04dccf2ca4/python_hcl2-7.3.1.tar.gz"
    sha256 "f8f55583703daf7bbcb595a33c68de891064d565974ea39998b81d15a4c4657b"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
