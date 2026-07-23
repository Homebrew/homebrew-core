class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  # Use git checkout so setuptools-scm and update-python-resources works
  url "https://github.com/canonical/snapcraft.git",
      tag:      "9.0.1",
      revision: "68c28110f50f9933b4d19f13bf7cb69ddf1e4391"
  license "GPL-3.0-only"
  head "https://github.com/canonical/snapcraft.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6446ca9352e5243f611bfe339efb1f376d2bf8bce5fa31c2b57fb07e609c8a53"
    sha256 cellar: :any, arm64_sequoia: "ed6639bc81c26503580b68974453bad8b7ea2be376bc9028258e206b2339fcd6"
    sha256 cellar: :any, arm64_sonoma:  "193bec0cfa60a6bf825b7563f06036d7fa72f8dbabb65427085e1679a3abe710"
    sha256 cellar: :any, sonoma:        "0e0d1bacaa0816eaafac9e754f3bcacd080324a47ea34749d9bedb69e951bfac"
    sha256 cellar: :any, arm64_linux:   "61910dbcb83fb5c15769e6c68cadef63da80061aa6cac1d63229a119a813611b"
    sha256 cellar: :any, x86_64_linux:  "7d03750bec4d732cdd335db86d9045f07b514a00698c70049b34aba3e7058e57"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
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
  end

  pypi_packages exclude_packages: %w[certifi cryptography pydantic pygit2],
                extra_packages:   %w[catkin-pkg jeepney pylxd secretstorage]

  # We hit a build failure with requested 2.4.0ubuntu1 tarball so just using latest Debian
  resource "python-apt" do
    on_linux do
      url "https://deb.debian.org/debian/pool/main/p/python-apt/python-apt_3.1.0.tar.xz"
      sha256 "daf46b0ed85061ccee64c3aa3004c695b33047f9f62f0de7863966c287731d5a"

      livecheck do
        url "https://deb.debian.org/debian/pool/main/p/python-apt/"
        regex(/href=.*?python-apt[._-]v?(\d+(?:\.\d+)+)\.tar\.xz/i)
      end
    end
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
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
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "craft-application" do
    url "https://files.pythonhosted.org/packages/6b/c3/be96c01c1b92a7a7eb6cafa881ccd09a6b9e1db1355835fc98f001680cc3/craft_application-7.1.0.tar.gz"
    sha256 "e0a3fb2080bf1dd6daf8b570262716f79a5f307a87d3ed2b986eaca50e07efed"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/11/3e/3ee557ac30aa1b9b6fa08de49fe2dd08727e329985073363f58098a45674/craft_archives-2.2.1.tar.gz"
    sha256 "4f1858de9ed60e47284006cdcead233df92322b3b5eff15d7a67aebfe782874e"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/b2/97/55e3a42aed3c8ee408dca292c7736080161d6bcfd6d21a8374b74be90f63/craft_cli-3.4.1.tar.gz"
    sha256 "e4396695e89f15fbd06255a78b38a362006cd711266d926c2b6cd2a546af61a5"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/c7/35/584fc928bffd1346c4b9c55170cbe4c09f89ec185d0d9d7e2626f876e80d/craft_grammar-2.3.0.tar.gz"
    sha256 "0b7ae3aa595f0f3d1f82ed2e696c99b35283c18a60c7a68840bc185bd123e4d8"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/0c/c6/3cdccef7c6b5d268ec2ceac05aaa5707ed6a25af46df30fc105fa227f533/craft_parts-2.35.0.tar.gz"
    sha256 "63a236a3a9518506498f7a8bc351145f587977649bab80b633813270b5011a5c"
  end

  resource "craft-platforms" do
    url "https://files.pythonhosted.org/packages/a0/f2/507e3b1bd017f51bea6c70205744239b62eac20c552fa0ee1f1c30019752/craft_platforms-0.12.0.tar.gz"
    sha256 "497b6421fc5f464ee1f31da60ae1211bd3101722770afae72e0b330e54883e9d"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/86/f5/81525f63af39d73be1fae45fc169eb036781d745a0220f95d9b7f6165549/craft_providers-3.7.1.tar.gz"
    sha256 "473e6228720dda9f042eae8b9584a1f1c41d6fd987c0fd9db0d69609d3c5f283"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/a4/fd/2013bd5b54a5b14c69ba63ce1c2210ac15d26603b7b5a912b793312f3f30/craft_store-3.4.0.tar.gz"
    sha256 "c2552f3e0596e1d63b3076ac49e87664571fb87fa45065dffacde4c395f4b28e"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "distro-support" do
    url "https://files.pythonhosted.org/packages/91/9f/530d03c3d7172f787949af55768d088a341e52974c03ce26142693375de1/distro_support-2025.12.16.tar.gz"
    sha256 "95d93375983a68cd749e7ae9d434a22ab7d5b6f515fbed52541ecc9457296946"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
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
    url "https://files.pythonhosted.org/packages/84/f5/ccf58de92d61e3ad921119668f54ed36ca1d0cf5dcc5c1657dfb164fd78b/httplib2-0.32.0.tar.gz"
    sha256 "48a0ef30a42db65d8f3399045e1d09ab0ba66e3b9efc360d07f80ea55d286025"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
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
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
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
    url "https://files.pythonhosted.org/packages/88/a9/2f81f86bb83c32c3ab585e58c32871c5ce99011293104f8a3c955909397d/lazr_uri-1.0.8.tar.gz"
    sha256 "0e45854eb22687958dfb807655ff7e095b1765be649e24ccc581934d0337d3b4"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
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
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
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
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/52/cd/4f25b2f95b23f5d2c9c1fe43e49841bff5800562149b2666afc09309aa8f/platformdirs-4.10.1.tar.gz"
    sha256 "ceab4084426fe6319ce18e86deada8ab1b7487c7aee7040c55e277c9ae793695"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/da/01/9ef0afd7999eb9badb3a768b4aedd78c86d4c65cfaf1958ab276199e76b4/protobuf-7.35.1.tar.gz"
    sha256 "ce115a26fe0c39a2c29973d914d327e516a6455464489fe3cd1e51a1b354f81a"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/a3/11/767522582afab1b884d277de0e6e011640cb9d7292a38694b4b1a1df1ae8/pyelftools-0.33.tar.gz"
    sha256 "660d82dcbeb8e83d1702bd97f223f761625da06111c0cc988eac6b8ab0c1b61f"
  end

  resource "pylxd" do
    url "https://files.pythonhosted.org/packages/23/b2/ed81d9cebf8c81b0f76db47cc8cf844475cb11aa1963b8cd87e11fd2fce9/pylxd-2.4.1.tar.gz"
    sha256 "db539951d1e593e562315ec90031f6635020e2a7174f8328a63207e8db854c15"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
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
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
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
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/50/2a/221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216/snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "snap-http" do
    url "https://files.pythonhosted.org/packages/4a/d3/0a177f3d30273650a4d4a12d43af71c3cce198f9f309ac7b3f4d3f18d661/snap_http-1.12.0.tar.gz"
    sha256 "c04e498474162ff565729e0756a99a658e4f757cb9689a79fbee68716cb7d29d"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/53/66/a435d9ae49850b2f071f7ebd8119dd4e84872b01630d6736761e6e7fd847/validators-0.35.0.tar.gz"
    sha256 "992d6c48a4e77c81f1b4daba10d16c3a9bb0dbb79b3a19ea847ff0928e70497a"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/ab/f8/c7681d8d8dca6aa1f90e054bde451c25741fde702b21c347fe65fb813543/wadllib-2.1.0.tar.gz"
    sha256 "69c60a188c9c629a0e947dfafd89acdc8b7d8d404a6b5eb0ad258fef29362501"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/cb/55/dd8a5e1f975d1549494fe8692fc272602f17e475fe70de910cdd53aec902/ws4py-0.6.0.tar.gz"
    sha256 "9f87b19b773f0a0744a38f3afa36a803286dd3197f0bb35d9b75293ec7002d19"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/snapcraft --version")

    assert_match "Package, distribute, and update snaps", shell_output("#{bin}/snapcraft --help 2>&1")

    system bin/"snapcraft", "init"
    assert_path_exists testpath/"snap/snapcraft.yaml"
  end
end
