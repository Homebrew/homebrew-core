class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/b8/71/8c4ff7fc4ccfa83861ad57f4cef487e6b9414dbdd60b40cf7ea3b7456791/terraform_local-0.20.1.tar.gz"
  sha256 "922ffd2a094099fce81e07fec11e8bb5e0501faf7aab9284fc58bfb5312a0888"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f04fd62c2a4ca76317600c7e24325f61b16c957ee7079db129f21992efd5e3e3"
  end

  depends_on "localstack"
  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e6/6e/afd7d74538a1684a3d5a5c2c7ca7c57f89ac6be3cae813e9466be135a25b/boto3-1.36.7.tar.gz"
    sha256 "ae98634efa7b47ced1b0d7342e2940b32639eee913f33ab406590b8ed55ee94b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e3/93/d9188c30f4c3c674cd3ee893efc23fab748e311231b4c376972453f77316/botocore-1.36.7.tar.gz"
    sha256 "9abc64bde5e7d8f814ea91d6fc0a8142511fc96427c19fe9209677c20a0c9e6e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/c4/40/6858a5fe70654ef4878188e0c330c8a22ce4dfc457e09231cb82228de075/localstack_client-2.7.tar.gz"
    sha256 "14993119901a4bcbef7c32d899b24f4a58a875a6765693edf1064d66b8a68408"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/5d/59/881b1644b748079c01d51b6c422cd625802c7690c34ff59660433295c88d/python-hcl2-6.1.0.tar.gz"
    sha256 "c06c0547e731dcb2453d68470a0f1e38869d6b5115a833e44c50d7083ce2423e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/45/2323b5928f86fd29f9afdcef4659f68fa73eaa5356912b774227f5cf46b5/s3transfer-0.11.2.tar.gz"
    sha256 "3b39185cb72f5acc77db1a58b6e25b977f28d20496b6e58d6813d75f464d632f"
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
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
