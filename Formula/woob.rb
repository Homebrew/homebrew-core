class Woob < Formula
  include Language::Python::Virtualenv

  desc "Web Outside of Browsers"
  homepage "https://woob.tech/"
  url "https://files.pythonhosted.org/packages/70/f2/f443eb3c270a469cefe235eb776062c8adf548604e35cc984193d87bd0ce/woob-3.0.tar.gz"
  sha256 "47864df4906b44a659abe59630c0e28a1aa24ffbc3c90e22454b58f88bef1726"
  license "LGPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://gitlab.com/woob/woob.git"
    regex(/^v?(\d+(?:\.(?:\d+|[a-z])+))$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b1702dae9e91a2c30e157b9b4137541aeba1adf19b052dc3d3131b2216c4eb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d67399835223851033c47e9b74847577f82f630e2edf4bb1689b906dc00a4f75"
    sha256 cellar: :any_skip_relocation, monterey:       "9adec0751e1ae933bc51bd7c033362ccf54d19e7bdfdd55a4c989356b8ba6c90"
    sha256 cellar: :any_skip_relocation, big_sur:        "5281e5cc8b93f424a6b219ad04336d307624c2c6029d9170188932f6c9b7b7a3"
    sha256 cellar: :any_skip_relocation, catalina:       "e77e6797e1e869fea58a75cbc9454a1e8b2e1e15fb87b4bd9e8f30aa203a4db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78113582225c04d4920534118633bffc7d3cd50d1978f677823f631019ea5db5"
  end

  depends_on "gnupg"
  depends_on "pillow"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/51/27/81e9cf804a34a550a47cc2f0f57fe4935281d479ae3a0ac093d69476f221/Babel-2.10.3.tar.gz"
    sha256 "7614553711ee97490f732126dc077f8d0ae084ebc6a96e23db1482afabdb2c51"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/6c/f9/033a17d8ea8181aee41f20c74c3b20f1ccbefbbc3f7cd24e3692de99fb25/html2text-2020.1.16.tar.gz"
    sha256 "e296318e16b059ddb97f7a8a1d6a5c1d7af4544049a01e261731d2d5cc277bbb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/41/16/ee78864c2c2ba9bddba3978baa378f83270c8b7810eb7900f84e62a9ffac/Unidecode-1.3.4.tar.gz"
    sha256 "8e4352fb93d5a735c788110d2e7ac8e8031eb06ccbfe8d324ab71735015f9342"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
  end

  def python3
    "python3.10"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-woob.pth").write pth_contents
  end

  test do
    system bin/"woob", "config", "modules"
    system Formula["python@3.10"].opt_bin/python3, "-c", "import woob"
  end
end
