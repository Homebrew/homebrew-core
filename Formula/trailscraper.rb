class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/bc/9b/f425ff02c84a16e434526d3ffe7abfc50589f46a5efe9b02cfd09bec698e/trailscraper-0.8.1.tar.gz"
  sha256 "fe0f7970554a7100be6a4dc6ecce0ce0f4a5a3337a689e7035df7ac3c37ec21a"
  license "Apache-2.0"
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9e66ebb373a566bd0ba72e945245a6c4ab05236b509cf7170e8aa65bbb7fee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a98eb9f9bcd1605ed0a50e5129e50e52a27ae2003b4045f1adab0e6e91d47ce8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea1caa6f8c28b1f272fe6ce234f74625f71174998b4f5671d11d3964cd26d52f"
    sha256 cellar: :any_skip_relocation, ventura:        "5bb42af07983d50f5c8d5bab7b1b0f9602365221c6d16f8cff518a3ad6d94129"
    sha256 cellar: :any_skip_relocation, monterey:       "4969c624af360265353808133fb25715e012d6b4c9e957903caba4972c6e8ac0"
    sha256 cellar: :any_skip_relocation, big_sur:        "849b319c01e99fdc14bffd06b3610a4d053c5885b523303fe925e58055c86dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ab1666ebdbfdc0d6bce107d6f774f26a232f31a713524aa643264fb7ca0474"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/95/60/88c7932476b438fc4702daa0dc6f5663c8c1451898d3d7daa0f934468086/boto3-1.26.54.tar.gz"
    sha256 "4e876ba5d64928cde0c416dd844f04f22d6b73d14002bbc3ca55591f80f49927"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/42/7fa8a5090a7381cfdea10f3bad3fea3c867e248caca1f8ee2e6722568db0/botocore-1.29.59.tar.gz"
    sha256 "bc75d41c5eecf624a2f9875483135aa78088a50c8d29847793f92756697cfed5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/bb/2d/2f5dc79f80623f0f7ec4ee5291512caffda18f3ea070cb2775cc7839733f/dateparser-1.1.6.tar.gz"
    sha256 "e703db1815270c020552f4b3e3a981937b48b2cbcfcef5347071b74788dd9214"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/cf/05/2008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84/toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5b/30/b7abfb11be6642d26de1c1840d25e8d90333513350ad0ebc03101d55e13b/tzdata-2022.7.tar.gz"
    sha256 "fe5f866eddd8b96e9fcba978f8e503c909b19ea7efda11e52e39494bad3a7bfa"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/7d/b9/164d5f510e0547ae92280d0ca4a90407a15625901afbb9f57a19d9acd9eb/tzlocal-4.2.tar.gz"
    sha256 "ee5842fa3a795f023514ac2d801c4a81d1743bbe642e3940143326b3a00addd7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trailscraper --version")

    test_input = '{"Records": []}'
    output = pipe_output("#{bin}/trailscraper generate", test_input)
    assert_match "Statement", output
  end
end
