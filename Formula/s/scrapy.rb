class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https://scrapy.org"
  url "https://files.pythonhosted.org/packages/c5/f2/5c7f7f3e941e9a2046120d5f034fcf19e78151e0b5d96baed92d4d260429/Scrapy-2.11.1.tar.gz"
  sha256 "733a039c7423e52b69bf2810b5332093d4e42a848460359c07b02ecff8f73ebe"
  license "BSD-3-Clause"
  head "https://github.com/scrapy/scrapy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee984de80baa6c611b58acc1e3e84e1cda60a34d617aaea7770d25f86eee3bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96edc6c849de58d651246278a9d31592b6387bd6df5f7fb7fc4e7235047d9ecb"
    sha256 cellar: :any,                 arm64_monterey: "835bc91f3b1e7e6c6562bab5bffe4844bcb71a3eb2b5ad57131d94a45c7c5d2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee122ad4dd56aa0863b8531d2d24f3db435c81cf18d0866172bcea436bfcd9e9"
    sha256 cellar: :any_skip_relocation, ventura:        "8dcba64e2e832a0117e59b1d84df417bc1126032fd2d76ff196bfb39ef22b9dd"
    sha256 cellar: :any,                 monterey:       "4176b5b8b62664da15c5ee97a808cc2236e219ca88be288cf91b186df0611692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd21f1e4b117c4dd46ff77cec1a0e6b4bd57163367f21aa33782cc6c6023d42e"
  end

  depends_on "certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/7a/7b/9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4/Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/86/42/9e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09/incremental-22.10.0.tar.gz"
    sha256 "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"
  end

  resource "itemadapter" do
    url "https://files.pythonhosted.org/packages/a1/1e/c09a9ceec55880fa8801fec1492c922ef1d7d84e7c4768c1cc12e0b950c4/itemadapter-0.8.0.tar.gz"
    sha256 "77758485fb0ac10730d4b131363e37d65cb8db2450bfec7a57c3f3271f4a48a9"
  end

  resource "itemloaders" do
    url "https://files.pythonhosted.org/packages/17/38/07db5e6ebdbe7acec2341fb65603fe4639431aa0133748156368f17a6c8e/itemloaders-1.1.0.tar.gz"
    sha256 "21d81c61da6a08b48e5996288cdf3031c0f92e5d0075920a0242527523e14a48"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "parsel" do
    url "https://files.pythonhosted.org/packages/75/2a/824fe02ed04292879b779a8cfc89083a1db3a390b6afc336bcf4baeb9424/parsel-1.8.1.tar.gz"
    sha256 "aff28e68c9b3f1a901db2a4e3f158d8480a38724d7328ee751c1a4e1c1801e39"
  end

  resource "protego" do
    url "https://files.pythonhosted.org/packages/2c/7e/fc128cfd3bb8e081165fcdaad44ab5fff73678fbebc51f79f733c57c5295/Protego-0.3.0.tar.gz"
    sha256 "04228bffde4c6bcba31cf6529ba2cfd6e1b70808fdc1d2cb4301be6b28d6c568"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pydispatcher" do
    url "https://files.pythonhosted.org/packages/21/db/030d0700ae90d2f9d52c2f3c1f864881e19cef8cba3b0a08759c8494c19c/PyDispatcher-2.0.7.tar.gz"
    sha256 "b777c6ad080dc1bad74a4c29d6a46914fa6701ac70f94b0d66fbcfde62f5be31"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "queuelib" do
    url "https://files.pythonhosted.org/packages/4d/11/94d3a5c1a03fa984b3f793ceecfac4b685ca9fc7a3af03f806dbb973555b/queuelib-1.6.2.tar.gz"
    sha256 "4b207267f2642a8699a1f806045c56eb7ad1a85a10c0e249884580d139c2fcd2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/2b/69/ba1b5f52f96cde4f2d8eca74a0aa2c11a66b2fe58d0fb63b2e46edce6ed3/requests-file-2.0.0.tar.gz"
    sha256 "20c5931629c558fda566cacc10cfe2cd502433e628f568c34c80d96a0cc95972"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/38/d2/2ac20fd05f1b6fce31986536da4caeac51ed2e1bb25d4a7d73ca4eccdfab/service_identity-24.1.0.tar.gz"
    sha256 "6829c9d62fb832c2e1c435629b0a8c476e1929881f28bee4d20bc24161009221"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/02/21/4f2d7d6023650770112dd8144dbc47afabbfaf568a0d39abc0a4f37e8e9e/tldextract-5.1.1.tar.gz"
    sha256 "9b6dbf803cb5636397f0203d48541c0da8ba53babaf0e8a6feda2d88746813d4"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/6e/d3/077ece8f12cd82419bd68bb34cf4538c4df5bb9202835e7a18358223e537/twisted-23.10.0.tar.gz"
    sha256 "987847a0790a2c597197613686e2784fd54167df3a55d0fb17c8412305d76ce5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "w3lib" do
    url "https://files.pythonhosted.org/packages/47/79/0c62d246fcc9e6fe520c196fe4dad2070db64692bde49c15c4f71fe7d1cb/w3lib-2.1.2.tar.gz"
    sha256 "ed5b74e997eea2abe3c1321f916e344144ee8e9072a6f33463ee8e57f858a4b1"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/cd/37/1b003190ba7148226a8212d98ff8074e212fef30c82e616bdb818ae1f838/zope.interface-6.2.tar.gz"
    sha256 "3b6c62813c63c543a06394a636978b22dffa8c5410affc9331ce6cdb5bfa8565"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrapy version")

    system "#{bin}/scrapy", "startproject", "brewproject"
    cd testpath/"brewproject" do
      system "#{bin}/scrapy", "genspider", "-t", "basic", "brewspider", "brew.sh"
      assert_match "INFO: Spider closed (finished)", shell_output("#{bin}/scrapy crawl brewspider 2>&1")
    end
  end
end
