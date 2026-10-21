class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/b9/f7/7d128b483dfd03d178c37eedc8c9329d7ee0abc4781bcfe5a0069ee63d79/terraform_local-0.26.0.tar.gz"
  sha256 "958abac78c40b15fca6edcd833a9706a28e1cc861cb713e3fed5def345d518b8"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b16bf0c646b86194c21f3abbcfe66f1275527dcb00b4cdfdada567164ee46014"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9531fe80b4a63c2b0f3ffd4ca22eb25aa69bbe40d54bde84071983ce2fea3d90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0661ada350ffe37a175eeb885a90159fe764ddd37be829c500fb0527bcc2e87a"
    sha256 cellar: :any,                 arm64_linux:       "e46b18ce0884baeca63b0f356b398c38ce36bfa694bd2fa18ab2644ba458d74d"
    sha256 cellar: :any,                 x86_64_linux:      "8bb96b5f08b54042e6b27f83263fea186f03c2cddb4b1090e2a5c47b2d4981be"
  end

  depends_on "python@3.15"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/59/d3/fa092ae1c109100d0c5c14c69a316cd6d53c05fb57183fa77b1fcdef86ce/boto3-1.43.111.tar.gz"
    sha256 "5ae342a16c848909cd42d4be404f69d9082e5705460198d4d3327eca5f6cddcb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6c/43/257e97270ddd6833fd54b11e544a09b441b02f8c731bdeb29b90479be565/botocore-1.43.111.tar.gz"
    sha256 "44d5e80962ac6cb9e85af72667b77c9586451e3328ab0ce33195380767e213d8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/88/99/f0cb24bd7687765f37ce6a577736a4a13501054be66eb748ddd4a13e6592/localstack_client-2.12.tar.gz"
    sha256 "dbb98712fd2c8869d5dfed7a2ca006b95c7750fe9a43af123ef054efc7e7ebb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/ff/3b/a66df999c382abf2d37f6c7b618a782958615acd41a53615f994dfd6611b/python_hcl2-8.1.4.tar.gz"
    sha256 "b4145c930540e99e3e9b4f7de297775bdf856df29782a7abdb0916cbfcab7865"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
