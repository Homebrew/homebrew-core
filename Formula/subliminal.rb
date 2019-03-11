class Subliminal < Formula
  include Language::Python::Virtualenv

  desc "Library to search and download subtitles"
  homepage "https://subliminal.readthedocs.org"
  url "https://files.pythonhosted.org/packages/f0/84/8cddb13aa4142e85546cd7c0d0546d2c1a25f0876000a3ec37151dfd8eb9/subliminal-2.0.5.tar.gz"
  sha256 "147aa54f54de62d6fcafa213bb9ea89319600c133dab1a5532ff7126352bfbb7"
  head "https://github.com/Diaoul/subliminal.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "457861fcc30e065232f158501fd4e3b80fb0c60bcbfbcb12dca0ac3906c37121" => :mojave
    sha256 "5582303e8dd6e3ddcc82b5ca88454337116ed22e46c08e6bea6b9068c9d91085" => :high_sierra
    sha256 "1e53262d5fe047cbb56366be5c195f172a28c1d0f24dfaccb1808c7d4bd739ac" => :sierra
  end

  depends_on "python@2" # does not support Python 3.7

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/bd/66/0a7f48a0f3fb1d3a4072bceb5bbd78b1a6de4d801fb7135578e7c7b1f563/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/34/b7/b36c651a9136990060ab4d6c9a32de81752123105b940b2f3b958e5c6cd0/babelfish-0.5.5.tar.gz"
    sha256 "8380879fa51164ac54a3e393f83c4551a275f03617f54a99d70151358e444104"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/86/ea/8e9fbce5c8405b9614f1fd304f7109d9169a3516a493ce4f7f77c39435b7/beautifulsoup4-4.5.1.tar.gz"
    sha256 "3c9474036afda9136aac6463def733f81017bf9ef3510d25634f335b0c87f5e1"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/7d/87/4e3a3f38b2f5c578ce44f8dc2aa053217de9f0b6d737739b0ddac38ed237/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/9d/a9/ba70aadc6170841a1c6145e9039d4b1c2a4ef8c44cd0ca9b09ab79be9120/dogpile.cache-0.6.2.tar.gz"
    sha256 "73793471af07af6dc5b3ee015abfaca4220caaa34c615537f5ab007ed150726d"
  end

  resource "enzyme" do
    url "https://files.pythonhosted.org/packages/dd/99/e4eee822d9390ebf1f63a7a67e8351c09fb7cd75262e5bb1a5256898def9/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/76/12/036c7fba23ff1dcf6ae8b4f5d0bc8d3617c1f7dfe5696e6ed3e6f38f7d75/guessit-2.0.5.tar.gz"
    sha256 "626e0024c5cca9b84883b65246e4f238e3f39064664486f69f086c853a63ff61"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pysrt" do
    url "https://files.pythonhosted.org/packages/f6/33/16ad65a8973cb8bcb494af09ee1b9ab5ffdd6ff300bce5d3ac7d3cb1f2cc/pysrt-1.1.1.tar.gz"
    sha256 "fb4c10424549fc5a32d19cd5091f00316b875461fcd79a7809bb55056974d0aa"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/61/6b/f3a920258ea1237d091b4a06aa0e527fa3ab76ede5875745425851e3d4c7/python-dateutil-2.5.1.tar.gz"
    sha256 "40d1bc468c7df50aff9e7a12c14687f9180efcff86900ee2963f9f2c13b5d7a9"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f7/c7/08e54702c74baf9d8f92d0bc331ecabf6d66a56f6d36370f0a672fc6a535/pytz-2016.6.1.tar.bz2"
    sha256 "b5aff44126cf828537581e534cc94299b223b945a2bb3b5434d37bf8c7f3a10c"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/21/20/f07592dcf45f8f88a23c094019008ad220307401214a5c5a4e44d3e93acf/rarfile-2.8.tar.gz"
    sha256 "2a27e401daa6d8ff0df1112a274a3661ca3e4afaac626217506fb1391069ca61"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/4d/71/44e0ca08d29265185963bf39a5566746ef1a7e663b5e155bd67a9e4fbd5c/rebulk-0.7.3.tar.gz"
    sha256 "1ee0f672be5cfeed793d294c1cfc078c254fb0966af59191e4f6a0785b3b1697"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/98/33/2c8003cb4294d1729bfb6cdf4bbfe74b968403b2df0a80ee876bebf20488/stevedore-1.17.1.tar.gz"
    sha256 "79414e27ece996b2e81161c1ec91536f2b15645d5f6bd28128724486e1c4b8e3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".config").mkpath
    system bin/"subliminal", "download", "-l", "en",
               "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
    assert_predicate testpath/"The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.en.srt", :exist?
  end
end
