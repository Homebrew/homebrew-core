class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/b9/f7/7d128b483dfd03d178c37eedc8c9329d7ee0abc4781bcfe5a0069ee63d79/terraform_local-0.26.0.tar.gz"
  sha256 "958abac78c40b15fca6edcd833a9706a28e1cc861cb713e3fed5def345d518b8"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb8d6db692b18c316c966f34b7c80ad24de3056a43780fa6898687f441df73db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02778532f8ea2b1a02ed50e9db687a918732dc64c733bebccf56dc32bd63e59f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b6c307e8fc64aef6176fd4aae7ed774b220811995888253410dd904e24cff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb767bc121627819be3234142f60896cd6008482dcb88e148eb83a9fac319e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c1233b5e7fbf8a626b83af0d6cba97a6d35c01e9ca7faf8d311f958ddd39324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8274b97b61a86976e22b00bf1a5799e1728e117f330892d46b03a640f283953"
  end

  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6b/0d/67ebf496fe061397f7eb907504e950fe6d2fa5945fd05891f3033376e471/boto3-1.43.7.tar.gz"
    sha256 "b1e4b40f4a828c67291b12ebefd17d87a57321101e4a0c969b2f593a0310f343"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ed/be/59144884fa71908e2ac389cfe0fd2ebe8e8adb47bcc994188eb59967406a/botocore-1.43.7.tar.gz"
    sha256 "abbbc623c52dce86ea9d4534d35e2d6ce447d98edfdaced1695ee0278d6063e3"
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
    url "https://files.pythonhosted.org/packages/44/79/d240524248f0e675982c52586d67ea5030cf7511af9dbc8814e1d100cd15/localstack_client-2.11.tar.gz"
    sha256 "1cbd7bf1f03b9b553ffe7ea10fe137f44e8d690a37af9c6515eba61a2379fc46"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/39/7b/6c9c973484a482f833a1b88ab69e078e05cc1f761af1839d5cbe7e7fad92/python_hcl2-8.1.2.tar.gz"
    sha256 "ae809c7e6e39e8c3c3555e7b7f389082207929591fcba062c9f76afb1abe972d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9b/ec/7c692cde9125b77e84b307354d4fb705f98b8ccad59a036d5957ca75bfc3/s3transfer-0.17.0.tar.gz"
    sha256 "9edeb6d1c3c2f89d6050348548834ad8289610d886e5bf7b7207728bd43ce33a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
