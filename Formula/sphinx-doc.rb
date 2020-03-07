class SphinxDoc < Formula
  include Language::Python::Virtualenv

  desc "Tool to create intelligent and beautiful documentation"
  homepage "https://www.sphinx-doc.org/"
  url "https://files.pythonhosted.org/packages/d5/75/e2a582a0ce014dce99cab62f251c179712cb6c4377705deb7c9b474e4f35/Sphinx-2.4.4.tar.gz"
  sha256 "b4c750d546ab6d7e05bdff6ac24db8ae3e8b8253a3569b754e445110a0a12b66"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a452d7f0d3f68b0f85aecb461fbc6f4f2f4d3f24e8d0fbb629720aaacb9d05b" => :catalina
    sha256 "31813e4e556c556be52061b78cd32613faf9e9fd376b244c04c96d61b2a71448" => :mojave
    sha256 "77e06b6c3c34a04431ae18d9878ec0c5855804ceb76c6702d679acf5286c9bf5" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/34/18/8706cfa5b2c73f5a549fdc0ef2e24db71812a2685959cff31cbdfc010136/Babel-2.8.0.tar.gz"
    sha256 "1aac2ae2d0d8ea368fa90906567f5c08463d98ade155c0c4bfedd6a0f7160e38"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/e4/9f/0452b459c8ba97e07c3cd2bd243783936a992006cf4cd1353c314a927028/imagesize-1.2.0.tar.gz"
    sha256 "b1f6b5a4eab1f73479a50fb79fcf729514a900c341d8503d62a62dbc4127a2b1"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/d8/03/e491f423379ea14bb3a02a5238507f7d446de639b623187bccc111fbecdf/Jinja2-2.11.1.tar.gz"
    sha256 "93187ffbc7808079673ef52771baa950426fd664d3aad1d0fa3e95644360e250"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "numpydoc" do
    url "https://files.pythonhosted.org/packages/b0/70/4d8c3f9f6783a57ac9cc7a076e5610c0cc4a96af543cafc9247ac307fbfe/numpydoc-0.9.2.tar.gz"
    sha256 "9140669e6b915f42c6ce7fef704483ba9b0aaa9ac8e425ea89c76fe40478f642"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/37/83e3f492eb52d771e2820e88105f605335553fe10422cba9d256faeb1702/packaging-20.3.tar.gz"
    sha256 "3c292b474fda1671ec57d46d739d072bfd495a4f51ad01a055121d81e952b7a3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/cb/9f/27d4844ac5bf158a33900dbad7985951e2910397998e85712da03ce125f0/Pygments-2.5.2.tar.gz"
    sha256 "98c8aa5a9f778fcd1026a17361ddaf7330d1b7c62ae97c3bb0ae73e0b9b6b0fe"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/a2/56/0404c03c83cfcca229071d3c921d7d79ed385060bbe969fde3fd8f774ebd/pyparsing-2.4.6.tar.gz"
    sha256 "4c830582a84fb022400b85429791bc551f1f4871c33f23e44f353119e92f969f"
  end

  resource "python-docs-theme" do
    url "https://files.pythonhosted.org/packages/fa/63/759ff01d90ad08fbec19954c71f474c0c0e613850a6419b4b6a4ea79f5e9/python-docs-theme-2020.1.tar.gz"
    sha256 "29c33ba393bdb9377910116a0c1cc329573a4e040227c58a3293d27928d8262a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/82/c3/534ddba230bd4fbbd3b7a3d35f3341d014cca213f369a9940925e7e5f691/pytz-2019.3.tar.gz"
    sha256 "b02c06db6cf09c12dd25137e563b31700d3b80fcc4ad23abb7a315f2789819be"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/21/1b/6b8bbee253195c61aeaa61181bb41d646363bdaa691d0b94b304d4901193/snowballstemmer-2.0.0.tar.gz"
    sha256 "df3bac3df4c2c01363f3dd2cfa78cce2840a79b9f1c2d2de9ce8d31683992f52"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/9f/01/ad9d4ebbceddbed9979ab4a89ddb78c9760e74e6757b1880f1b2760e8295/sphinxcontrib-applehelp-1.0.2.tar.gz"
    sha256 "a072735ec80e7675e3f432fcae8610ecf509c5f1869d17e2eecff44389cdbc58"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/98/33/dc28393f16385f722c893cb55539c641c9aaec8d1bc1c15b69ce0ac2dbb3/sphinxcontrib-devhelp-1.0.2.tar.gz"
    sha256 "ff7f1afa7b9642e7060379360a67e9c41e8f3121f2ce9164266f61b9f4b338e4"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/c9/2e/a7a5fef38327b7f643ed13646321d19903a2f54b0a05868e4bc34d729e1f/sphinxcontrib-htmlhelp-1.0.3.tar.gz"
    sha256 "e8f5bb7e31b2dbb25b9cc435c8ab7a79787ebf7f906155729338f3156d93659b"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/b1/8e/c4846e59f38a5f2b4a0e3b27af38f2fcf904d4bfd82095bf92de0b114ebd/sphinxcontrib-qthelp-1.0.3.tar.gz"
    sha256 "4c33767ee058b70dba89a6fc5c1892c0d57a54be67ddd3e7875a18d14cba5a72"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/ac/86/021876a9dd4eac9dae0b1d454d848acbd56d5574d350d0f835043b5ac2cd/sphinxcontrib-serializinghtml-1.1.4.tar.gz"
    sha256 "eaa0eccc86e982a9b939b2b82d12cc5d013385ba5eadcc7e4fed23f4405f77bc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
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
