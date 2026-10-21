class TerraformIamPolicyValidator < Formula
  include Language::Python::Virtualenv

  desc "CLI to validate AWS IAM policies in Terraform templates for best practices"
  homepage "https://github.com/awslabs/terraform-iam-policy-validator"
  url "https://files.pythonhosted.org/packages/89/6b/bdb90f2fcb4a0033f138d52d5b24af9a2f8a84703ef94cbc31d51f0afaed/tf_policy_validator-0.0.9.tar.gz"
  sha256 "ec8496bb8d45642a61f36dba95c867ac8ca5438bfc5bebafe8e3eec03a50d181"
  license "MIT-0"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e41a310f421352797217d34a7f29352471048b81f6836a481b1860fcf390228e"
    sha256 cellar: :any, arm64_tahoe:       "76aa7de48ebf9e99fdb368851b781ae83ad8933798c2a499f763a34fb12b67a7"
    sha256 cellar: :any, arm64_sequoia:     "904451df294b4f03394e722099a9ae21dc54da74ea39df81f896155b978b43cf"
    sha256 cellar: :any, arm64_linux:       "89c0f8d728034bad0c74ca9e582482153871dcecee886bb8a1af017147fbfc00"
    sha256 cellar: :any, x86_64_linux:      "ec855cab9223fbd9c4a7d381997308505e128f61959a3c93123c1a03a1dfd0ad"
  end

  depends_on "libyaml"
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

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
