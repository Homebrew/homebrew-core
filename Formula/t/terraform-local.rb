class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/7c/17/a88a3e54c7c35918be510139e04f051aacca1a51b9cad3b133b0dada9735/terraform-local-0.18.1.tar.gz"
  sha256 "771fe73edb37a1b4db53ad641cf4354ea6fe7ac7849eb6b47a69f33c9909df35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e13e30d6564e63e95aa2217ac96c5fd8b1c53c1e97995af0a1c4edf921ed455c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e13e30d6564e63e95aa2217ac96c5fd8b1c53c1e97995af0a1c4edf921ed455c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e13e30d6564e63e95aa2217ac96c5fd8b1c53c1e97995af0a1c4edf921ed455c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e13e30d6564e63e95aa2217ac96c5fd8b1c53c1e97995af0a1c4edf921ed455c"
    sha256 cellar: :any_skip_relocation, ventura:        "e13e30d6564e63e95aa2217ac96c5fd8b1c53c1e97995af0a1c4edf921ed455c"
    sha256 cellar: :any_skip_relocation, monterey:       "e13e30d6564e63e95aa2217ac96c5fd8b1c53c1e97995af0a1c4edf921ed455c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddc8701ef6645fe0f2baa98fd6c02c77597c7ac5e814e31b5c579cbab92b7077"
  end

  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/59/ac/01d0a0a231e9e11a4e2bfa86414e2d8acfd4755ecb1f3c5109dcb0906743/boto3-1.34.62.tar.gz"
    sha256 "7373e50b97e27f55c5b2a15a095e7bb45a7d962ced4d1468650dced57087c56b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/04/35/f0a45828aab5ac0056d948268c036857908512320510b66448821ae69e71/botocore-1.34.62.tar.gz"
    sha256 "7e97e7237c50d50850fef0d2cc6c8c42965d236a13abf18b29e5b8bb427514d7"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/2c/e1/804b6196b3fbdd0f8ba785fc62837b034782a891d6f663eea2f30ca23cfa/lark-1.1.9.tar.gz"
    sha256 "15fa5236490824c2c4aba0e22d2d6d823575dcaf4cdd1848e34b6ad836240fba"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/ce/f6/7c19f1249cdcdc946616387e8aa93472f879624eb6acdd31a78a76fc046f/localstack-client-2.5.tar.gz"
    sha256 "8b8b2ee6013265a55d3e312a4513efccd222131bed79395545a4f643704f9213"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/ef/94/cc6f7100a857a5a4a676c2c71322ca476051278fad4ec956f0116c1d3834/python-hcl2-4.3.2.tar.gz"
    sha256 "7122661438be27ccd8b8f3db71969d8ef2cce3b3cf183e88f8172575e7405a65"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
