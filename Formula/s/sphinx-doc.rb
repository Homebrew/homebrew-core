class SphinxDoc < Formula
  include Language::Python::Virtualenv

  desc "Tool to create intelligent and beautiful documentation"
  homepage "https://www.sphinx-doc.org/"
  url "https://files.pythonhosted.org/packages/73/8e/6e51da4b26665b4b92b1944ea18b2d9c825e753e19180cc5bdc818d0ed3b/sphinx-7.2.6.tar.gz"
  sha256 "9a5160e1ea90688d5963ba09a2dcd8bdd526620edbb65c328728f1b2228d5ab5"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "177956d656c65fd2707922c6b38ee42876a1e18b62de2010ce86d0c5255e85d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee3a179f2884143b5e4ee9807ce09614b09b154d8aefb76e18d7fabe844836e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cebe319d67591959def7e226ccf5ec544b768cad38b711faa49a0dbd62d36e88"
    sha256 cellar: :any_skip_relocation, sonoma:         "145eaab366a5a5e4eaaba8f012e52243633e2140bd122f8737463bca6a31ed3f"
    sha256 cellar: :any_skip_relocation, ventura:        "aee421b1cae0313d14739c347c6b2fa624dd1f160ddfd1ac6dfac31e9bd2d7a6"
    sha256 cellar: :any_skip_relocation, monterey:       "93c2da5439e176aa9241ada1bde6c75eec86c1ad0683f8b833da8572a426e333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89cfdcdccfd43fa3db4209ebbdb068b70a9a0c4e013f5f7fe8c53ebefbd22bef"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install sphinx-doc
  EOS

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-jinja"
  depends_on "python-packaging"
  depends_on "python-requests"
  depends_on "python-tabulate"
  depends_on "python@3.12"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/94/71/a8ee96d1fd95ca04a0d2e2d9c4081dac4c2d2b12f7ddb899c8cb9bfd1532/alabaster-0.7.13.tar.gz"
    sha256 "a27a4a084d5e690e16e01e03ad2b2e552c61a65469419b907243193de1a84ae2"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/e2/80/cfbe44a9085d112e983282ee7ca4c00429bc4d1ce86ee5f4e60259ddff7f/Babel-2.14.0.tar.gz"
    sha256 "6919867db036398ba21eb5c7a0f6b28ab8cbc3ae7a73a44ebe34ae74a4e7d363"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "numpydoc" do
    url "https://files.pythonhosted.org/packages/5f/ed/5ca4b2e90f4b0781f5fac49cdb2947cf719b6d289eedb67e8b1a63d019e3/numpydoc-1.6.0.tar.gz"
    sha256 "ae7a5380f0a06373c3afe16ccd15bd79bc6b07f2704cbc6f1e7ecc94b4f5fc0d"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/1c/5a/fce19be5d4db26edc853a0c34832b39db7b769b7689da027529767b0aa98/sphinxcontrib_applehelp-1.0.7.tar.gz"
    sha256 "39fdc8d762d33b01a7d8f026a3b7d71563ea3b72787d5f00ad8465bd9d6dfbfa"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/2e/f2/6425b6db37e7c2254ad661c90a871061a078beaddaf9f15a00ba9c3a1529/sphinxcontrib_devhelp-1.0.5.tar.gz"
    sha256 "63b41e0d38207ca40ebbeabcf4d8e51f76c03e78cd61abe118cf4435c73d4212"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/fd/2d/abf5cd4cc1d5cd9842748b15a28295e4c4a927facfa8a0e173bd3f151bc5/sphinxcontrib_htmlhelp-2.0.4.tar.gz"
    sha256 "6c26a118a05b76000738429b724a0568dbde5b72391a688577da08f11891092a"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/4f/a2/53129fc967ac8402d5e4e83e23c959c3f7a07362ec154bdb2e197d8cc270/sphinxcontrib_qthelp-1.0.6.tar.gz"
    sha256 "62b9d1a186ab7f5ee3356d906f648cacb7a6bdb94d201ee7adf26db55092982d"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/5c/41/df4cd017e8234ded544228f60f74fac1fe1c75bdb1e87b33a83c91a10530/sphinxcontrib_serializinghtml-1.1.9.tar.gz"
    sha256 "0c64ff898339e1fac29abd2bf5f11078f3ec413cfe9c046d3120d7ca65530b54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"sphinx-quickstart", "-pPorject", "-aAuthor", "-v1.0", "-q", testpath
    system bin/"sphinx-build", testpath, testpath/"build"
    assert_predicate testpath/"build/index.html", :exist?
  end
end
