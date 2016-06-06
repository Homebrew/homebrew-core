class Subliminal < Formula
  desc "Library to search and download subtitles"
  homepage "https://subliminal.readthedocs.org"
  url "https://github.com/Diaoul/subliminal/archive/2.0.2.tar.gz"
  sha256 "26ca17d28617d8f18759724386cc1940facf89f9f6fdc90b19c43eb0daa1c109"
  head "https://github.com/Diaoul/subliminal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "32a8d03b2e38b2e559ab50ff2d355e8a09b94fe15ce21da7bd1f2346750c8fcc" => :el_capitan
    sha256 "7f39d2fd204a54885138290f72ff53f02d4b148fd81d34513b970d52f4328491" => :yosemite
    sha256 "2b31e224831aac555042927d935b0d9acb58ab19e382a39f9943e34fc12e9e32" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pip" do
    url "https://pypi.python.org/packages/e7/a8/7556133689add8d1a54c0b14aeff0acb03c64707ce100ecd53934da1aa13/pip-8.1.2.tar.gz"
    sha256 "4d24b03ffa67638a3fa931c09fd9e0273ffa904e95ebebe7d4b1a54c93d7b732"
  end

  resource "appdirs" do
    url "https://pypi.python.org/packages/bd/66/0a7f48a0f3fb1d3a4072bceb5bbd78b1a6de4d801fb7135578e7c7b1f563/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "babelfish" do
    url "https://pypi.python.org/packages/34/b7/b36c651a9136990060ab4d6c9a32de81752123105b940b2f3b958e5c6cd0/babelfish-0.5.5.tar.gz"
    sha256 "8380879fa51164ac54a3e393f83c4551a275f03617f54a99d70151358e444104"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/26/79/ef9a8bcbec5abc4c618a80737b44b56f1cb393b40238574078c5002b97ce/beautifulsoup4-4.4.1.tar.gz"
    sha256 "87d4013d0625d4789a4f56b8d79a04d5ce6db1152bb65f1d39744f7709a366b4"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/7d/87/4e3a3f38b2f5c578ce44f8dc2aa053217de9f0b6d737739b0ddac38ed237/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://pypi.python.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "dogpile.cache" do
    url "https://pypi.python.org/packages/16/15/8de884814301e26d273d51f0b07ad605f71cb7fad37deec096da4d2f031d/dogpile.cache-0.6.0.tar.gz"
    sha256 "1b65aba2dde75cb577f275b5f3f4fcc635d21b3dc6781b98cef57bd009d93185"
  end

  resource "enzyme" do
    url "https://pypi.python.org/packages/dd/99/e4eee822d9390ebf1f63a7a67e8351c09fb7cd75262e5bb1a5256898def9/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "guessit" do
    url "https://pypi.python.org/packages/76/12/036c7fba23ff1dcf6ae8b4f5d0bc8d3617c1f7dfe5696e6ed3e6f38f7d75/guessit-2.0.5.tar.gz"
    sha256 "626e0024c5cca9b84883b65246e4f238e3f39064664486f69f086c853a63ff61"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pysrt" do
    url "https://pypi.python.org/packages/f6/33/16ad65a8973cb8bcb494af09ee1b9ab5ffdd6ff300bce5d3ac7d3cb1f2cc/pysrt-1.1.1.tar.gz"
    sha256 "fb4c10424549fc5a32d19cd5091f00316b875461fcd79a7809bb55056974d0aa"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/61/6b/f3a920258ea1237d091b4a06aa0e527fa3ab76ede5875745425851e3d4c7/python-dateutil-2.5.1.tar.gz"
    sha256 "40d1bc468c7df50aff9e7a12c14687f9180efcff86900ee2963f9f2c13b5d7a9"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709/pytz-2016.4.tar.bz2"
    sha256 "ee7c751544e35a7b7fb5e3fb25a49dade37d51e70a93e5107f10575d7102c311"
  end

  resource "rarfile" do
    url "https://pypi.python.org/packages/21/20/f07592dcf45f8f88a23c094019008ad220307401214a5c5a4e44d3e93acf/rarfile-2.8.tar.gz"
    sha256 "2a27e401daa6d8ff0df1112a274a3661ca3e4afaac626217506fb1391069ca61"
  end

  resource "rebulk" do
    url "https://pypi.python.org/packages/77/df/06b4d2ddc94d8618cd6da533e42c090cbf4aa90bd046a5b0224a53282e9d/rebulk-0.7.2.tar.gz"
    sha256 "ee4c75819c6d0eeedb531fb22c214e50f303ccc4703f27db1f993cd082ed5a20"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/db/46/2e84e2aedfdb59ac2690c08363e376860bbcc0921d44f8828d7c09167f5c/stevedore-1.14.0.tar.gz"
    sha256 "474381b594451f8999b889476aeaaea193e007c6fdf7b7c5659e6e7e5fb53d8a"
  end

  # not required by install_requires but provides additional UI when available
  resource "colorlog" do
    url "https://pypi.python.org/packages/source/c/colorlog/colorlog-2.6.0.tar.gz"
    sha256 "0f03ae0128a1ac2e22ec6a6617efbd36ab00d4b2e1c49c497e11854cf24f1fe9"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # dogpile is a namespace package and .pth files aren't read from our
    # vendor site-packages
    touch libexec/"vendor/lib/python2.7/site-packages/dogpile/__init__.py"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/".config").mkpath
    system "#{bin}/subliminal", "download", "-l", "en",
           "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
    assert File.exist?("The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.en.srt")
  end
end
