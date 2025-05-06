class Sceptre < Formula
  include Language::Python::Virtualenv

  desc "Build better AWS infrastructure"
  homepage "https://docs.sceptre-project.org/"
  url "https://files.pythonhosted.org/packages/32/0b/e3249a42ab6cab8cf9e2c5261a95740daa0b74edf1aaecf5c17293e67784/sceptre-4.5.3.tar.gz"
  sha256 "84ebc52b59e980b5d25926bbe7116edfbe428dd34ef47014e7f3b200136dc7a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cec0aac8aa2e27a01417df11fde831d8f4a4c2085cf4f78355271fe53dfd986c"
    sha256 cellar: :any,                 arm64_sonoma:  "6b7411723b6c0d0cd5b725d0151a61b27b2e03272049f30a8039d453231f75a3"
    sha256 cellar: :any,                 arm64_ventura: "98aebe51e4714e56d21a2c07e1f52700e60c22bc85b71eb961b99ba142bb9ef7"
    sha256 cellar: :any,                 sonoma:        "979884d2a5cd1df91768da33c39b99961cffbfe27cc18d459aa8dde5d20e3262"
    sha256 cellar: :any,                 ventura:       "49675d31adedb4e98227befbbd1cc73d24cac05ac607e168a460e8e287e0498b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1741cf554fa1e9020d1036b98b2acb632515ffbd82f31ed0cb0ae427ce63925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91a4257f912f371a33d0ba02d8c1d410e2f54d259ec82ac2befb76af5ec70d4"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/65/81/fcaf72cf86c4b3f1a4efa3500e08c97d2a98966a35760acfaed79100c6a0/boto3-1.37.23.tar.gz"
    sha256 "82f4599a34f5eb66e916b9ac8547394f6e5899c19580e74b60237db04cf66d1e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0e/34/9becaddf187353e1449a3bfa08ee7b069398f51e3d600cffdb0a63789e34/botocore-1.37.23.tar.gz"
    sha256 "3a249c950cef9ee9ed7b2278500ad83a4ad6456bc433a43abd1864d1b61b2acb"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "deepdiff" do
    url "https://files.pythonhosted.org/packages/7f/2f/232a9f6d88a59526347cb483ec601d878ad41ab30ee4f2fba4aca1d5a10e/deepdiff-8.4.2.tar.gz"
    sha256 "5c741c0867ebc7fcb83950ad5ed958369c17f424e14dee32a11c56073f4ee92a"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "orderly-set" do
    url "https://files.pythonhosted.org/packages/e7/0e/ef328b512c2595831304e51f25e9287697b7bf13be0527ca9592a2659c16/orderly_set-5.3.0.tar.gz"
    sha256 "80b3d8fdd3d39004d9aad389eaa0eab02c71f0a0511ba3a6d54a935a6c6a0acc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/ce/3a/5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95ca/pyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/0f/ec/aa1a215e5c126fe5decbee2e107468f51d9ce190b9763cb649f76bb45938/s3transfer-0.11.4.tar.gz"
    sha256 "559f161658e1cf0a911f45940552c696735f5c74e64362e515f333ebed87d679"
  end

  resource "sceptre-cmd-resolver" do
    url "https://files.pythonhosted.org/packages/65/80/acb986323af0b3e5e3eb59bb293e6671cdc43ded91620a24a1a58b2e28f7/sceptre-cmd-resolver-2.0.0.tar.gz"
    sha256 "155c47e2f4f55c7b6eb64bfe8760174701442ecaddba1a6f5cb7715a1c95be99"
  end

  resource "sceptre-file-resolver" do
    url "https://files.pythonhosted.org/packages/36/20/c8162b958668c741bef1d7d247a78f796b705ed0eec72501ef308110923b/sceptre-file-resolver-1.0.6.tar.gz"
    sha256 "d47cfe32d141fb46467fcd319bf4386f0178cf0c2211c6f1d2dffbc80d785a6d"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
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
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    # Avoid issue if `numpy` is installed, https://github.com/Sceptre/sceptre/issues/1541
    virtualenv_install_with_resources(system_site_packages: false)

    generate_completions_from_executable(bin/"sceptre", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    system bin/"sceptre", "--help"
  end
end
