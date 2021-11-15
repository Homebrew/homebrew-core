class SphinxDoc < Formula
  include Language::Python::Virtualenv

  desc "Tool to create intelligent and beautiful documentation"
  homepage "https://www.sphinx-doc.org/"
  url "https://files.pythonhosted.org/packages/45/14/8a3bf633c8141bd58e027f36fc5e775da308c635437eb45f13d1633915ea/Sphinx-4.3.0.tar.gz"
  sha256 "6d051ab6e0d06cba786c4656b0fe67ba259fe058410f49e95bee6e49c4052cbf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fed35520e33db56a34c1585a4712cc69d4420665d231d61958153f99738f2e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62ce3ca69f890f1b6f178af6c742017df946e2f4d435f80acb9e83216a1aa942"
    sha256 cellar: :any_skip_relocation, monterey:       "2dae32ea790b42ed602160535f53eff4dffc6639a054ede52490f274c86d4a6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e545ada9372a718d0197dca23fa92b1eb2a62d7e6a2bf2ee5620bd111c9835f5"
    sha256 cellar: :any_skip_relocation, catalina:       "f00e4033c88e5fd0e8ad5a854954b3b740b2c363573a8fc8e5516124d9dfbbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021705894700796936a174b2a5141768dbf11f105f63b04cb24a0bb99925d844"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install sphinx-doc
  EOS

  depends_on "python@3.10"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/cc/b4/ed8dcb0d67d5cfb7f83c4d5463a7614cb1d078ad7ae890c9143edebbf072/alabaster-0.7.12.tar.gz"
    sha256 "a661d72d58e6ea8a57f7a86e37d86716863ee5e92788398526d58b26a4e4dc02"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/17/e6/ec9aa6ac3d00c383a5731cc97ed7c619d3996232c977bb8326bcbb6c687e/Babel-2.9.1.tar.gz"
    sha256 "bc0c176f9f6a994582230df350aa6e05ba2ebe4b3ac317eab29d9be5d2768da0"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/f6/27/b147794d43249e8303a06f427e407a090696b65b81045e36f8873d8d8a42/imagesize-1.3.0.tar.gz"
    sha256 "cd1750d452385ca327479d45b64d9c7729ecf0b3969a58148298c77092261f9d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "numpydoc" do
    url "https://files.pythonhosted.org/packages/3d/fb/a70f636102045fc646656f2221c7fcdf92f7a9d71ba7c9875a949a58b3e8/numpydoc-1.1.0.tar.gz"
    sha256 "c36fd6cb7ffdc9b4e165a43f67bf6271a7b024d0bb6b00ac468c9e2bfc76448e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/4d/34/523195b783e799fd401ad4bbc40d787926dd4c61838441df08bf42297792/packaging-21.2.tar.gz"
    sha256 "096d689d78ca690e4cd8a89568ba06d07ca097e3306a4381635073ca91479966"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/a3/3d/d305c9112f35df6efb51e5acd0db7009b74d86f35580e033451b5994a0a9/snowballstemmer-2.1.0.tar.gz"
    sha256 "e997baa4f2e9139951b6f4c631bad912dfd3c792467e2f03d7239464af90e914"
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
    url "https://files.pythonhosted.org/packages/eb/85/93464ac9bd43d248e7c74573d58a791d48c475230bcf000df2b2700b9027/sphinxcontrib-htmlhelp-2.0.0.tar.gz"
    sha256 "f5f8bb2d0d629f398bf47d0d69c07bc13b65f75a81ad9e2f71a63d4b7a2f6db2"
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
    url "https://files.pythonhosted.org/packages/b5/72/835d6fadb9e5d02304cf39b18f93d227cd93abd3c41ebf58e6853eeb1455/sphinxcontrib-serializinghtml-1.1.5.tar.gz"
    sha256 "aa5f6de5dfdf809ef505c4895e51ef5c9eac17d0f287933eb49ec495280b6952"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
