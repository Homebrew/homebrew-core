class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/48/30/3ca48aa0615960bc891c976512df7cca1ecf72535446f4bbe9b1ac110ebf/terraform_local-0.25.0.tar.gz"
  sha256 "8730cfc92dcdbfcb10293420cafb22566d56a2af58139e8a976828b10e07c7e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e4fb5fe6d4c96bf4393a009f5a2c3f79a7681ef6f1c1db48c8c5014dd08fcde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42e4b1fa38cdf7ddb26d107fd85e7421e4456142b611efa755e35233c67660e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32b13c73c04ed8e39d532f48d5a602c735cad99d05541809c487aaeb13fbde0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b1bd9685fe2757e1aecbf01ac75270d1fba8b3d672fe69cc60b033572bbfcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96060f2ac3e682a833b73f56b2a564e8c08987c3b23e905cdaeea0c510cff21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06dd9a6a188550eaa14c07fc521fac4d8daf5786a8b8a546402f5be879814333"
  end

  depends_on "localstack"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f0/9b/eef5346ce3148bf4856318fe629e0fd7f6dd73ffd55ea08e316c967f8af0/boto3-1.42.0.tar.gz"
    sha256 "9c67729a6112b7dced521ea70b0369fba138e89852b029a7876041cd1460c084"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/03/04/8e8ca38631eeb499a1099dcc2a081faaea399f9d46080720540ff54ec609/botocore-1.41.6.tar.gz"
    sha256 "08fe47e9b306f4436f5eaf6a02cb6d55c7745d13d2d093ce5d917d3ef3d3df75"
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
    url "https://files.pythonhosted.org/packages/22/11/4f10b87d634edd616d8063dd0ed1193be747e524e28801f826d72828b98f/localstack_client-2.10.tar.gz"
    sha256 "732a07e23fffd6a581af2714bbe006ad6f884ac4f8ac955211a8a63321cdc409"
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
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
