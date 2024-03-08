class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/dd/8b/5b0f5d5f37fe3a70de98dc391d55294049d82c22e90c5135d6444f812c84/terraform-local-0.18.0.tar.gz"
  sha256 "0b65ed3901417cacd586dbd2069e3f6c75479fca9c1fdd4f80591e129f18a696"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e95f47a1b881711a474b129c9eac626bc15ba9cbffb35b5a4e7aa41cf593e48d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e95f47a1b881711a474b129c9eac626bc15ba9cbffb35b5a4e7aa41cf593e48d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e95f47a1b881711a474b129c9eac626bc15ba9cbffb35b5a4e7aa41cf593e48d"
    sha256 cellar: :any_skip_relocation, sonoma:         "46b4dda62beb2711857ed1ba6da104b64da4925182df9a7353a96a283d21d465"
    sha256 cellar: :any_skip_relocation, ventura:        "46b4dda62beb2711857ed1ba6da104b64da4925182df9a7353a96a283d21d465"
    sha256 cellar: :any_skip_relocation, monterey:       "46b4dda62beb2711857ed1ba6da104b64da4925182df9a7353a96a283d21d465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02848ed0cadd6790bd8de342d17e8038a9c8f181869c337571b5a51e5bfeeb6"
  end

  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/42/77/59ba070269fb996144ce18b4a4bebcbacf7aeb32b7724b6d46124b730213/boto3-1.34.58.tar.gz"
    sha256 "09e3d17c718bc938a76774f31bc557b20733c0f5f9135a3e7782b55f3459cbdd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b3/e9/d965511c91f65ea3eddb9e0bf4dfe96dee9254bf4082f5511dad56f253de/botocore-1.34.58.tar.gz"
    sha256 "d75216952886dc513ea1b5e2979a6af08feed2f537e3fc102e4a0a2ead563a35"
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
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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
