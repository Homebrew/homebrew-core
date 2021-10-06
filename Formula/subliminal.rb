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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d87102a64a1865c41b5bffeae63eea3a0a256a2fb33cec0f891752bc5b2425a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a08b741a403f492e203a65d9bf4dfca26062247db174f0e031466b80d7911415"
    sha256 cellar: :any_skip_relocation, catalina:      "ae842ceb5c2b8488ceca4cf40efb8bf6a384945827f82359162b22f8c3ff8cc9"
    sha256 cellar: :any_skip_relocation, mojave:        "a8a0a8866b687758fe4382bf7a999a64918d2b84805ecc51bdd6d2b934e31bdc"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f311103549dacb446020249bc66b64599faca35421183dc180a9cf73722e1faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1840458efc8a0b046a0b45ed8a223c02a94bb47848b292e89d9013e28ee093dd"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/02/0d/e72bf59672ebceae99cd339106df2b0d59964e00a04f7286ae9279d9da6c/babelfish-0.6.0.tar.gz"
    sha256 "2dadfadd1b205ca5fa5dc9fa637f5b7933160a0418684c7c46a7a664033208a2"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
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
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/92/3c/34f8448b61809968052882b830f7d8d9a8e1c07048f70deb039ae599f73c/decorator-5.1.0.tar.gz"
    sha256 "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/a4/5a/2735b2db3b704f4fa134360842560456e7aea509c4519ada9a0333b6c236/dogpile.cache-1.1.4.tar.gz"
    sha256 "ea09bebf24bb7c028caf98963785fe9ad0bd397305849a3303bc5380d468d813"
  end

  resource "enzyme" do
    url "https://files.pythonhosted.org/packages/dd/99/e4eee822d9390ebf1f63a7a67e8351c09fb7cd75262e5bb1a5256898def9/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/d1/bd/fff4ea8a8ac48f04505b562614a22e408095d91e56c01948658d05b23ad0/guessit-3.3.1.tar.gz"
    sha256 "8305e0086129614a8820a508303f98f56c584811489499bcc54a7ea6f1b0391e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/35/8c/69ed04ae31ad498c9bdea55766ed4c0c72de596e75ac0d70b58aa25e0acf/pbr-5.6.0.tar.gz"
    sha256 "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd"
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
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/0c/2f/894bc187ce40367f2e878ced196e1b5a9bc66cb553a062ed955d4f7dcbab/rarfile-4.0.tar.gz"
    sha256 "67548769229c5bda0827c1663dce3f54644f9dbfba4ae86d4da2b2afd3e602a1"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/c2/7d/d83e05e1ade953dd5b624753f72366ec38d7e153de4ec2209efa6375566d/rebulk-3.0.1.tar.gz"
    sha256 "025d191c11abf9174c6aff0006579624047d3371a654333c4bf7a4b421552cdc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    episode = "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL"
    system bin/"subliminal", "download", "-l", "en", "#{episode}.mp4"
    assert_predicate testpath/"#{episode}.en.srt", :exist?
  end
end
