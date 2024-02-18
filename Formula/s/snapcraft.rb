class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapcraft/archive/refs/tags/8.0.2.tar.gz"
  sha256 "a2e4302c4a722e93c9f95d8fc6c3c6303546afd573cf1eb9d7ea6ea078923381"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb9e225d9ad3dcd206d6d6d7af6618afc08c220feb926837261329f4b8f98d94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a32145b428401fde3986934be018c158558e4ff61b7f3f276a3e4166308d7687"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48ed7ca26c56c72c257b1226106e5330f2f2b52706771b2c10a305ad46206d75"
    sha256 cellar: :any_skip_relocation, sonoma:         "192146537bbc7547b0eb6c79b1201f9511e1afa2fd4123f6e28ac03da8738af4"
    sha256 cellar: :any_skip_relocation, ventura:        "11b4e7bd8b2b816a3fd7d65fc199bfe66b25a0e43a8682d89a12edbd7c007450"
    sha256 cellar: :any_skip_relocation, monterey:       "02b2c82095732130c5c8f9e984d6cf8ff47f3da255784d6f45d8b0512dc8e397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e651ba0f849457f2492b82fdee3ab09a5e6c0bbb5088e3374d27caf3cc9d59ed"
  end

  depends_on "cffi"
  depends_on "libsodium"
  depends_on "lxc"
  depends_on "pygit2"
  depends_on "python-attrs"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python-requests"
  depends_on "python-tabulate"
  depends_on "python-toml"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
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

  resource "catkin-pkg" do
    url "https://files.pythonhosted.org/packages/2e/a2/88f8ba42a0119833887b8afe159f6e3ae96e2700720baf461eeabcc6acd8/catkin_pkg-1.0.0.tar.gz"
    sha256 "476e9f52917282f464739241b4bcaf5ebbfba9a7a68d9af8f875225feac0e1b5"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/f6/66/90a253f7d787800902ec412c7b9e25f4a06d2593214ebc16da57d259d19b/craft-archives-1.1.3.tar.gz"
    sha256 "2efd153df09870c4d5e851e5bd05c6dc1824e973852b83c6218b97d2362035a5"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/01/ea/db04e74eadf461d0326a43878844322abf4c572a3f9e3d090eb0f521303d/craft-cli-2.5.0.tar.gz"
    sha256 "f565847ef40c3295c066e9ff560b7fbeb532f7744640eec13474ee1c522a52d9"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/d7/2c/75f3dc538dae5f60e81fb5fb0c00b4b7bb7f0c29e4b8f76dcb4cc0541b28/craft-grammar-1.1.2.tar.gz"
    sha256 "3ecbb4417e7152048ebe4f04ef2ea07bdc4a2b6d185ffdea30a9239c307fdf3c"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/f5/de/7d7543d834a7b48a45c85f9e3ac4a240319ac116ebd739d500a1bc52221d/craft-parts-1.26.1.tar.gz"
    sha256 "b830c6a89d726e53da628235ea2274acbec9b67b1dac331f3144139a20436470"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/5d/08/002ca96723a68a7269c1dbd578623d79eff88943518295df0538c31fde49/craft-providers-1.20.1.tar.gz"
    sha256 "139e1a0f71814b9517c501253001382412d927be639556ff39a6e4abb85f06cf"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/ca/79/3f2fef793e78fe347964c012e988c739f68fbdf0d8a3c3f91e9e153b3ced/craft-store-2.6.0.tar.gz"
    sha256 "fb1ae34ccb6c525267bbaef1d91069b6c077924a706bf80ccc6652720497f609"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
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

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/b4/206081fca69171b4dc1939e77b378a7b87021b0f43ce07439d49d8ac5c84/importlib_metadata-7.0.1.tar.gz"
    sha256 "f238736bb06590ae52ac1fab06a3a9ef1d8dce2b7a35b5ab329371d6c8f5d2cc"
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
    url "https://files.pythonhosted.org/packages/69/cd/889c6569a7e5e9524bc1e423fd2badd967c4a5dcd670c04c2eff92a9d397/keyring-24.3.0.tar.gz"
    sha256 "e730ecffd309658a08ee82535a3b5ec4b4c8669a9be11efb66249d8e0aeb9a25"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/e1/61/cf604b4248ccb707c433f9905a8d18943667a1823cf4d3712bd5587db790/launchpadlib-1.11.0.tar.gz"
    sha256 "01898c937477b0c64a75338adb0977028d7346a8a019eb023cf68fed99850146"
  end

  resource "lazr-restfulclient" do
    url "https://files.pythonhosted.org/packages/ea/a3/45d80620a048c6f5d1acecbc244f00e65989914bca370a9179e3612aeec8/lazr.restfulclient-0.14.6.tar.gz"
    sha256 "43f12a1d3948463b1462038c47b429dcb5e42e0ba7f2e16511b02ba5d2adffdb"
  end

  resource "lazr-uri" do
    url "https://files.pythonhosted.org/packages/a6/db/310eaccd3639f5a8a6011c3133bb1cac7fd80bb46f8a50406df2966302e4/lazr.uri-1.0.6.tar.gz"
    sha256 "5026853fcbf6f91d5a6b11ea7860a641fe27b36d4172c731f4aa16b900cf8464"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/4b/ae/59f5ab870640bd43673b708e5f24aed592dc2673cc72caa49b0053b4af37/macaroonbakery-1.3.4.tar.gz"
    sha256 "41ca993a23e4f8ef2fe7723b5cd4a30c759735f1d5021e990770c8a0e0f33970"
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
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/51/cd/721eb771f3f09f60de0807e240c3acf44c38828d0ced869fe8df7e79801b/pydantic-1.10.13.tar.gz"
    sha256 "32c8b48dcd3b2ac4e78b0ba4af3a2c2eb6048cb75202f0ea7b34feb740efc340"
  end

  resource "pydantic-yaml" do
    url "https://files.pythonhosted.org/packages/9e/e7/30713a0fae04001f8886b0219cad667b0fbf56149f4ea3ee5a84e8e0c9e7/pydantic_yaml-0.11.2.tar.gz"
    sha256 "19c8f3c9a97041b0a3d8fc06ca5143ff71c0846c45b39fde719cfbc98be7a00c"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/84/05/fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8/pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
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
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/50/2a/221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216/snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/30/0b/9e75a8d3333a6a3d9b36de04bf87a37a8d7f100035ea23c9c37bf0a112ab/tinydb-4.8.0.tar.gz"
    sha256 "6dd686a9c5a75dfa9280088fd79a419aefe19cd7f4bd85eba203540ef856d564"
  end

  resource "types-deprecated" do
    url "https://files.pythonhosted.org/packages/7f/43/6badee141c57e04c73d98cfee62a9b52aade5c4cacb87dbdcdb195ec6ff8/types-Deprecated-1.2.9.3.tar.gz"
    sha256 "ef87327adf3e3c4a4c7d8e06e58f6476710d3466ecfb53c49efb080804a70ef3"
  end

  resource "types-pyyaml" do
    url "https://files.pythonhosted.org/packages/af/48/b3bbe63a129a80911b60f57929c5b243af909bc1c9590917434bca61a4a3/types-PyYAML-6.0.12.12.tar.gz"
    sha256 "334373d392fde0fdf95af5c3f1661885fa10c52167b14593eb856289e1855062"
  end

  # Requires urllib3<2, so cannot use python-urllib3 formula
  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/35/07/040cc4cc736cdf25873848bd4c717cc25e257196a7c11f42b3a09617a961/wadllib-1.3.6.tar.gz"
    sha256 "acd9ad6a2c1007d34ca208e1da6341bbca1804c0e6850f954db04bdd7666c5fc"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["SNAP_VERSION"] = version.to_s
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
