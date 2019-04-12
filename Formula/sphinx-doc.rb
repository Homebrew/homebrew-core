class SphinxDoc < Formula
  include Language::Python::Virtualenv

  desc "Tool to create intelligent and beautiful documentation"
  homepage "https://www.sphinx-doc.org/"
  url "https://files.pythonhosted.org/packages/81/e3/cb726b65039569840547895e1c81759d44e50512d038268afa8c1bf2001c/Sphinx-2.0.1.tar.gz"
  sha256 "423280646fb37944dd3c85c58fb92a20d745793a9f6c511f59da82fa97cd404b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d092ce3cdde5d1c4f74ec750b2488ce6ff2968961df1f272e3cc0f90a6f5636" => :mojave
    sha256 "c92e3368944d7bfaa8f51110abe3cede329e34d888d7b1ef518ab2f4c0865c5b" => :high_sierra
    sha256 "facd8d1eb8a922887bbb930e2e584ece2812475ccc518278b64187daea047338" => :sierra
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install sphinx-doc
  EOS

  depends_on "python"

  # generated from sphinx, numpydoc and python-docs-theme
  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/cc/b4/ed8dcb0d67d5cfb7f83c4d5463a7614cb1d078ad7ae890c9143edebbf072/alabaster-0.7.12.tar.gz"
    sha256 "a661d72d58e6ea8a57f7a86e37d86716863ee5e92788398526d58b26a4e4dc02"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/be/cc/9c981b249a455fa0c76338966325fc70b7265521bad641bf2932f77712f4/Babel-2.6.0.tar.gz"
    sha256 "8cba50f48c529ca3fa18cf81fa9403be176d374ac4d60738b839122dfaaa3d23"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz"
    sha256 "b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/41/f5/3cf63735d54aa9974e544aa25858d8f9670ac5b4da51020bbfc6aaade741/imagesize-1.1.0.tar.gz"
    sha256 "f3832918bc3c66617f92e35f5d70729187676313caa60c187eb0f28b8fe5e3b5"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/93/ea/d884a06f8c7f9b7afbc8138b762e80479fb17aedbbe2b06515a12de9378d/Jinja2-2.10.1.tar.gz"
    sha256 "065c4f02ebe7f7cf559e49ee5a95fb800a9e4528727aec6f24402a5374c65013"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "numpydoc" do
    url "https://files.pythonhosted.org/packages/95/a8/b4706a6270f0475541c5c1ee3373c7a3b793936ec1f517f1a1dab4f896c0/numpydoc-0.8.0.tar.gz"
    sha256 "61f4bf030937b60daa3262e421775838c945dcdd671f37b69e8e4854c7eb5ffd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/16/51/d72654dbbaa4a4ffbf7cb0ecd7d12222979e0a660bf3f42acc47550bf098/packaging-19.0.tar.gz"
    sha256 "0c98a5d0be38ed775798ece1b9727178c4469d9c3b4ada66e8e6b7849f8732af"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/64/69/413708eaf3a64a6abb8972644e0f20891a55e621c6759e2c3f3891e05d63/Pygments-2.3.1.tar.gz"
    sha256 "5ffada19f6203563680669ee7f53b64dabbeb100eb51b61996085e99c03b284a"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/5d/3a/24d275393f493004aeb15a1beae2b4a3043526e8b692b65b4a9341450ebe/pyparsing-2.4.0.tar.gz"
    sha256 "1873c03321fc118f4e9746baf201ff990ceb915f433f23b395f5580d1840cb2a"
  end

  resource "python-docs-theme" do
    url "https://files.pythonhosted.org/packages/77/f9/8c63766fe271549db3a578b652dea6678b90b593300315507b9c922f7173/python-docs-theme-2018.7.tar.gz"
    sha256 "018a5bf2a7318c9c9a8346303dac8afc6bc212d92e86561c9b95a3372714155a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/df/d5/3e3ff673e8f3096921b3f1b79ce04b832e0100b4741573154b72b756a681/pytz-2019.1.tar.gz"
    sha256 "d747dd3d23d77ef44c6a3526e274af6efeb0a6f1afd5a69ba4d5be4098c8e141"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/20/6b/d2a7cb176d4d664d94a6debf52cd8dbae1f7203c8e42426daa077051d59c/snowballstemmer-1.2.1.tar.gz"
    sha256 "919f26a68b2c17a7634da993d91339e288964f93c274f1343e3bbbe2096e1128"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/1b/71/8bafa145e48131049dd4f731d6f6eeefe0c34c3017392adbec70171ad407/sphinxcontrib-applehelp-1.0.1.tar.gz"
    sha256 "edaa0ab2b2bc74403149cb0209d6775c96de797dfd5b5e2a71981309efab3897"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/57/5f/bf9a0f7454df68a7a29033a5cf8d53d0797ae2e426b1b419e4622726ec7d/sphinxcontrib-devhelp-1.0.1.tar.gz"
    sha256 "6c64b077937330a9128a4da74586e8c2130262f014689b4b89e2d08ee7294a34"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/f1/f2/88e9d6dc4a17f1e95871f8b634adefcc5d691334f7a121e9f384d1dc06fd/sphinxcontrib-htmlhelp-1.0.2.tar.gz"
    sha256 "4670f99f8951bd78cd4ad2ab962f798f5618b17675c35c5ac3b2132a14ea8422"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/0c/f0/690cd10603e3ea8d184b2fffde1d965dd337b87a1d5f7625d0f6791094f4/sphinxcontrib-qthelp-1.0.2.tar.gz"
    sha256 "79465ce11ae5694ff165becda529a600c754f4bc459778778c7017374d4d406f"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/cd/cc/fd7d17cfae18e5a92564bb899bc05e13260d7a633f3cffdaad4e5f3ce46a/sphinxcontrib-serializinghtml-1.1.3.tar.gz"
    sha256 "c0efb33f8052c04fd7a26c0a07f1678e8512e0faec19f4aa8f2473a8b81d5227"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/bf/9b/2bf84e841575b633d8d91ad923e198a415e3901f228715524689495b4317/typing-3.6.6.tar.gz"
    sha256 "4027c5f6127a6267a435201981ba156de91ad0d1d98e9ddc2aa173453453492d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
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
