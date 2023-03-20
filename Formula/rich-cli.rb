class RichCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line toolbox for fancy output in the terminal"
  homepage "https://github.com/textualize/rich-cli"
  url "https://files.pythonhosted.org/packages/ca/55/e35962573948a148a4f63416d95d25fe75feb06d9ae2f9bb35adc416f894/rich-cli-1.8.0.tar.gz"
  sha256 "7f99ed213fb18c25999b644335f74d2be621a3a68593359e7fc62e95fe7e9a8a"
  license "MIT"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8efe42ee487a1c59dadbb711b2e597f3d633fdd752e4e3e233bc9f26cf1bbffc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8665bef292e2772c4ba77e62397c18b6d5f3e04f6593e033c60007f412fab19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "715091a0bb2c5eeaeca22420a46b3d4e65523e0ecf53d66b5e880740f330ccd5"
    sha256 cellar: :any_skip_relocation, ventura:        "36d97b0adf134ca2ee926b2ed98fd30fc6b4529a633b40301effb24d4a04c65c"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c03c0f7c1cbf6a11e173c5a836abc1a776d8f67ec75b295ac7a542ac380c9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b111127b175bf545b0c565e194d3ca1a4cf4943c017d64b316c853a7a9008a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5f7d24d25aabdb7e18d18cb36afb65a3131f74227d32dc713469ac073bf6fc"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/7c/40/9e9dded097de3100713a0258793b2ddf8dd33cdb51c71b7ce8577cc2db4b/rich-rst-1.1.7.tar.gz"
    sha256 "898bd5defd6bde9fba819614575dc5bff18047af38ae1981de0c1e78f17bbfd5"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/8c/d1/c228993e8a21e24bb43a0376b2901b6f3f2033dae13e7f76d1103bb9b8a3/textual-0.1.18.tar.gz"
    sha256 "b2883f8ed291de58b9aa73de6d24bbaae0174687487458a4eb2a7c188a2acf23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/rich foo.md").strip
  end
end
