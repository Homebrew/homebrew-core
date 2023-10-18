class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapcraft/archive/refs/tags/7.5.3.tar.gz"
  sha256 "3dd5cc59a2cb56e647e7906af7e2c9c01493d19c91132a8d0208a930449db650"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eac6e17d174da2b20875bb76cc30765fceb0545632815fa84d269b3719c8a28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d22c6fef49e9d81a0d00097de10c21177de5921a73b80cb8a325854454b13090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e2dda14ddbe75e38f5d619c457ea77795b15c9d95a78d3f2e987b1546d1dd48"
    sha256 cellar: :any_skip_relocation, sonoma:         "57f03b9e0f099ebb87d3caa9e111a8917824613bbfed86470c6047e4b931c70d"
    sha256 cellar: :any_skip_relocation, ventura:        "5c3a82b92020b3570d6c3e3245e2d61c335a330489deb42e0c9b215039f967d2"
    sha256 cellar: :any_skip_relocation, monterey:       "3e4f6aff92f657325e6a22f9db561bd3476d23ccb2a4bebc3795672dc41ff4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af2c59001b2f87573dc8abbbc2af25fb690b2a51d585905fe0947fbb346869c2"
  end

  depends_on "cffi"
  depends_on "libsodium"
  depends_on "lxc"
  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "snap"
  depends_on "xdelta"

  on_linux do
    depends_on "intltool" => :build # for python-distutils-extra
    depends_on "apt"
    depends_on "python-cryptography"

    # Extra non-PyPI Python resources
    # https://github.com/snapcore/snapcraft/blob/91a18b3128de4971edfc090a8683a64ff1679f2e/setup.py#L154-L158

    resource "python-distutils-extra" do
      url "https://deb.debian.org/debian/pool/main/p/python-distutils-extra/python-distutils-extra_2.50.tar.xz"
      sha256 "998cdd5ca3cfc7a1b4b5c2fdc571639264fe0f79193a16fe95a9b66df7ac56e1"
    end

    resource "python-apt" do
      url "https://ftp.debian.org/debian/pool/main/p/python-apt/python-apt_2.6.0.tar.xz"
      sha256 "557a705723f8acbb62c8af2989d0258dccb0a71f35e34aca53a9b492dbfbcfdd"
    end

    # Extra PyPI Python resources for Linux

    resource "chardet" do
      url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
      sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
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
      url "https://files.pythonhosted.org/packages/ce/8d/2ebc549adf1f623d4044b108b30ff5cdac5756b0384cd9dddac63fe53eae/python-debian-0.1.49.tar.gz"
      sha256 "8cf677a30dbcb4be7a99536c17e11308a827a4d22028dc59a67f6c6dd3f0f58c"
    end

    resource "secretstorage" do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end

    resource "ws4py" do
      url "https://files.pythonhosted.org/packages/53/20/4019a739b2eefe9282d3822ef6a225250af964b117356971bd55e274193c/ws4py-0.5.1.tar.gz"
      sha256 "29d073d7f2e006373e6a848b1d00951a1107eb81f3742952be905429dc5a5483"
    end
  end

  fails_with gcc: "5" # due to apt on Linux

  # Needs `setuptools<66`
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a1/29/f2ad3b78b9ebd24afa282eed9add27b47ef52b37291198021154b4b65166/setuptools-65.7.0.tar.gz"
    sha256 "4d3c92fac8f1118bb77a22181355e29c239cabfe2b9effdaa665c66b711136d7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "catkin-pkg" do
    url "https://files.pythonhosted.org/packages/b0/c3/c2f0de6be573b2209e229f7c65e54123f1a49a24e2d25698e5de05148a17/catkin_pkg-0.5.2.tar.gz"
    sha256 "5d643eeafbce4890fcceaf9db197eadf2ca5a187d25593f65b6e5c57935f5da2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/f6/66/90a253f7d787800902ec412c7b9e25f4a06d2593214ebc16da57d259d19b/craft-archives-1.1.3.tar.gz"
    sha256 "2efd153df09870c4d5e851e5bd05c6dc1824e973852b83c6218b97d2362035a5"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/90/8a/c6681a6faa465485a9bf6d3c7c038f2ccc187f1516b7cbc1668e66921b2d/craft-cli-2.0.1.tar.gz"
    sha256 "2d881e127df7de5bf6dc5a90eecd523c1da7f686456828f0e5ca6707e403ade4"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/96/d5/5fa68f1d0ce92c16e20c6b306370b2963cd74ba809441fb75951fe45e4a6/craft-grammar-1.1.1.tar.gz"
    sha256 "43af311206b5fcf9f6459250b7f498b3ad597ce222feed67b320317daa03639d"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/d9/b2/8fcd95496d441f85733bb3bd6dcce47636e89336119c6166988dc8896165/craft-parts-1.23.0.tar.gz"
    sha256 "32e286dad75f2cd369164353ffc356701396b3495dce0cc6d86e7501ec2f2128"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/e7/0d/5f7bc11fc6a839c553cb60462e0fd54b21c9adaf2c4ad8a37779c4327267/craft-providers-1.14.1.tar.gz"
    sha256 "9102e5511cc1e87ddb6a0c8a65eba4ccf249702cdb5d407bcaece4a7e6a81a90"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/2c/81/d1ef36c5bb5caece17c9361a8a9c45418286f13f74a25b9f60425e50e4cf/craft-store-2.4.0.tar.gz"
    sha256 "6813e32df00003df16cf17257619ef25e86d5933b3ede41615b3d48a768a18cf"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  # TODO: requires docutils<20, switch back to formula once unpinned
  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/14/c5/7a2a66489c66ee29562300ddc5be63636f70b4025a74df71466e62d929b1/keyring-24.2.0.tar.gz"
    sha256 "ca0746a19ec421219f4d713f848fa297a661a8a8c1504867e55bfb5e09091509"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/e1/61/cf604b4248ccb707c433f9905a8d18943667a1823cf4d3712bd5587db790/launchpadlib-1.11.0.tar.gz"
    sha256 "01898c937477b0c64a75338adb0977028d7346a8a019eb023cf68fed99850146"
  end

  resource "lazr-restfulclient" do
    url "https://files.pythonhosted.org/packages/88/e2/6b8b83d69aa06ae515a969320a8b8e371afa42b4226c03159641fc773c55/lazr.restfulclient-0.14.5.tar.gz"
    sha256 "0751717c7e74db1987e9a77335707d4d7d97cf04b1ad0898b822f12333d6887c"
  end

  resource "lazr-uri" do
    url "https://files.pythonhosted.org/packages/a6/db/310eaccd3639f5a8a6011c3133bb1cac7fd80bb46f8a50406df2966302e4/lazr.uri-1.0.6.tar.gz"
    sha256 "5026853fcbf6f91d5a6b11ea7860a641fe27b36d4172c731f4aa16b900cf8464"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/52/40/2a8bb2f507ce1a6c5b896c1b98044d74d34b07a6dd771526b4fe84e3181f/macaroonbakery-1.3.1.tar.gz"
    sha256 "23f38415341a1d04a155b4dac6730d3ad5f39b86ce07b1bb134bdda52b48b053"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2d/73/3557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99/more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/4d/27/30c865a1e62f1913a0730e667e94459ca038392b6f44d69ef7a585690337/overrides-7.4.0.tar.gz"
    sha256 "9502a3cca51f4fac40b5feca985b6703a5c1f6ad815588a7ca9e285b9dca6757"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/3b/9b/a7631bf35e55326fd74654fe6bd896478f47d65e97ca69e60ddb1b3823ee/pydantic-1.10.12.tar.gz"
    sha256 "0fe8a415cea8f340e7a9af9c54fc71a649b43e8ca3cc732986116b3cb135d303"
  end

  resource "pydantic-yaml" do
    url "https://files.pythonhosted.org/packages/9e/e7/30713a0fae04001f8886b0219cad667b0fbf56149f4ea3ee5a84e8e0c9e7/pydantic_yaml-0.11.2.tar.gz"
    sha256 "19c8f3c9a97041b0a3d8fc06ca5143ff71c0846c45b39fde719cfbc98be7a00c"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/0e/35/e76da824595452a5ad07f289ea1737ca0971fc6cc7b6ee9464279be06b5e/pyelftools-0.29.tar.gz"
    sha256 "ec761596aafa16e282a31de188737e5485552469ac63b60cfcccf22263fd24ff"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/c3/ea/0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354eb/requests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/c0/5c/61e2afbe62bbe2e328d4d1f426f6e39052b73eddca23b5ba524026561250/simplejson-3.19.1.tar.gz"
    sha256 "6277f60848a7d8319d27d2be767a7546bc965535b28070e310b3a9af90604a4c"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/50/2a/221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216/snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/30/0b/9e75a8d3333a6a3d9b36de04bf87a37a8d7f100035ea23c9c37bf0a112ab/tinydb-4.8.0.tar.gz"
    sha256 "6dd686a9c5a75dfa9280088fd79a419aefe19cd7f4bd85eba203540ef856d564"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "types-deprecated" do
    url "https://files.pythonhosted.org/packages/7f/43/6badee141c57e04c73d98cfee62a9b52aade5c4cacb87dbdcdb195ec6ff8/types-Deprecated-1.2.9.3.tar.gz"
    sha256 "ef87327adf3e3c4a4c7d8e06e58f6476710d3466ecfb53c49efb080804a70ef3"
  end

  resource "types-pyyaml" do
    url "https://files.pythonhosted.org/packages/04/c0/7358cce7f79f1b369ebbe57da67d5f538ea81ce5b9c97093121bfc973f09/types-PyYAML-6.0.12.11.tar.gz"
    sha256 "7d340b19ca28cddfdba438ee638cd4084bde213e501a3978738543e27094775b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/35/07/040cc4cc736cdf25873848bd4c717cc25e257196a7c11f42b3a09617a961/wadllib-1.3.6.tar.gz"
    sha256 "acd9ad6a2c1007d34ca208e1da6341bbca1804c0e6850f954db04bdd7666c5fc"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Allow building without git clone: https://github.com/snapcore/snapcraft/pull/4306
    inreplace "setup.py", "version=determine_version()", "version='#{version}'"

    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/snapcraft --version")

    assert_match "Package, distribute, and update snaps", shell_output("#{bin}/snapcraft --help 2>&1")

    system bin/"snapcraft", "init"
    assert_predicate testpath/"snap/snapcraft.yaml", :exist?
  end
end
