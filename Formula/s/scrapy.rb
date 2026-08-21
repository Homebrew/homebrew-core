class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https://scrapy.org"
  url "https://files.pythonhosted.org/packages/4a/ab/4c0ece9b5fed5dd2fe5f88e4eca662d1f2292a95293e074da56dd31922be/scrapy-2.18.0.tar.gz"
  sha256 "2445f8b5bf87ba105d239cb230878646e29dbc6a6cae10037ba0550d8fe7fc73"
  license "BSD-3-Clause"
  head "https://github.com/scrapy/scrapy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb02bdb8164b1f9c689b3d78dd540c3256e89374dd04c7a0bd4b273d5aad22e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b4424672f38e1f9a18b53fb406c5d31422b808547ca78996dfb00f2b0b0ce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "602c131f081dcb64e06a4de6a6824863e57a1edeedbdb9e3db393b245b8284e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ba5fb943cd20b1ba9499d7693c05ab128619b506af3e3769e54ab87b108efa"
    sha256 cellar: :any,                 arm64_linux:   "ea3fe0e090fd5c367288ddd14b4e03e60efe219f0688e10d4823c5957af933e4"
    sha256 cellar: :any,                 x86_64_linux:  "5e823a49037ea64d2ae28ac3e864f4ace3ed279ae0278ac40f992a6809ee240e"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/e3/0f/d40bbe294bbf004d436a8bcbcfaadca8b5140d39ad0ad3d73d1a8ba15f14/automat-25.4.16.tar.gz"
    sha256 "0017591a5477066e90d26b0e696ddc143baafd87b588cfac8100bc6be9634de0"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/8e/5a/6d6fcf922709391fac986f0a03ad4546f4f45b94d10aeb6c1ee041599993/cssselect-1.5.0.tar.gz"
    sha256 "3cbe82dd7acbee9ba9e5723b5f9e4749826912f1fb31cd7f92aabed5fde15b15"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/7d/64/a02e6765de08964ed371eca577870593245afc9dfac16d037de7c10d18e6/filelock-3.32.3.tar.gz"
    sha256 "0ffa185a3540854c95caa7fa76b76cb219d907415e2c5dc9af25fd970563487f"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/ef/3c/82e84109e02c492f382c711c58a3dd91badda6d746def81a1465f74dc9f5/incremental-24.11.0.tar.gz"
    sha256 "87d3480dbb083c1d736222511a8cf380012a8176c2456d01ef483242abbbcf8c"
  end

  resource "itemadapter" do
    url "https://files.pythonhosted.org/packages/52/47/4c75c5396941e653d5f864389964da6951e8f338c6739602dd778f62333e/itemadapter-0.13.1.tar.gz"
    sha256 "fa139c7be2aa80f8874b2f23d165d5d4aa47c4b85c54ab530b567fd5f684f1b4"
  end

  resource "itemloaders" do
    url "https://files.pythonhosted.org/packages/05/bd/916f4fd26e14e6ad292b69693ccca4f192bcaf9f817ba7d6f7162dbbd835/itemloaders-1.4.0.tar.gz"
    sha256 "b5338308a819098f43525b7afc5f7d46ba338ba4710f5ebe7a21b3b47bb29929"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ad/a9/970b8fa0ecc4fbf1dfaed0d89bbc1fc1421b25ec26a2038c91e872dc6c8e/lxml-6.1.2.tar.gz"
    sha256 "1055241852f2b02068af4a625a5d32c087db193c12251928af2562ecd2239f18"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "parsel" do
    url "https://files.pythonhosted.org/packages/91/c8/4ace3a5c61e39ca21734a5715d0e076eea6200dd8daea2a5b99452f5a0d6/parsel-1.11.0.tar.gz"
    sha256 "5925fe087eb16fc404a7ed91e31e2c1e2a9b230da4b64f34d81358c0d0e27e88"
  end

  resource "protego" do
    url "https://files.pythonhosted.org/packages/7d/1b/6b0ee60bb1561843bfc62f5c7c3cb1ef6147b47e829a5fd6b7fcd2752471/protego-0.6.2.tar.gz"
    sha256 "88ff004544ce44e61269cc6f8735f7837d12e09bb77619fc94fbb26b72e5d137"
  end

  resource "pydispatcher" do
    url "https://files.pythonhosted.org/packages/21/db/030d0700ae90d2f9d52c2f3c1f864881e19cef8cba3b0a08759c8494c19c/PyDispatcher-2.0.7.tar.gz"
    sha256 "b777c6ad080dc1bad74a4c29d6a46914fa6701ac70f94b0d66fbcfde62f5be31"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "queuelib" do
    url "https://files.pythonhosted.org/packages/76/f3/d80ab8c7c91b8c42d9a2aa4dd97a8be1321e7b26000c2675b75e641d958c/queuelib-1.9.0.tar.gz"
    sha256 "b12fea79fd8c1dd23e212b1f3db58003b773949801d4f4e6f34d882467d4a192"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/61/87/ad52e2c582c0f0e7f0a1b86950494c38d67422dc0f5ed9044a5fb9569a49/service_identity-26.1.0.tar.gz"
    sha256 "6358c52882c96e66ac4a55eb3a72c7dd4a70763f8cc6fa4e70abde2656f4bf3b"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/01/a9/ed5d3be29bfaf90c00b7159d3884b311f3880b55833d1c7be764164dc288/tldextract-5.3.2.tar.gz"
    sha256 "c017431bc0800f2d3d1b57cce36e06668f0930f60a6d8c4615d4e2b8da298fa9"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/db/97/6e9beb1e78247ae6dc34114f27d538cf2cb183c4afcd3609dfdf2b0439c8/twisted-26.4.0.tar.gz"
    sha256 "dbfd0fe1ee409d0243fdd7a6a6ff14f4948cec1fd78e0376291f805e1501fae9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "w3lib" do
    url "https://files.pythonhosted.org/packages/c0/91/b2eb59c2cf243de5de1e91c963655df78c015509f51297685a8c86a27b8c/w3lib-2.4.1.tar.gz"
    sha256 "8dd69ee39ff6398d708c793abc779c334a69bac7cee1cdf71736c669ed6be864"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/26/39/a8481b926e42c44a6fcc670904f8251469ec42edbff1ba066719ca1e7fb4/zope_interface-8.6.tar.gz"
    sha256 "b40ef9b4873afb5d0dec02b8d2dfde1cf18c72337b60c99cb735961e0bac05c0"
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
