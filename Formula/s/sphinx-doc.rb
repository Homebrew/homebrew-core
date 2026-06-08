class SphinxDoc < Formula
  include Language::Python::Virtualenv

  desc "Tool to create intelligent and beautiful documentation"
  homepage "https://www.sphinx-doc.org/"
  url "https://files.pythonhosted.org/packages/cd/bd/f08eb0f4eed5c83f1ba2a3bd18f7745a2b1525fad70660a1c00224ec468a/sphinx-9.1.0.tar.gz"
  sha256 "7741722357dd75f8190766926071fed3bdc211c74dd2d7d4df5404da95930ddb"
  license "BSD-2-Clause"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ff64e4a8e208fcc215ea9dee59327cfb0bec3b2ec8db9978f5931668052d547"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56fc20d6cef80467c6ec73d0e491865b757f0f0f99b976458bc3f3371b84a472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee05a00687a41405bc88042ec9b109f7892cb42d7ad6f48796a3ead137dd80f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d92f7ff486dd5469171e2fd75e7c40a5f1a100fb6c1b949a30c7ff62e2c3bd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f449bd710343a03f51c404864c4b96baeaf18efae326c77c2263340a89875d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb14245c968c49823c8655759367d97c7e8132e88d89285cf83d5b963a16b80f"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   "numpydoc"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/a6/f8/d9c74d0daf3f742840fd818d69cfae176fa332022fd44e3469487d5a9420/alabaster-1.0.0.tar.gz"
    sha256 "c00dca57bca26fa62a6d7d0a9fcce65f3e026e9bfe33e9c538fd3fbb2144fd9e"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/b6/03bb70946330e88ffec97aefd3ea75ba575cb2e762061e0e62a213befee8/docutils-0.22.4.tar.gz"
    sha256 "4db53b1fde9abecbb74d91230d32ab626d94f6badfc575d6db9194a49df29968"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/6c/e6/7bf14eeb8f8b7251141944835abd42eb20a658d89084b7e1f3e5fe394090/imagesize-2.0.0.tar.gz"
    sha256 "8e8358c4a05c304f1fccf7ff96f036e7243a189e9e42e90851993c558cfe9ee3"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "numpydoc" do
    url "https://files.pythonhosted.org/packages/e9/3c/dfccc9e7dee357fb2aa13c3890d952a370dd0ed071e0f7ed62ed0df567c1/numpydoc-1.10.0.tar.gz"
    sha256 "3f7970f6eee30912260a6b31ac72bba2432830cd6722569ec17ee8d3ef5ffa01"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "roman-numerals" do
    url "https://files.pythonhosted.org/packages/ae/f9/41dc953bbeb056c17d5f7a519f50fdf010bd0553be2d630bc69d1e022703/roman_numerals-4.1.0.tar.gz"
    sha256 "1af8b147eb1405d5839e78aeb93131690495fe9da5c91856cb33ad55a7f1e5b2"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/75/a7/9810d872919697c9d01295633f5d574fb416d47e535f258272ca1f01f447/snowballstemmer-3.0.1.tar.gz"
    sha256 "6d5eeeec8e9f84d4d56b847692bacf79bc2c8e90c7f80ca4444ff8b6f2e52895"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/ba/6e/b837e84a1a704953c62ef8776d45c3e8d759876b4a84fe14eba2859106fe/sphinxcontrib_applehelp-2.0.0.tar.gz"
    sha256 "2f29ef331735ce958efa4734873f084941970894c6090408b079c61b2e1c06d1"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/f6/d2/5beee64d3e4e747f316bae86b55943f51e82bb86ecd325883ef65741e7da/sphinxcontrib_devhelp-2.0.0.tar.gz"
    sha256 "411f5d96d445d1d73bb5d52133377b4248ec79db5c793ce7dbe59e074b4dd1ad"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/43/93/983afd9aa001e5201eab16b5a444ed5b9b0a7a010541e0ddfbbfd0b2470c/sphinxcontrib_htmlhelp-2.1.0.tar.gz"
    sha256 "c9e2916ace8aad64cc13a0d233ee22317f2b9025b9cf3295249fa985cc7082e9"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/68/bc/9104308fc285eb3e0b31b67688235db556cd5b0ef31d96f30e45f2e51cae/sphinxcontrib_qthelp-2.0.0.tar.gz"
    sha256 "4fe7d0ac8fc171045be623aba3e2a8f613f8682731f9153bb2e40ece16b9bbab"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/3b/44/6716b257b0aa6bfd51a1b31665d1c205fb12cb5ad56de752dfa15657de2f/sphinxcontrib_serializinghtml-2.0.0.tar.gz"
    sha256 "e9d912827f872c029017a53f0ef2180b327c3f7fd23c87229f7a8e8b70031d4d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"sphinx-quickstart", "-pProject", "-aAuthor", "-v1.0", "-q", testpath
    system bin/"sphinx-build", testpath, testpath/"build"
    assert_path_exists testpath/"build/index.html"
  end
end
