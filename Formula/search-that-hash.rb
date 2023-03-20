class SearchThatHash < Formula
  include Language::Python::Virtualenv

  desc "Searches Hash APIs to crack your hash quickly"
  homepage "https://github.com/HashPals/Search-That-Hash"
  url "https://files.pythonhosted.org/packages/5e/b9/a304a92ba77a9e18b3023b66634e71cded5285cef7e3b56d3c1874e9d84e/search-that-hash-0.2.8.tar.gz"
  sha256 "384498abbb9a611aa173b20d06b135e013674670fecc01b34d456bfe536e0bca"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/HashPals/Search-That-Hash.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeb4252db092451d3c62757b4f0ee7f4b563d5fd597a551f6df7777cadda0352"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a8c63b71de650fec44c6d6b318b4ea49ec1a0e5d791f365be65a7a6ec877988"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ecac31304fbced8ec4a3a4f223275b23a98bc5ad4dd9f5a8231611f48970ed9"
    sha256 cellar: :any_skip_relocation, ventura:        "b2497fe78bc6ba7455d0ad13a0ce5bfa4300a0cdad97f375239925200c5cf808"
    sha256 cellar: :any_skip_relocation, monterey:       "4dc2479126748675b022b11b58ec1afbd2ef2d89e3f8963f57ac43f896e6d77f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b677959c7f463d1e5b4c9e65fa55ad25a74a3472b1fc35a0e67e9c3cfb36dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1a05a8de843e1e0316c1c3ad05e74702fd3cda2036b40bfce54ab035bf688b"
  end

  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cloudscraper" do
    url "https://files.pythonhosted.org/packages/09/ba/71b989352ceee1fbbc1bbfc658ac677a506b4bbfdc0f527b6f81435cf3fa/cloudscraper-1.2.68.tar.gz"
    sha256 "4d02aceffa90abd4dabc75b79bafa31636309baa7c0f2ee665e2d345aadb8863"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/6d/25/0d65383fc7b4f4ce9505d16773b2b2a9f0f465ef00ab337d66afff47594a/loguru-0.5.3.tar.gz"
    sha256 "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319"
  end

  resource "name-that-hash" do
    url "https://files.pythonhosted.org/packages/32/58/1f4052bd4999c5aceb51c813cc8ef32838561c8fb18f90cf4b86df6bd818/name-that-hash-1.10.0.tar.gz"
    sha256 "aabe1a3e23f5f8ca1ef6522eb1adcd5c69b5fed3961371ed84a22fc86ee648a2"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/0c/4c/07f01c6ac44f7784fa399137fbc8d0cdc1b5d35304e8c0f278ad82105b58/requests-toolbelt-0.10.1.tar.gz"
    sha256 "62e09f7ff5ccbda92772a29f394a49c3ad6cb181d568b1337626b2abb628a63d"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ae/f6/6ffb46f6cf0bb584e44279accd3321cb838b78b324031feb8fd9adf63ed2/rich-9.13.0.tar.gz"
    sha256 "d59e94a0e3e686f0d268fe5c7060baa1bd6744abca71b45351f5850a3aaa6764"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def python3
    "python3.11"
  end

  def install
    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when merged/released: https://github.com/HashPals/Search-That-Hash/pull/184
    inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
    inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'

    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-search_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/sth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "Text : password\nType : MD5\n", output

    system python3, "-c", "from search_that_hash import api"
  end
end
