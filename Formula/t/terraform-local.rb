class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/83/0c/98a28e341fae1fbef63d136fdbb2da11ca47bcdb5f086aa670c67ba253f8/terraform-local-0.16.1.tar.gz"
  sha256 "943c823186164bacfc1857d413b784c7bff3f02f33c6c0d58cf679109101897e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7b2db4d52a38ad39e322e1b7bceb62dce4f92d41856c97833c8cb31f189ddb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa108ef5ebc42c2061e48a07048265beffa3f76d90b9b3a3750f4add34e65752"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ddc7d9c22ee0aa143ea026a86b8da2709509b7b1e46ffdb67065cd38946b2cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "70da163302d60c9bd89ca14af1d0b46845e4c97c47dce3f12d7280bcd59bd3c6"
    sha256 cellar: :any_skip_relocation, ventura:        "e426a74f619051ebc50304d090c52b59cbeba0806473e801c8aff732b88f6809"
    sha256 cellar: :any_skip_relocation, monterey:       "001f2fa251019745bb5fcfef39da584785c20b69099dc64f20577d223e509d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3c41d5cba4b2db64ed71a4835657fd6173a5a84603a183abb2406fdb8129df"
  end

  depends_on "localstack"
  depends_on "python-dateutil"
  depends_on "python@3.12"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e5/86/3c386c17fcd9edbd612b1bbeaee85eaa21dd8d85c347de097aba30fc8cb6/boto3-1.33.12.tar.gz"
    sha256 "2225edaea2fa17274f62707c12d9f7803c998af7089fe8a1ec8e4f1ebf47677e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ef/dc/b4b0b8b6ccdcf5880f7381a197397fbc6121e562fd2411e97fc4b4052997/botocore-1.33.12.tar.gz"
    sha256 "067c94fa88583c04ae897d48a11d2be09f280363b8e794b82d78d631d3a3e910"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/12/1c/b466b58dacac15ffefce9bcb5128e18948a143849610a7d5300f31920be0/lark-1.1.8.tar.gz"
    sha256 "7ef424db57f59c1ffd6f0d4c2b705119927f566b68c0fe1942dddcc0e44391a5"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/ce/f6/7c19f1249cdcdc946616387e8aa93472f879624eb6acdd31a78a76fc046f/localstack-client-2.5.tar.gz"
    sha256 "8b8b2ee6013265a55d3e312a4513efccd222131bed79395545a4f643704f9213"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/ef/94/cc6f7100a857a5a4a676c2c71322ca476051278fad4ec956f0116c1d3834/python-hcl2-4.3.2.tar.gz"
    sha256 "7122661438be27ccd8b8f3db71969d8ef2cce3b3cf183e88f8172575e7405a65"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5f/cc/7e3b8305e22d7dcb383d4e1a30126cfac3d54aea2bbd2dfd147e2eff4988/s3transfer-0.8.2.tar.gz"
    sha256 "368ac6876a9e9ed91f6bc86581e319be08188dc60d50e0d56308ed5765446283"
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
