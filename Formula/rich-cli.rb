class RichCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line toolbox for fancy output in the terminal"
  homepage "https://github.com/textualize/rich-cli"
  url "https://files.pythonhosted.org/packages/ca/55/e35962573948a148a4f63416d95d25fe75feb06d9ae2f9bb35adc416f894/rich-cli-1.8.0.tar.gz"
  sha256 "7f99ed213fb18c25999b644335f74d2be621a3a68593359e7fc62e95fe7e9a8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b465f63ac1d33ef28d6d243e74ceb2358fafd9f72d339579d371ac5a2a3e9b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "025a0c9159d7cf2c749497aa89d23814e6bda69c02847365d292fb4e71b85794"
    sha256 cellar: :any_skip_relocation, monterey:       "4bd977ba300da45a0d46e3085eaa9682cd495bac6ea64246ac32d915a519c42d"
    sha256 cellar: :any_skip_relocation, big_sur:        "91853de56f8a3155837c616adf814a9c6f723a7f79626e08b3862972eeed6bc7"
    sha256 cellar: :any_skip_relocation, catalina:       "3d92f8b9e163431d99a714619fb7725053609c28663f267b112d5a81f67e49aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f64aa766c298f4953ead63f9f7ad93bebe6f0891f6099b00636ff184dfaf17c0"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/72/4d/1f48abaa1e91474af1be8622ec2a8bd3768b306def47b064aa15aa943f95/rich-12.4.1.tar.gz"
    sha256 "d239001c0fb7de985e21ec9a4bb542b5150350330bbc1849f835b9cbc8923b91"
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
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/rich foo.md").strip
  end
end
