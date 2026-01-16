class TerraformIamPolicyValidator < Formula
  include Language::Python::Virtualenv

  desc "CLI to validate AWS IAM policies in Terraform templates for best practices"
  homepage "https://github.com/awslabs/terraform-iam-policy-validator"
  url "https://files.pythonhosted.org/packages/89/6b/bdb90f2fcb4a0033f138d52d5b24af9a2f8a84703ef94cbc31d51f0afaed/tf_policy_validator-0.0.9.tar.gz"
  sha256 "ec8496bb8d45642a61f36dba95c867ac8ca5438bfc5bebafe8e3eec03a50d181"
  license "MIT-0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa92c957894d7bb18c16f94805a161224543dca85c62435ad8d1eb67b40d134b"
    sha256 cellar: :any,                 arm64_sequoia: "b43c6889783593be47ab5fe5918e44fefae1fd0d9e44747bed466b1cd6eaefd1"
    sha256 cellar: :any,                 arm64_sonoma:  "79175ca1928cf881712fcc690abd96dfaf19b5ce3a00c7c9b7f6a529b65665f9"
    sha256 cellar: :any,                 sonoma:        "8f41ec6727f2c24b9b5da9152c50a1def43f34d8bd3646f689880c19db402274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b80c51ff935222abb97911171d961f8172742875edea329979bcab1328be643f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b848d3c6acfb9af196ea920911cf0abb09ff24f2539db72b07aa3374b70c04"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/29/30/755a6c4b27ad4effefa9e407f84c6f0a69f75a21c0090beb25022dfcfd3f/boto3-1.42.25.tar.gz"
    sha256 "ccb5e757dd62698d25766cc54cf5c47bea43287efa59c93cf1df8c8fbc26eeda"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2c/b5/8f961c65898deb5417c9e9e908ea6c4d2fe8bb52ff04e552f679c88ed2ce/botocore-1.42.25.tar.gz"
    sha256 "7ae79d1f77d3771e83e4dd46bce43166a1ba85d58a49cffe4c4a721418616054"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
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
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

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
