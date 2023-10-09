class Sceptre < Formula
  include Language::Python::Virtualenv

  desc "Build better AWS infrastructure"
  homepage "https://docs.sceptre-project.org/"
  url "https://files.pythonhosted.org/packages/05/cc/2ac3c8dd9323701b5ec61a58cc639a65cbada0ee539c837b4e78ccf54809/sceptre-4.2.2.tar.gz"
  sha256 "1fd5267854afc81ad1a315bbc82febb976ba6f490cb7f1e10f57f05030c7a04f"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e92cb0f2719d441e44d268227e65250b0b1bbb00d4acac45b1aee88d19da0b4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1473e5c567d023a1531eee705cf15c7324b44e7c53ea1ebda4aad006dae605a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd6b5b40eb12e155b1d952ffc69c932e3cd04174195779054d55f3b76ccfbd40"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef91af5b93081b035df8417debb663378e5537b9c614111b53c15e0f6cec812"
    sha256 cellar: :any_skip_relocation, ventura:        "8501751af00a525b905175b1541b87163ec5db776b53073178d540f8acb9ffd1"
    sha256 cellar: :any_skip_relocation, monterey:       "a4fad3ff1cd15d98cdce5620941f6a98d428616c3b5414018eb475378105a59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2699adddb3f65786a82e43a7516dcfe78b80ebaa9114cbf134b269ab45386a"
  end

  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/42/56/633b5f5b930732282e8dfb05c02a3d19394d41f4e60abfe85d26497e8036/boto3-1.28.61.tar.gz"
    sha256 "7a539aaf00eb45aea1ae857ef5d05e67def24fc07af4cb36c202fa45f8f30590"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/2e/9cb8adca433af2bb6240514448b35fa797c881975ea752242294d6e0b79f/botocore-1.31.61.tar.gz"
    sha256 "39b059603f0e92a26599eecc7fe9b141f13eb412c964786ca3a7df5375928c87"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "deepdiff" do
    url "https://files.pythonhosted.org/packages/0f/ca/caead2949fbb824c7142e3774fa841aa853bb4d4331b440da8c8514dfc6f/deepdiff-5.8.1.tar.gz"
    sha256 "8d4eb2c4e6cbc80b811266419cb71dd95a157094a3947ccf937a94d44943c7b8"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
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
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "sceptre-cmd-resolver" do
    url "https://files.pythonhosted.org/packages/65/80/acb986323af0b3e5e3eb59bb293e6671cdc43ded91620a24a1a58b2e28f7/sceptre-cmd-resolver-2.0.0.tar.gz"
    sha256 "155c47e2f4f55c7b6eb64bfe8760174701442ecaddba1a6f5cb7715a1c95be99"
  end

  resource "sceptre-file-resolver" do
    url "https://files.pythonhosted.org/packages/36/20/c8162b958668c741bef1d7d247a78f796b705ed0eec72501ef308110923b/sceptre-file-resolver-1.0.6.tar.gz"
    sha256 "d47cfe32d141fb46467fcd319bf4386f0178cf0c2211c6f1d2dffbc80d785a6d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sceptre", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    system bin/"sceptre", "--help"
  end
end
