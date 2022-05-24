class Subliminal < Formula
  include Language::Python::Virtualenv

  desc "Library to search and download subtitles"
  homepage "https://subliminal.readthedocs.io"
  url "https://files.pythonhosted.org/packages/dd/3a/ac02011988ad013f24a11cb6123a7ff9e17a75369964c7edd9f64bfea80f/subliminal-2.1.0.tar.gz"
  sha256 "c6439cc733a4f37f01f8c14c096d44fd28d75d1f6f6e2d1d1003b1b82c65628b"
  license "MIT"
  revision 2
  head "https://github.com/Diaoul/subliminal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "896b416ad54ab5640db53f83dc021165a4c1b15f30cd97d778f1e795c0bf3a34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "408ab52e46c264b167ee376d1a65085a9105acdf6e37d4d9860d32e880588b5c"
    sha256 cellar: :any_skip_relocation, monterey:       "fea6f947320910b06754e0bf23968aaa3352947121469a8e51ba47635502ef3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fd715aca420c248489a132b5b6557ca8abccdcfa142d26ffdcbf49f38406284"
    sha256 cellar: :any_skip_relocation, catalina:       "4ba247d8897d00e269f1da168be4521f5e9a3710f5674f265676fe136963f831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "833521658241fa71e6ee3b16c80d511fe8d0dacd079c74d39978426f4e56501a"
  end

  # https://github.com/Diaoul/subliminal/issues/1046
  deprecate! date: "2022-04-07", because: :unmaintained

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/02/0d/e72bf59672ebceae99cd339106df2b0d59964e00a04f7286ae9279d9da6c/babelfish-0.6.0.tar.gz"
    sha256 "2dadfadd1b205ca5fa5dc9fa637f5b7933160a0418684c7c46a7a664033208a2"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/0e/94/73c2d93c9e3293115e5b831da50d6dcb20959a424309e2ddcc485238e0ce/dogpile.cache-1.1.5.tar.gz"
    sha256 "0f01bdc329329a8289af9705ff40fadb1f82a28c336f3174e12142b70d31c756"
  end

  resource "enzyme" do
    url "https://files.pythonhosted.org/packages/dd/99/e4eee822d9390ebf1f63a7a67e8351c09fb7cd75262e5bb1a5256898def9/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/61/7e/278f26162ac337a97d01d7c7c8bbacead4a057f8b615a06c6a5ebe2f0d95/guessit-3.4.3.tar.gz"
    sha256 "731e96e6a1f3b065d05accc8c19f35d4485d880b77ab8dc4b262cc353df294f7"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/96/9f/f4bc832eeb4ae723b86372277da56a5643b0ad472a95314e8f516a571bb0/pbr-5.9.0.tar.gz"
    sha256 "e8dca2f4b43560edef58813969f52a56cef023146cbb8931626db80e6c1c4308"
  end

  resource "pysrt" do
    url "https://files.pythonhosted.org/packages/31/1a/0d858da1c6622dcf16011235a2639b0a01a49cecf812f8ab03308ab4de37/pysrt-1.1.2.tar.gz"
    sha256 "b4f844ba33e4e7743e9db746492f3a193dc0bc112b153914698e7c1cdeb9b0b9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/0c/2f/894bc187ce40367f2e878ced196e1b5a9bc66cb553a062ed955d4f7dcbab/rarfile-4.0.tar.gz"
    sha256 "67548769229c5bda0827c1663dce3f54644f9dbfba4ae86d4da2b2afd3e602a1"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/66/23/53c95f819f0a91c30254a594e2357550db6d3ed125ed2b5ff0eae19a58d7/rebulk-3.1.0.tar.gz"
    sha256 "809de3a97c68afa831f7101b10d316fe62e061dc9f7f67a44b7738128721173a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
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
