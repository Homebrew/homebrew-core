class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/06/8a/61237cd8b95d41f2e997fee78f1a05fd3f5e65845cfe7aae9362a9d28022/terraform_local-0.24.1.tar.gz"
  sha256 "2cfaeb283a1753083f3f59be1a2e08d225286913633694d695b04bba9913ae91"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02003d3379322362954e861be100d4a7a6739c57a9fea59d367aa703fd1cd7eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18800188bee9dc2358e6216a1caae2ab4830ca148579485e6be7b1568a18a386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d63ec41c396ee5ee40ed6d3c6b57b1af040aa8f0b5e1daafc44b7fbbb251582"
    sha256 cellar: :any_skip_relocation, sonoma:        "805d1ee675ff6223d939eb35bfa08deed14d71fff27cffcf05e3cabc71eb2e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "911ea3b2dcd209aa620aff35b2d5744edf0c68eac7407b5b7f0acb31d446434f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b8631e5c95a7741c03479efbc1daf2fed887328e0971476e9795cb37be8dd5d"
  end

  depends_on "localstack"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ba/41/d4d73f55b367899ee377cd77c228748c18698ea3507c2a95b328f9152017/boto3-1.40.50.tar.gz"
    sha256 "ae34363e8f34a49ab130d10c507a611926c1101d5d14d70be5598ca308e13266"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/5b/66/21d9ac0d37e5c4e55171466351cfc77404d8d664ccc17d4add6dba1dee99/botocore-1.40.50.tar.gz"
    sha256 "1d3d5b5759c9cb30202cd5ad231ec8afb1abe5be0c088a1707195c2cbae0e742"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/1d/37/a13baf0135f348af608c667633cbe5d13aa2c5c15a56ae9ad3e6cba45ae3/lark-1.3.0.tar.gz"
    sha256 "9a3839d0ca5e1faf7cfa3460e420e859b66bcbde05b634e73c369c8244c5fa48"
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
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
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
