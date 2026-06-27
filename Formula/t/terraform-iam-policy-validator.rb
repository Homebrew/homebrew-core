class TerraformIamPolicyValidator < Formula
  include Language::Python::Virtualenv

  desc "CLI to validate AWS IAM policies in Terraform templates for best practices"
  homepage "https://github.com/awslabs/terraform-iam-policy-validator"
  url "https://files.pythonhosted.org/packages/89/6b/bdb90f2fcb4a0033f138d52d5b24af9a2f8a84703ef94cbc31d51f0afaed/tf_policy_validator-0.0.9.tar.gz"
  sha256 "ec8496bb8d45642a61f36dba95c867ac8ca5438bfc5bebafe8e3eec03a50d181"
  license "MIT-0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62449af6bd22ea7d43b6820262c11afb51ddd8b8f826b502cf4f84d95effaa2a"
    sha256 cellar: :any,                 arm64_sequoia: "7ef62ab83c16591ac02f58866550dec722f530d953d5b3bea3e070a10ce56db6"
    sha256 cellar: :any,                 arm64_sonoma:  "a81c03f1b63397e75ef789d9ed21bfb2959790ef5ae0b160d2137e1fe68748f9"
    sha256 cellar: :any,                 sonoma:        "3039e2e1be18634f909e4dfd4eca9dd2dc0cc2da8242fc207fa7f34fd2da2a0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eceaf7ac55818e671ef5d83f1062e98217c5a857d38035afbe9b4739bcbdb66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87bb790a566c8ed17e31efe5f67a38cbe8a0f5a43e9395a61a6fb3145629b64"
  end

  depends_on "libyaml"
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

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
    (testpath/"default.yaml").write <<~YAML
      settings:
        example_key: example_value
    YAML

    (testpath/"tf.json").write <<~JSON
      {
        "format_version": "1.0",
        "terraform_version": "1.0.0",
        "planned_values": {
          "root_module": {
            "resources": [
              {
                "address": "aws_iam_policy.example",
                "mode": "managed",
                "type": "aws_iam_policy",
                "name": "example",
                "provider_name": "registry.terraform.io/hashicorp/aws",
                "values": {
                  "policy": "{\\"Version\\":\\"2012-10-17\\",\\"Statement\\":[{\\"Effect\\":\\"Allow\\",\\"Action\\":[\\"s3:GetObject\\"],\\"Resource\\":\\"arn:aws:s3:::mybucket/*\\"}]}"
                }
              }
            ]
          }
        }
      }
    JSON

    output = shell_output("#{bin}/tf-policy-validator validate " \
                          "--config default.yaml --template-path tf.json --region us-east-1 2>&1", 1)
    assert_match "No IAM policies defined", output
  end
end
