class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/88/80/099853d1614341cbde71938ddd86cf9ded44abf518a384e05d8f0407002c/terraform_local-0.19.0.tar.gz"
  sha256 "d04d7579a121cf5a703fd30156296a8a88fdd9f64fef08cb25c4789e8efd9fdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41e26ee47afa97c3562607262063110ba5327a59355e941f578ea0e4f6b2cb16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41e26ee47afa97c3562607262063110ba5327a59355e941f578ea0e4f6b2cb16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41e26ee47afa97c3562607262063110ba5327a59355e941f578ea0e4f6b2cb16"
    sha256 cellar: :any_skip_relocation, sonoma:         "41e26ee47afa97c3562607262063110ba5327a59355e941f578ea0e4f6b2cb16"
    sha256 cellar: :any_skip_relocation, ventura:        "41e26ee47afa97c3562607262063110ba5327a59355e941f578ea0e4f6b2cb16"
    sha256 cellar: :any_skip_relocation, monterey:       "41e26ee47afa97c3562607262063110ba5327a59355e941f578ea0e4f6b2cb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd715a2505846f42553046d5fd8efd25d2ca9bed56917d3348000d557efa573d"
  end

  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/54/4d/ab9ef9ebda797bf162cc489756682044e293a23153eb2339aa7c7faf0ae5/boto3-1.34.157.tar.gz"
    sha256 "7ef19ed38cba9863b58430fb4a66a72a5c250304f234bd1c16b860f9bf25677b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ae/d9/e04875f81b82d20ccfaa9fe7db4f794187561eb5c1c4946e999ba1590dd2/botocore-1.34.157.tar.gz"
    sha256 "5628a36cec123cdc8c1158d05a7b06aa5e53649ad73796c50ef3fb51199785fb"
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
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/17/b8/6d82f3ac6b14493e524df946365670235570a2074cb2621ea67caa4e8952/python-hcl2-4.3.5.tar.gz"
    sha256 "71fbe48ee9a13335828f04adff2b267e06045c44c99c737b13d940aa1468d101"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/cb/67/94c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fab/s3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
