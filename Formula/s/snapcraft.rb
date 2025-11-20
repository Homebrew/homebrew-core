class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  # Use git checkout so setuptools-scm and update-python-resources works
  url "https://github.com/canonical/snapcraft.git",
      tag:      "8.12.0",
      revision: "17ec09c928ce22e606dc0bc6be83483f6c2e52c3"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/canonical/snapcraft.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "72f0f485d32a3109b5b3c85fb94a5bab83342cb11b9fbe4a2957d94302f9d04f"
    sha256 cellar: :any,                 arm64_sequoia: "05a4a4c2c97670734bfb299a49bf900626262ad78405a4e4899415488acbf1df"
    sha256 cellar: :any,                 arm64_sonoma:  "1431c00a290a9f972fa2190234ad06c91c7fef51d418c5b8804fbefd9d6b7b73"
    sha256 cellar: :any,                 sonoma:        "118bb7ebce8c8d8181a88eb0f994aff1970df1751a661bcd6b7ee523205f8e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5742539b314ad5f0beb5e2f459db71ff78b6aaa91bf733cf31fc51933737d49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c7597af39bb397715b49d131edfbf77e721f17799b35a521cd5716ff4457f51"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "pydantic" => :no_linkage
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.14"
  depends_on "snap"
  depends_on "xdelta"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "intltool" => :build # for python-distutils-extra
    depends_on "apt"
    depends_on "cryptography"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pydantic pygit2],
                extra_packages:   %w[catkin-pkg jeepney pylxd secretstorage]

  # We hit a build failure with requested 2.4.0ubuntu1 tarball so just using latest Debian
  resource "python-apt" do
    on_linux do
      url "https://deb.debian.org/debian/pool/main/p/python-apt/python-apt_3.0.0.tar.xz"
      sha256 "1963720a75b6916bf59c71e75ac4577b9dd51666030f11990f2f56cb31af115f"
    end
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "catkin-pkg" do
    url "https://files.pythonhosted.org/packages/1c/7a/dcd7ba56dc82d88b3059a6770828388fc2e136ca4c5d79003f9febf33087/catkin_pkg-1.1.0.tar.gz"
    sha256 "df1cb6879a3a772e770a100a6613ce8fc508b4855e5b2790106ddad4a8beb43c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "craft-application" do
    url "https://files.pythonhosted.org/packages/ca/a3/6e487bb73f3b74eee8a38691510796b7326211d4981547c0ed45d0325aee/craft_application-5.8.0.tar.gz"
    sha256 "0d01b9792535b3dad51f3501f0f476daa3936b8b3c68ba8274f20cf5c25fd184"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/41/4c/63ce5d6c91b4b269f862460392bd70fd0594f7902641b5d0bc82aa3f1c41/craft_archives-2.2.0.tar.gz"
    sha256 "0bfd6dc3c2710605b97292df952032af24bf94ebf2f284f355d70f1bb2e3fe20"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/35/0a/f1612fe57295b6a69ff256dbd0826b90f70b27dda90988f972fa6f8968cc/craft_cli-3.2.0.tar.gz"
    sha256 "557345bf1d82e93d6525f35837ddd2b216de4152f5572306ec59d805231d348b"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/c7/35/584fc928bffd1346c4b9c55170cbe4c09f89ec185d0d9d7e2626f876e80d/craft_grammar-2.3.0.tar.gz"
    sha256 "0b7ae3aa595f0f3d1f82ed2e696c99b35283c18a60c7a68840bc185bd123e4d8"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/ff/0e/32408579efd9061321c8df73754f47347e0eb26c04621b61bf173b9e2fc3/craft_parts-2.26.0.tar.gz"
    sha256 "53d73015ec55ca5ad5dfc84113db26b06191928bc82ac1e18e8582381390b6d6"
  end

  resource "craft-platforms" do
    url "https://files.pythonhosted.org/packages/44/78/f2c3ef342c9e9fee0127516aee113a28c487a999d35ce4aa944a58bd5939/craft_platforms-0.10.0.tar.gz"
    sha256 "85b8630c0f7436b0832466c1dba8deb040502fdadc1d225fbed15d1e1e38f729"
  end

  # Temporarily downgrade from 3.1.0 to fix the error: No module named 'pylxd'
  # It should only required on linux, but the dependency is pulled on macOS
  # Issue ref: https://github.com/canonical/snapcraft/issues/5781
  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/99/2f/3b1a7062c2d9b94f926d96356b63678d50aa44a2657a313adf2df4150bf6/craft_providers-3.0.0.tar.gz"
    sha256 "07f669abd7b16d8bd983851ea173e932a1a2244cc81a457370c0979f71612f9c"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/c4/64/af2af291aef5ea2b5fc56d9be151324eabb55c4ed89bc4f11343faa377b5/craft_store-3.3.0.tar.gz"
    sha256 "02304296d7d5b896bb8d07660c3a29eaff461fc12d40fd2a21a39230f53c288b"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "distro-support" do
    url "https://files.pythonhosted.org/packages/90/c8/40cf2bdb5647c0ccad40a02edde6966d03a3258c550d92a2030427867029/distro_support-2025.8.13.tar.gz"
    sha256 "12a73039db0a04e4b987789598f05c554adb3b2ec8e97bc28f40a125dc82d982"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/d9/02/111134bfeb6e6c7ac4c74594e39a59f6c0195dc4846afbeac3cba60f1927/docutils-0.22.3.tar.gz"
    sha256 "21486ae730e4ca9f622677b1412b879af1791efcfba517e4c6f60be543fc8cdd"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/52/77/6653db69c1f7ecfe5e3f9726fdadc981794656fcd7d98c4209fecfea9993/httplib2-0.31.0.tar.gz"
    sha256 "ac7ab497c50975147d4f7b1ade44becc7df2f8954d42b38b3d69c515f531135c"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/70/09/d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37d/keyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/30/ec/e659321733decaafe95d4cf964ce360b153de48c5725d5f27cefe97bf5f8/launchpadlib-2.1.0.tar.gz"
    sha256 "b4c25890bb75050d54c08123d2733156b78a59a2555f5461f69b0e44cd91242f"
  end

  resource "lazr-restfulclient" do
    url "https://files.pythonhosted.org/packages/ea/a3/45d80620a048c6f5d1acecbc244f00e65989914bca370a9179e3612aeec8/lazr.restfulclient-0.14.6.tar.gz"
    sha256 "43f12a1d3948463b1462038c47b429dcb5e42e0ba7f2e16511b02ba5d2adffdb"
  end

  resource "lazr-uri" do
    url "https://files.pythonhosted.org/packages/58/53/de9135d731a077b1b4a30672720870abdb62577f18b1f323c87e6e61b96c/lazr_uri-1.0.7.tar.gz"
    sha256 "ed0cf6f333e450114752afb1ce0c299c36ac4b109063eb50354c4f87f825a3ee"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/4b/ae/59f5ab870640bd43673b708e5f24aed592dc2673cc72caa49b0053b4af37/macaroonbakery-1.3.4.tar.gz"
    sha256 "41ca993a23e4f8ef2fe7723b5cd4a30c759735f1d5021e990770c8a0e0f33970"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/ff/64a6c8f420818bb873713988ca5492cba3a7946be57e027ac63495157d97/protobuf-6.33.0.tar.gz"
    sha256 "140303d5c8d2037730c548f8c7b93b20bb1dc301be280c378b82b8894589c954"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/b9/ab/33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071af/pyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pylxd" do
    url "https://files.pythonhosted.org/packages/d3/45/8a7b71aeac58e7c42f296a8878c7275728cfb579a4116ea676e8c55f4333/pylxd-2.3.6.tar.gz"
    sha256 "1c6e064e264a5a215826b5d1ecba981a7fe09771e1b83eff0809e0643a390a14"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/bf/4b/3c4cf635311b6203f17c2d693dc15e898969983dd3f729bee3c428aa60d4/python-debian-1.0.1.tar.gz"
    sha256 "3ada9b83a3d671b58081782c0969cffa0102f6ce433fbbc7cf21275b8b5cc771"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket2" do
    url "https://files.pythonhosted.org/packages/12/04/e5c07a329a0087f8a342231b6e054d83279c17ccc81da5aa18071c8ea75e/requests_unixsocket2-1.0.1.tar.gz"
    sha256 "87953038ae42befb6efbdf504d6dda2554a0b0d13b65e42f7319793b5527a303"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/31/9f/11ef35cf1027c1339552ea7bfe6aaa74a8516d8b5caf6e7d338daf54fd80/secretstorage-3.4.0.tar.gz"
    sha256 "c46e216d6815aff8a8a18706a2fbfd8d53fcbb0dce99301881687a1b0289ef7c"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/41/f4/a1ac5ed32f7ed9a088d62a59d410d4c204b3b3815722e2ccfb491fa8251b/simplejson-3.20.2.tar.gz"
    sha256 "5fe7a6ce14d1c300d80d08695b7f7e633de6cd72c80644021874d985b3393649"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/50/2a/221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216/snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/a0/79/4af51e2bb214b6ea58f857c51183d92beba85b23f7ba61c983ab3de56c33/tinydb-4.8.2.tar.gz"
    sha256 "f7dfc39b8d7fda7a1ca62a8dbb449ffd340a117c1206b68c50b1a481fb95181d"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/53/66/a435d9ae49850b2f071f7ebd8119dd4e84872b01630d6736761e6e7fd847/validators-0.35.0.tar.gz"
    sha256 "992d6c48a4e77c81f1b4daba10d16c3a9bb0dbb79b3a19ea847ff0928e70497a"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/da/54/82866d8c2bf602ed9df52c8f8b7a45e94f8c2441b3d1e9e46d34f0e3270f/wadllib-2.0.0.tar.gz"
    sha256 "1edbaf23e4fa34fea70c9b380baa2a139b1086ae489ebcccc4b3b65fc9737427"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/cb/55/dd8a5e1f975d1549494fe8692fc272602f17e475fe70de910cdd53aec902/ws4py-0.6.0.tar.gz"
    sha256 "9f87b19b773f0a0744a38f3afa36a803286dd3197f0bb35d9b75293ec7002d19"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    without = %w[gnupg]
    without += %w[jeepney secretstorage pylxd ws4py] if OS.mac?
    venv = virtualenv_install_with_resources(without:)

    # Workaround for runtime SyntaxWarning: invalid escape sequence '\d'
    resource("gnupg").stage do
      inreplace "gnupg/_util.py", "re.compile('", "re.compile(r'"
      inreplace "gnupg/_parsers.py", "re.findall('", "re.findall(r'"
      venv.pip_install_and_link Pathname.pwd
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/snapcraft --version")

    assert_match "Package, distribute, and update snaps", shell_output("#{bin}/snapcraft --help 2>&1")

    system bin/"snapcraft", "init"
    assert_path_exists testpath/"snap/snapcraft.yaml"
  end
end
