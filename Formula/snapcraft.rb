class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapcraft.git",
      tag:      "7.1.4",
      revision: "725d3935aad23331087328f2c65ea3d112a7db4f"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c31bb7dfe683eab63858210242499d9d399dbc6cbd94bbd8c92b6edb20d137c8"
    sha256 cellar: :any,                 arm64_big_sur:  "04b966aab6268f5eddfcf7219cf0ac7c97c6e6e68a3ba31cfaa1113e232b2f45"
    sha256 cellar: :any,                 monterey:       "f9270eca501e6fd6338a2c09b37e14b3a611a3456f6fc1fbf389c6b00878dd64"
    sha256 cellar: :any,                 big_sur:        "5ec15fa2f8c492b6c7f591da45925780fbc07dc35c646d308b9fe832d1c0bed8"
    sha256 cellar: :any,                 catalina:       "d575f7ae45da3968ac0a0301d9a065622fdce929f68e1233e88f0f63e02140a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41154fc57b6ff5d1fb22f3e2435d61e8f09bb32c0f695efd363a83c5b4aef882"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "libpython-tabulate"
  depends_on "libsodium"
  depends_on "lxc"
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "snap"
  depends_on "xdelta"

  uses_from_macos "libxml2" # for lxml
  uses_from_macos "libxslt" # for lxml

  on_linux do
    depends_on "intltool" => :build # for python-distutils-extra
    depends_on "apt"

    # Extra non-PyPI Python resources

    resource "python-distutils-extra" do
      url "https://deb.debian.org/debian/pool/main/p/python-distutils-extra/python-distutils-extra_2.45.tar.xz"
      sha256 "9db7e00e609a762ac5541532816aa028475cb715a8be8ee8d615a5ab63dd7344"
    end

    resource "python-apt" do
      url "https://ftp.debian.org/debian/pool/main/p/python-apt/python-apt_2.2.1.tar.xz"
      sha256 "b9336cc92dc0a3bcc7be05b40f6752d10220cc968b19061f6c7fc12bf22a97f2"
    end

    # Extra PyPI Python resources for Linux

    resource "chardet" do
      url "https://files.pythonhosted.org/packages/31/a2/12c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205/chardet-5.0.0.tar.gz"
      sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
    end

    resource "jeepney" do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "pylxd" do
      url "https://files.pythonhosted.org/packages/26/13/cd06edfccf667c348022b72c5177f127129a51de64d115b766decd2890e2/pylxd-2.3.1.tar.gz"
      sha256 "556a2127d51dd8d1559989cb8257183910d397156f5ebe59fe4f6289ea014154"
    end

    resource "python-debian" do
      url "https://files.pythonhosted.org/packages/52/1e/971d6fc2f9da72155314b3130643198e4f0c029f6e8a8ae040a45e072d44/python-debian-0.1.44.tar.gz"
      sha256 "65592fe3b64f6c6c93d94e2d2599db5e0c22831d3bcff07cb7b96d3840b1333e"
    end

    resource "secretstorage" do
      url "https://files.pythonhosted.org/packages/bc/3b/6e294fcaa5aed4059f2aa01a1ee7d343953521f8e0f6965ebcf63c950269/SecretStorage-3.3.2.tar.gz"
      sha256 "0a8eb9645b320881c222e827c26f4cfcf55363e8b374a021981ef886657a912f"
    end

    resource "ws4py" do
      url "https://files.pythonhosted.org/packages/53/20/4019a739b2eefe9282d3822ef6a225250af964b117356971bd55e274193c/ws4py-0.5.1.tar.gz"
      sha256 "29d073d7f2e006373e6a848b1d00951a1107eb81f3742952be905429dc5a5483"
    end
  end

  fails_with gcc: "5" # due to apt on Linux

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "catkin-pkg" do
    url "https://files.pythonhosted.org/packages/b0/c3/c2f0de6be573b2209e229f7c65e54123f1a49a24e2d25698e5de05148a17/catkin_pkg-0.5.2.tar.gz"
    sha256 "5d643eeafbce4890fcceaf9db197eadf2ca5a187d25593f65b6e5c57935f5da2"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/90/c2/4e37394b66e7211ad120f216fc2e8b38d4f43b89c8100dd3917c9da9bfc6/certifi-2022.6.15.1.tar.gz"
    sha256 "cffdcd380919da6137f76633531a5817e3a9f268575c128249fb637e4f9e73fb"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/27/79/084746d656a483b8a58aca7e9d8db536208018ce0860d04c8a53f5b2c969/craft-cli-1.2.0.tar.gz"
    sha256 "fb71127ccbc9da0a37e4d08824d44a14079935d94a8382dd158a0250ec125795"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/96/d5/5fa68f1d0ce92c16e20c6b306370b2963cd74ba809441fb75951fe45e4a6/craft-grammar-1.1.1.tar.gz"
    sha256 "43af311206b5fcf9f6459250b7f498b3ad597ce222feed67b320317daa03639d"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/5d/e2/42dcd7ab15161140fdce137ca03a1c4ed72ac8da73359302140f8524f45d/craft-parts-1.14.0.tar.gz"
    sha256 "cb682a9c7bd954277c68fcff50e13ae719106359e92f0a2120474106106713b4"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/38/d9/c42d56151e1e68ad61926536c096b44a2e1260c7f218ab53ed6da3d354e3/craft-providers-1.4.2.tar.gz"
    sha256 "01f27f2abf05477f0814551cc85c49db18c5ae620f065dfecfc0fd2ebbc85555"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/5b/39/4bf5d225415cb04149e1cbb2bace97c7b352edabe45e301cca7b53b3e94c/craft-store-2.2.1.tar.gz"
    sha256 "9b92294d8205ec18db16150e6d3b333851fdadf583e4085c5f6584cbc31ad701"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ea/d8/2afd2890fe451a3c109d2bdb6bc4ded55ec43059e524344d5e0004e36412/cryptography-3.4.tar.gz"
    sha256 "9f7aa11ea95723359f914be3217d8b378bc3897f65a1ec1ab4e0118c336f51fc"
  end

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/c8/d1/e412abc2a358a6b9334250629565fe12697ca1cdee4826239eddf944ddd0/Deprecated-1.2.13.tar.gz"
    sha256 "43ac5335da90c31c24ba028af536a91d41d53f9e6901ddb021bcc572ce44e38d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/b5/7e/ddfbd640ac9a82e60718558a3de7d5988a7d4648385cf00318f60a8b073a/distro-1.7.0.tar.gz"
    sha256 "151aeccf60c216402932b52e40ee477a939f8d58898927378a02abbe852c1c39"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/9c/65/57ad964eb8d45cc3d1316ce5ada2632f74e35863a0e57a52398416a182a1/httplib2-0.20.4.tar.gz"
    sha256 "58a98e45b4b1a48273073f905d2961666ecf0fbac4250ea5b47aef259eb5c585"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/fe/8b/7876fbd69f5a8ebfbda73c8c1a5346171ee5ac0db28e9f5b2bb80ee3e73b/jaraco.classes-3.2.2.tar.gz"
    sha256 "6745f113b0b588239ceb49532aa09c3ebb947433ce311ef2f8e3ad64ebb74594"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/99/00/072e2e03d32286c12b963a236f41040a528316a5a5c2fac6ff4029c85386/keyring-23.9.1.tar.gz"
    sha256 "39e4f6572238d2615a82fcaa485e608b84b503cf080dc924c43bbbacb11c1c18"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/c6/ab/d660df8b1678aed8e1fe6469f4aa771dccb124fb2891f38746615c93b35b/launchpadlib-1.10.16.tar.gz"
    sha256 "0df4b13936f988afd0ee485f40fa6922eab783b48c38ca0108cb73c8788fca80"
  end

  resource "lazr.restfulclient" do
    url "https://files.pythonhosted.org/packages/c9/3b/610cd97c0db307bdf04812261ede0c5fefb7dd67470346f89e99083625d5/lazr.restfulclient-0.14.4.tar.gz"
    sha256 "bf0fd6b2749b3a2d02711f854c9d23704756f7afed21fb5d5b9809d72aa6d087"
  end

  resource "lazr.uri" do
    url "https://files.pythonhosted.org/packages/a6/db/310eaccd3639f5a8a6011c3133bb1cac7fd80bb46f8a50406df2966302e4/lazr.uri-1.0.6.tar.gz"
    sha256 "5026853fcbf6f91d5a6b11ea7860a641fe27b36d4172c731f4aa16b900cf8464"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/52/40/2a8bb2f507ce1a6c5b896c1b98044d74d34b07a6dd771526b4fe84e3181f/macaroonbakery-1.3.1.tar.gz"
    sha256 "23f38415341a1d04a155b4dac6730d3ad5f39b86ce07b1bb134bdda52b48b053"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/c7/0c/fad24ca2c9283abc45a32b3bfc2a247376795683449f595ff1280c171396/more-itertools-8.14.0.tar.gz"
    sha256 "c09443cd3d5438b8dafccd867a6bc1cb0894389e90cb53d227456b0b0bccb750"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fe/58/30a4d3302f9bbd602c43385e7270fc3a9e8a665d07aafd6a4d4baa844739/oauthlib-3.2.1.tar.gz"
    sha256 "1565237372795bf6ee3e5aba5e2a85bd5a65d0e2aa5c628b9a97b7d7a0da3721"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/91/61/79f6f13e322f0093a7fc1ae99fef15236f43589373beee5982bfd0b69fa9/overrides-6.2.0.tar.gz"
    sha256 "e15c1a7d9a605999507a5e17d36505319f9e971cbcbde37b507c84346318301b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/96/1283259c25bc48a6df98fa096f66fc568b40137b93806ef5ff66a2d166b1/protobuf-3.20.1.tar.gz"
    sha256 "adc31566d027f45efe3f44eeb5b1f329da43891634d61c75a5944e9be6dd42c9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/8f/57/828ac1f70badc691a716e77bfae258ef5db76bb7830109bf4bcf882de020/psutil-5.9.2.tar.gz"
    sha256 "feb861a10b6c3bb00701063b37e4afc754f8217f0f09c42280586bd6ac712b5c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/60/a3/23a8a9378ff06853bda6527a39fe317b088d760adf41cf70fc0f6110e485/pydantic-1.9.0.tar.gz"
    sha256 "742645059757a56ecd886faf4ed2441b9c0cd406079c2b4bee51bcc3fbcd510a"
  end

  resource "pydantic-yaml" do
    url "https://files.pythonhosted.org/packages/ea/06/e16bb162a9edbf15c1a821528c107f25e8434dd4a9f5261c43c20ccac7c5/pydantic_yaml-0.8.0.tar.gz"
    sha256 "324d75c84c068f64fefd5910967a83735231296c8eaba0dd48d721b7eccae8db"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/0e/35/e76da824595452a5ad07f289ea1737ca0971fc6cc7b6ee9464279be06b5e/pyelftools-0.29.tar.gz"
    sha256 "ec761596aafa16e282a31de188737e5485552469ac63b60cfcccf22263fd24ff"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/24/0c/401283bb1499768e33ddd2e1a35817c775405c1f047a9dc088a29ce2ea5d/pytz-2022.2.1.tar.gz"
    sha256 "cea221417204f2d1a2aa03ddae3e867921971d0d76f14d87abb4414415bbdcf5"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/c3/ea/0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354eb/requests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/dc/20/0b16eb0dd28c3ec6fccef77230b11e4b9ec94aa7ade1c99b1ab66d237fbe/setuptools-rust-1.5.1.tar.gz"
    sha256 "0e05e456645d59429cb1021370aede73c0760e9360bbfdaaefb5bced530eb9d7"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/7a/47/c7cc3d4ed15f09917838a2fb4e1759eafb6d2f37ebf7043af984d8b36cf7/simplejson-3.17.6.tar.gz"
    sha256 "cf98038d2abf63a1ada5730e91e84c642ba6c225b0198c3684151b1f80c5f8a6"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/77/b3/2ab727ab4062800731c2e4d773358c6c25f8d630affa3e3ccdb21dc40d68/tinydb-4.7.0.tar.gz"
    sha256 "357eb7383dee6915f17b00596ec6dd2a890f3117bf52be28a4c516aeee581100"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "types-Deprecated" do
    url "https://files.pythonhosted.org/packages/45/2f/c0e57815699277d3ecb3cc974c4ffee0afc37a593437328766a42a525dd2/types-Deprecated-1.2.9.tar.gz"
    sha256 "e04ce58929509865359e91dcc38720123262b4cd68fa2a8a90312d50390bb6fa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/35/07/040cc4cc736cdf25873848bd4c717cc25e257196a7c11f42b3a09617a961/wadllib-1.3.6.tar.gz"
    sha256 "acd9ad6a2c1007d34ca208e1da6341bbca1804c0e6850f954db04bdd7666c5fc"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "open3"

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/snapcraft --version")

    # `--help` goes to stderr, not stdout, so we can't use `shell_output`
    ohai "#{bin}/snapcraft --help"
    Open3.popen3("#{bin}/snapcraft --help") do |_stdin, _stdout, stderr, _wait_thr|
      assert_match "Package, distribute, and update snaps for Linux and IoT", stderr.read
    end

    system bin/"snapcraft", "init"
    assert_predicate testpath/"snap/snapcraft.yaml", :exist?
  end
end
