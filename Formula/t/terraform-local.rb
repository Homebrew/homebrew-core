class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/50/64/3b861b38e6b3a88f8ed176390bbb804cd790a48dde86cd8468112e48f713/terraform_local-0.27.0.tar.gz"
  sha256 "0f6786aa1205ed07a23427b96b89cb9bac73859a495528d7ff0327400569bf4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e692e7ed37b7c1ae633a751b853418f08c670c09d68e5e4b16d4a0b3f60ec7ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed349d431dcee4282f2f1007922e8a8319c658b0d42bd9e64930ad5c88bb8a13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c70bfb54cc26212ce74a4c3e9264fd3f926750b089cdb6eff205f3b9f0e3768d"
    sha256 cellar: :any,                 arm64_linux:       "439a1d475678354f3edbb6c1c23f5d259cc9c3ccfeb74f7e3dda08194bde7252"
    sha256 cellar: :any,                 x86_64_linux:      "0c8267b48adb48a5a7de76c24efc61a7b14bbfd168decffbd80a1e3d9c993a10"
  end

  depends_on "python@3.15"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/cc/20/de5848b0166d8cb6b6e597b299ca10a64ebba3cf9aaab228de1e817ae85e/boto3-1.43.116.tar.gz"
    sha256 "89fa15e7d1788fb17cbd694b034beba57f43f30f58f4506913a5b62220f8ba01"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/98/aff05e8a35f5bb9f6648c6056ecff02a2bd4540ad70a89215db8a0cae758/botocore-1.43.116.tar.gz"
    sha256 "00b1fbfc1c024b56633538385628a1bbc7ab15aca0b5b53e5fe188841d96c8ce"
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
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
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
