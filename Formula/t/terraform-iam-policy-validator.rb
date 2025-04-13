class TerraformIamPolicyValidator < Formula
  include Language::Python::Virtualenv

  desc "CLI to validate AWS IAM policies in Terraform templates for best practices"
  homepage "https://github.com/awslabs/terraform-iam-policy-validator"
  url "https://files.pythonhosted.org/packages/13/7b/4fba4bbee1931df373f456a34994a1f089059ac13bac5ade29e1ae143956/tf_policy_validator-0.0.8.tar.gz"
  sha256 "f43359ee0478f10e7b27a3fb7282c284304615cc6f06fd5aa3aa631edbe4811a"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "579fbf421d2560b9ad43d93f3549e559c099f3811ff09fc62b2ea1637855a0b6"
    sha256 cellar: :any,                 arm64_sonoma:  "947eca6f3676c6544d596b46c713ba5316c510a2f6b325fdd7d9d0b0bc1b8e13"
    sha256 cellar: :any,                 arm64_ventura: "b89e2714f23a60a4ddf0fe2719c93a31264a8ecb528549418a978b44a658c8ff"
    sha256 cellar: :any,                 sonoma:        "4d1256d5c37bf22b127cefc065b33a6a5fbfd46da050044f04ce17b9e23d8b4d"
    sha256 cellar: :any,                 ventura:       "a3653d4fd8972af3496ebecf50946dca9a12e5e09b208254a4968e4b612565c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e3eee71e3cd93033925ca8532fd942cb1f3da394e08013d6feb1618319a4b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f630df08d4441513159d5853e5a8eda4d964b436cd5cc3a636ebd64baae400b"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d6/50/1183ffa4782408907891af344a8e91d7bc5d7a9bae12e43fca8874da567e/boto3-1.37.13.tar.gz"
    sha256 "295648f887464ab74c5c301a44982df76f9ba39ebfc16be5b8f071ad1a81fe95"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/18/53/3593b438ab1f9b6837cc90a8582dfa71c71c639e9359a01fd4d110f0566e/botocore-1.37.13.tar.gz"
    sha256 "60dfb831c54eb466db9b91891a6c8a0c223626caa049969d5d42858ad1e7f8c7"
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
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/0f/ec/aa1a215e5c126fe5decbee2e107468f51d9ce190b9763cb649f76bb45938/s3transfer-0.11.4.tar.gz"
    sha256 "559f161658e1cf0a911f45940552c696735f5c74e64362e515f333ebed87d679"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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
