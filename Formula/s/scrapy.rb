class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https://scrapy.org"
  url "https://files.pythonhosted.org/packages/f2/1f/5524416a64c030fbe18caeba079e7176836b281bf9eb50b79efdf8015063/scrapy-2.11.2.tar.gz"
  sha256 "dfbd565384fc3fffeba121f5a3a2d0899ac1f756d41432ca0879933fbfb3401d"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/scrapy/scrapy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96ccde182e60de0b603957f17b4967b28cd2ed4ff0bf276e2cd7b46e2704e6d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "897d612ab1778cfbe4bc3777dfade3397d367e2edc33e002ff61b459f70db98d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90f7d4f57273295ad42e22337400ccdfc5ca24d7fa37127110f6dae9d4e70f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ecaa3e699cf2e40e299a3d653c997db7c2c7d69f814f2df11e413a2a07b161d"
    sha256 cellar: :any_skip_relocation, ventura:       "c076d5714df57e219f09416c8f4d3c246c42ea8de3f3b1876d68facd7f4c88fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bc58b53aa1af4adcb27f831ff701f9254aad08d5f8d1348269f6f727fbbf773"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/8d/2d/ede4ad7fc34ab4482389fa3369d304f2fa22e50770af706678f6a332fa82/automat-24.8.1.tar.gz"
    sha256 "b34227cf63f6325b8ad2399ede780675083e439b20c323d376373d8ee6306d88"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/27/87/156b374ff6578062965afe30cc57627d35234369b3336cf244b240c8d8e6/incremental-24.7.2.tar.gz"
    sha256 "fb4f1d47ee60efe87d4f6f0ebb5f70b9760db2b2574c59c8e8912be4ebd464c9"
  end

  resource "itemadapter" do
    url "https://files.pythonhosted.org/packages/eb/60/a16c93c9d26e83c05bc6b3edc1a8013025b37ca82dee7eda6f89aec583d3/itemadapter-0.9.0.tar.gz"
    sha256 "e4f958a6b6b6f5831fa207373010031a0bd7ed0429ddd09b51979c011475cafd"
  end

  resource "itemloaders" do
    url "https://files.pythonhosted.org/packages/b6/3e/c549370e95c9dc7ec5e155c075e2700fa75abe5625608a4ce5009eabe0bf/itemloaders-1.3.2.tar.gz"
    sha256 "4faf5b3abe83bf014476e3fd9ccf66867282971d9f1d4e96d9a61b60c3786770"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "parsel" do
    url "https://files.pythonhosted.org/packages/87/bd/b982085f091367ca25ccb61f2d127655a0daac1716ecfde014ab7c538116/parsel-1.9.1.tar.gz"
    sha256 "14e00dc07731c9030db620c195fcae884b5b4848e9f9c523c6119f708ccfa9ac"
  end

  resource "protego" do
    url "https://files.pythonhosted.org/packages/8a/12/cab9fa77ff4e9e444a5eb5480db4b4f872c03aa079145804aa054be377bc/Protego-0.3.1.tar.gz"
    sha256 "e94430d0d25cbbf239bc849d86c5e544fbde531fcccfa059953c7da344a1712c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pydispatcher" do
    url "https://files.pythonhosted.org/packages/21/db/030d0700ae90d2f9d52c2f3c1f864881e19cef8cba3b0a08759c8494c19c/PyDispatcher-2.0.7.tar.gz"
    sha256 "b777c6ad080dc1bad74a4c29d6a46914fa6701ac70f94b0d66fbcfde62f5be31"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "queuelib" do
    url "https://files.pythonhosted.org/packages/fb/a4/8af5d8ee3526c64a152549a1c7b42896be9fae9a2fda7712883dc09822ac/queuelib-1.7.0.tar.gz"
    sha256 "2855162096cf0230510890b354379ea1c0ff19d105d3147d349d2433bb222b08"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/38/d2/2ac20fd05f1b6fce31986536da4caeac51ed2e1bb25d4a7d73ca4eccdfab/service_identity-24.1.0.tar.gz"
    sha256 "6829c9d62fb832c2e1c435629b0a8c476e1929881f28bee4d20bc24161009221"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/db/ed/c92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739/tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/8b/bf/f30eb89bcd14a21a36b4cd3d96658432d4c590af3c24bbe08ea77fa7bbbb/twisted-24.7.0.tar.gz"
    sha256 "5a60147f044187a127ec7da96d170d49bcce50c6fd36f594e60f4587eff4d394"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "w3lib" do
    url "https://files.pythonhosted.org/packages/cc/dd/8d080c3bf19f4e853433193e0ffd894d9f5c5a55c11d7283038ee822a0db/w3lib-2.2.1.tar.gz"
    sha256 "756ff2d94c64e41c8d7c0c59fea12a5d0bc55e33a531c7988b4a163deb9b07dd"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/e4/1f/8bb0739aba9a8909bcfa2e12dc20443ebd5bd773b6796603f1a126211e18/zope_interface-7.1.0.tar.gz"
    sha256 "3f005869a1a05e368965adb2075f97f8ee9a26c61898a9e52a9764d93774f237"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrapy version")

    system bin/"scrapy", "startproject", "brewproject"
    cd testpath/"brewproject" do
      system bin/"scrapy", "genspider", "-t", "basic", "brewspider", "brew.sh"
      assert_match "INFO: Spider closed (finished)", shell_output("#{bin}/scrapy crawl brewspider 2>&1")
    end
  end
end
