class Streamrip < Formula
  include Language::Python::Virtualenv

  desc "Scriptable music downloader for Qobuz, Tidal, SoundCloud, and Deezer"
  homepage "https://github.com/nathom/streamrip"
  url "https://files.pythonhosted.org/packages/b8/c9/6997772e0217f3081e4e692c7b8b104aaa564c008f2593341e81bbbd2396/streamrip-2.1.0.tar.gz"
  sha256 "e59b4b406f9ac77eb59c927a1a082644e0902152ffeb6212b6b24af7fbef5540"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc43b88cf3e6fab16674a3157386e59054916ebeb3291af3549558989ff1e0ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9adb78ebddc9db5f53686d1332ca5c470159dcef0e902750d311ee4d26463cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e8b3dd41ee4b7246f56c4a3b1202aae48c0a11ffaee002b55af489bfa7544dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ce4a6941424de9d6be471066d6c8f86bb5e7176a566da47a383db10e7f6cb2"
    sha256 cellar: :any_skip_relocation, ventura:       "4d589f63d64adf41bbc0598ce57c191680685e047bc0b5d88a456505ef0d1211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51b54fdaeedffa13d71fd0f32bb5b854ef94bfc8d7baa45ffe6761d17dd97620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb7e08e0592589b8e3cb18f94e5010f894d49a48894da027a35e851c8e780086"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "pillow"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/92/9b/e96226eed7568ddfd075b03695e3e1298d9de48724128a3a2957f5ee6ec8/aiodns-3.4.0.tar.gz"
    sha256 "24b0ae58410530367f21234d0c848e4de52c1f16fbddc111726a4ab536ec1b2f"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/06/f0/af90f3fb4066b0707b6a5af3ffd5fd9b3809bbb52f0153a3c7550e594de3/aiofiles-0.7.0.tar.gz"
    sha256 "a1c4fc9b2ff81568c83e21392a82f344ea9d23da906e4f6a52662764545e19d4"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/f2/84/ea27e6ad14747d8c51afe201fb88a5c8282b6278256d30a6f71f730add88/aiohttp-3.12.12.tar.gz"
    sha256 "05875595d2483d96cb61fa9f64e75262d7ac6251a7e3c811d8e26f7d721760bd"
  end

  resource "aiolimiter" do
    url "https://files.pythonhosted.org/packages/f1/23/b52debf471f7a1e42e362d959a3982bdcb4fe13a5d46e63d28868807a79c/aiolimiter-1.2.1.tar.gz"
    sha256 "e02a37ea1a855d9e832252a105420ad4d15011505512a1a1d814647451b5cca9"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ba/b5/6d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473d/aiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "click-help-colors" do
    url "https://files.pythonhosted.org/packages/6f/50/76f51d9c7fcd72a12da466801f7c1fa3884424c947787333c74327b4fcf3/click-help-colors-0.9.4.tar.gz"
    sha256 "f4cabe52cf550299b8888f4f2ee4c5f359ac27e33bcfe4d61db47785a5cc936c"
  end

  resource "deezer-py" do
    url "https://files.pythonhosted.org/packages/97/4e/18a8530aaed95350a34923556c68691e58440532495be9f4cd2ed684819d/deezer-py-1.3.6.tar.gz"
    sha256 "a3ef151f7971d69769e7393f71373eaf896bccd22167213872ae46e04e14a2d7"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/f2/97/ebf4da567aa6827c909642694d71c9fcf53e5b504f2d96afea02718862f3/iniconfig-2.1.0.tar.gz"
    sha256 "3abbd2e30b36733fee78f9c7f7308f2d0050e88f0087fd25c2645f63c773e1c7"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/f4/1f/6370b6c5ba1975f5299bdda0e953e381880accbad1d2daa8fb0da3548051/m3u8-0.9.0.tar.gz"
    sha256 "3ee058855c430dc364db6b8026269d2b4c1894b198bcc5c824039c551c05f497"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/91/2f/a3470242707058fe856fe59241eee5635d79087100b7042a867368863a27/multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/60/f7/ff244fdd8ed98e98d4f9acecfe74a890e5e3245ce55253ef88db51e94652/pathvalidate-2.5.2.tar.gz"
    sha256 "5ff57d0fabe5ecb7a4f1e4957bfeb5ad8ab5ab4c0fa71f79c6bbc24bd9b7d14d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/19/7a/01ef7ce35fc1312d6c1c07f3b87f329ad6daf41bb9cd57c8f017e0b653fa/pycares-4.8.0.tar.gz"
    sha256 "2fc2ebfab960f654b3e3cf08a732486950da99393a657f8b44618ad3ed2d39c1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/fb/aa/405082ce2749be5398045152251ac69c0f3578c7077efc53431303af97ce/pytest-8.4.0.tar.gz"
    sha256 "14d920b48472ea0dbf68e45b96cd1ffda4705f33307dcc86c676c1b5104838a6"
  end

  resource "pytest-asyncio" do
    url "https://files.pythonhosted.org/packages/ae/53/57663d99acaac2fcdafdc697e52a9b1b7d6fcf36616281ff9768a44e7ff3/pytest_asyncio-0.21.2.tar.gz"
    sha256 "d67738fc232b94b326b9d060750beb16e0074210b98dd8b58a5239fa2a154f45"
  end

  resource "pytest-mock" do
    url "https://files.pythonhosted.org/packages/71/28/67172c96ba684058a4d24ffe144d64783d2a270d0af0d9e792737bddc75c/pytest_mock-3.14.1.tar.gz"
    sha256 "159e9edac4c451ce77a5cdb9fc5d1100708d2dd4ba3c3df572f14097351af80e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/d8/80/f0f10b4045628645a841d3d98b584a8699005ee03a211fc7c45f6c6f0e99/simple_term_menu-1.6.6.tar.gz"
    sha256 "9813d36f5749d62d200a5599b1ec88469c71378312adc084c00c00bfbb383893"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/65/ed/7b7216101bc48627b630693b03392f33827901b81d4e1360a76515e3abc4/tomlkit-0.7.2.tar.gz"
    sha256 "d7a454f319a7e9bd2e249f239168729327e4dd2d27b17dc68be264ad1ce36754"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    system bin/"rip", "url", "https://soundcloud.com/radiarc/radiarc-irrelevance-fading"
  end
end
