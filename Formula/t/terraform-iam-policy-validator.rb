class TerraformIamPolicyValidator < Formula
  include Language::Python::Virtualenv

  desc "CLI to validate AWS IAM policies in Terraform templates for best practices"
  homepage "https://github.com/awslabs/terraform-iam-policy-validator"
  url "https://files.pythonhosted.org/packages/89/6b/bdb90f2fcb4a0033f138d52d5b24af9a2f8a84703ef94cbc31d51f0afaed/tf_policy_validator-0.0.9.tar.gz"
  sha256 "ec8496bb8d45642a61f36dba95c867ac8ca5438bfc5bebafe8e3eec03a50d181"
  license "MIT-0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0dd0550290c327df46e97ec879a63d04c632107e4ce2a87f7aa2b549b8f8d8c5"
    sha256 cellar: :any,                 arm64_sequoia: "8c34011a2385b9d46775b722071f2f070fdae6f0508967f501e31d7ca03a3d3d"
    sha256 cellar: :any,                 arm64_sonoma:  "83bd301802bce5b64783a8175386dbb639c799fd73326f6eae79051d5033cd42"
    sha256 cellar: :any,                 sonoma:        "58c49adba68848ecf839f79d312ee8e7534c57b9f4f38c2748633add9be29ae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a65691acb8eef199f0caba0e76f1914bdd2cff6d8a47269d1a0add317903c3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe92d2f99352427a9957b1734dbe103fa9c3eb43cf2d33294aaba7cba5ddef5"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ba/41/d4d73f55b367899ee377cd77c228748c18698ea3507c2a95b328f9152017/boto3-1.40.50.tar.gz"
    sha256 "ae34363e8f34a49ab130d10c507a611926c1101d5d14d70be5598ca308e13266"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/5b/66/21d9ac0d37e5c4e55171466351cfc77404d8d664ccc17d4add6dba1dee99/botocore-1.40.50.tar.gz"
    sha256 "1d3d5b5759c9cb30202cd5ad231ec8afb1abe5be0c088a1707195c2cbae0e742"
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
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
