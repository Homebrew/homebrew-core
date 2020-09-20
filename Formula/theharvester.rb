class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/3.2.0.tar.gz"
  sha256 "872cb0d49ca61de259fa5e2743eb26d52154c1dacc974d1365894ab4abf1a1bd"
  license "GPL-2.0"
  head "https://github.com/laramies/theHarvester.git"

  bottle do
    cellar :any
    sha256 "46856f81e9b3e915c37f652886bd17f886fbc7d3c4fb25095a43a04b5b2a916c" => :catalina
    sha256 "ef8331534e766d52d242fe874e331baa3e563e366a8f5a2bae777024b38310fb" => :mojave
    sha256 "628cf264b4109d51f768dde76b59409a02d1d6167ce1843d30d9f0ef82016a65" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/30/2e/b86ce168485b68d40c6a810838669deacf0abf41845c383659c2b613e69f/aiodns-2.0.0.tar.gz"
    sha256 "815fdef4607474295d68da46978a54481dd1e7be153c7d60f9e72773cd38d77d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/00/94/f9fa18e8d7124d7850a5715a0b9c0584f7b9375d331d35e157cee50f27cc/aiohttp-3.6.2.tar.gz"
    sha256 "259ab809ff0727d0e834ac5e8a283dc5e3e0ecc30c4d80b3cd17a4139ce1f326"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/19/4c/3e879e97f27ec4f62c53f433d8a35066cd3dc85b5d44b91dd1204ea92875/aiomultiprocess-0.8.0.tar.gz"
    sha256 "c613ac39973bbf0ceeb2fdb296ca1ebf9e55d2e0f748f50ae3c116a8b05be01a"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/e5/ad/895551c693849649e32b4b89e624035cfbc5c8c751aa1ba4fb6877351adc/aiosqlite-0.15.0.tar.gz"
    sha256 "a2884793f4dc8f2798d90e1dfecb2b56a6d479cf039f7ec52356a7fd5f3bdc57"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/81/d0/641b698d05f0eaea4df4f9cebaff573d7a5276228ef6b7541240fe02f3ad/attrs-20.2.0.tar.gz"
    sha256 "26b54ddbbb9ee1d34d5d3668dd37d6cf74990ab23c828c2888dccdceee395594"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c6/62/8a2bef01214eeaa5a4489eca7104e152968729512ee33cb5fbbc37a896b7/beautifulsoup4-4.9.1.tar.gz"
    sha256 "73cc4d115b96f79c7d77c1c7f7a0a8d4c57860d1041df407dd1aae7f07a77fd7"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/f7/09/88bbe20b76ca76be052c366fe77aa5e3cd6e5f932766e5597fecdd95b2a8/cffi-1.14.2.tar.gz"
    sha256 "ae8f34d50af2c2154035984b8b5fc5d9ed63f32fe615646ab435b05b132ca91b"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/67/d0/639a9b5273103a18c5c68a7a9fc02b01cffa3403e72d553acec444f85d5b/dnspython-2.0.0.zip"
    sha256 "044af09374469c3a39eeea1a146e8cac27daec951f1f1f157b1962fc7cb9d1b7"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2c/4d/3ec1ea8512a7fbf57f02dee3035e2cce2d63d0e9c0ab8e4e376e01452597/lxml-4.5.2.tar.gz"
    sha256 "cdc13a1682b2a6241080745b1953719e7fe0850b40a5c71ca574f090a1391df6"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/65/d4/fabdcc5ee4451c8a8e177e27ddfd131a53a82ecc5a3b68468b7e9f8d70b4/multidict-4.7.6.tar.gz"
    sha256 "fbb77a75e529021e7c4a8d4e823d88ef4d23674a202be4f5addffc72cbb91430"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/9c/17/70a5e918c75eaadf08a6acaef34fe9444a0f840be7c82003e64295b42498/plotly-4.9.0.tar.gz"
    sha256 "257f530ffd73754bd008454826905657b329053364597479bb9774437a396837"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/4e/09/f49ef1c4b6a5ad50fc08a8acd015f1938594dd7a6b4a6a96d049d9bbec7d/pycares-3.1.1.tar.gz"
    sha256 "18dfd4fd300f570d6c4536c1d987b7b7673b2a9d14346592c5d6ed716df0d104"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/03/b1/95414fbe485cead3836b4638f6df51a2ca5a4292d83f9c0b97628c17e291/pyee-7.0.3.tar.gz"
    sha256 "30c3e90bb44311af98e0958cae7c5a3acbbfb35b0ec87f7fa1275ba9e12e31f3"
  end

  resource "pyppeteer" do
    url "https://files.pythonhosted.org/packages/7c/c1/6768716f8bf2e179f963d5c92a5aeadf31ca0505c40978a6b4a567d21b8a/pyppeteer-0.2.2.tar.gz"
    sha256 "153c62666fe1d55b3941d1634733c02cafb47188fcf282987371e863d58f22e9"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/d7/ad/cbb190678927bd5840ab75306319ea62f10e2c384bc1bc19d10f2765d278/shodan-1.23.1.tar.gz"
    sha256 "d2d37d47dd084747df672e6d981f6d72d5d03f4ee12f0ce2170e618147578349"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3e/db/5ba900920642414333bdc3cb397075381d63eafc7e75c2373bbc560a9fa1/soupsieve-2.0.1.tar.gz"
    sha256 "a59dc181727e95d25f781f0eb4fd1825ff45590ec8ff49eadfd7f1a537cc0232"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/f5/be/716342325d6d6e05608e3a10e15f192f3723e454a25ce14bc9b9d1332772/texttable-1.6.3.tar.gz"
    sha256 "ce0faf21aa77d806bbff22b107cc22cce68dc9438f97a2df32c93e9afa4ce436"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/bc/03/2bc607a15e201058cb6b19784b9c217d7ff37a686ce4a2d8a37a638f3ba5/tqdm-4.49.0.tar.gz"
    sha256 "faf9c671bd3fad5ebaeee366949d969dca2b2be32c872a7092a1e1a9048d105b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/84/2e/462e7a25b787d2b40cf6c9864a9e702f358349fc9cfb77e83c38acb73048/uvloop-0.14.0.tar.gz"
    sha256 "123ac9c0c7dd71464f58f1b4ee0bbd81285d96cdda8bc3519281b8973e3a461e"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/e9/2b/cf738670bb96eb25cb2caf5294e38a9dc3891a6bcd8e3a51770dbc517c65/websockets-8.1.tar.gz"
    sha256 "5c65d2da8c6bce0fca2528f69f44b2f977e06954c8512a952222cea50dad430f"
  end

  resource "XlsxWriter" do
    url "https://files.pythonhosted.org/packages/35/44/32fd56d8d2350b72bd75ad45699a189ef4b6bc0d732931bae2b0228e145c/XlsxWriter-1.3.4.tar.gz"
    sha256 "d804881beb944c4fd73deed0ef2666b84437f30d72bdc1b3a6f0230458facbfd"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/ac/dd/59768bb3fa08e8b23e91575bca3ff8d2edbfbceebec8c59eaa24c4215791/yarl-1.5.1.tar.gz"
    sha256 "c22c75b5f394f3d47105045ea551e08a3e804dc7e01b37800ca35b58f856c3d6"
  end

  def install
    venv = virtualenv_create(libexec/"venv", "python3")
    venv.pip_install resources

    libexec.install Dir["*"]
    (libexec/"theHarvester.py").chmod 0755
    (bin/"theharvester").write_env_script("#{libexec}/theHarvester.py", PATH: "#{libexec}/venv/bin:$PATH")
  end

  test do
    output = shell_output("#{bin}/theharvester -d brew.sh -l 1 -b google 2>&1")
    assert_match "docs.brew.sh:", output
  end
end
