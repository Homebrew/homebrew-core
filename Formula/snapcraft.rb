class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapcraft.git",
      tag:      "4.8.1",
      revision: "245631a94e912120d40b55a945acf0ffa0450bee"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "41d4fc2c561ca44f95718042d084c2f4aa3cf50e6db6fc8cf781c2b6be58290b"
    sha256 cellar: :any, big_sur:       "7a237740c0b541c44fbb68558875043823ecd5c2626d0407020cbd519d55d8fe"
    sha256 cellar: :any, catalina:      "8537fbbd83c21c8769c766f85a9327852242a0302dfbb982670ccaa5c5b664c9"
    sha256 cellar: :any, mojave:        "3e87c18435182ab3db5b2fa15d3007651f2e39be37211b7a37085f48555b691e"
  end

  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "python@3.9"
  depends_on "snap"
  depends_on "xdelta"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ea/d8/2afd2890fe451a3c109d2bdb6bc4ded55ec43059e524344d5e0004e36412/cryptography-3.4.tar.gz"
    sha256 "9f7aa11ea95723359f914be3217d8b378bc3897f65a1ec1ab4e0118c336f51fc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/ed/cd/533a1e9e04671bcee5d2854b4f651a3fab9586d698de769d93b05ee2bff1/httplib2-0.19.1.tar.gz"
    sha256 "0b12617eeca7433d4c396a100eaecfa4b08ee99aa881e6df6e257a7aad5d533d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/1c/7f/fe573d2225d7e0ea4bd9e8673b2c7fc0b2b2b2f86b36f8c5fe75b77e59c4/importlib_metadata-4.5.0.tar.gz"
    sha256 "b142cc1dd1342f31ff04bb7d022492b09920cb64fed867cd3ea6f80fe3ebd139"
  end

  resource "vcversioner" do
    url "https://files.pythonhosted.org/packages/c5/cc/33162c0a7b28a4d8c83da07bc2b12cee58c120b4a9e8bba31c41c8d35a16/vcversioner-2.16.0.0.tar.gz"
    sha256 "dae60c17a479781f44a4010701833f1829140b1eeccd258762a74974aa06e19b"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/b0/b5/b27458e1d2adf2a11c6e95c67ac63f828e96fe7e166132e5dacbe03e88c0/keyring-23.0.1.tar.gz"
    sha256 "045703609dd3fccfcdb27da201684278823b72af515aedec1a8515719a038cb8"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/af/23/d97442ef2e13db4648608a9e1a5822b9ff5e25e7f05013b8a57343120e85/launchpadlib-1.10.13.tar.gz"
    sha256 "5804d68ec93247194449d17d187e949086da0a4d044f12155fad269ef8515435"
  end

  resource "lazr.restfulclient" do
    url "https://files.pythonhosted.org/packages/4a/2f/14812d3b0808c594c1e090505229d5ae31d55eb93c23417d91b3a1f57853/lazr.restfulclient-0.14.3.tar.gz"
    sha256 "9f28bbb7c00374159376bd4ce36b4dacde7c6b86a0af625aa5e3ae214651a690"
  end

  resource "lazr.uri" do
    url "https://files.pythonhosted.org/packages/8e/c5/92c55bb9b3a513e149638de695baec243dbfabb0823bcf6185263028eb84/lazr.uri-1.0.5.tar.gz"
    sha256 "f36e7e40d5f8f2cf20ff2c81784a14a546e6c19c216d40a6617ebe0c96c92c49"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/52/40/2a8bb2f507ce1a6c5b896c1b98044d74d34b07a6dd771526b4fe84e3181f/macaroonbakery-1.3.1.tar.gz"
    sha256 "23f38415341a1d04a155b4dac6730d3ad5f39b86ce07b1bb134bdda52b48b053"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/9e/84/001a3f8d9680f3b26d5e7711e13d5ff92e4b511766a72ac6b4a4e5f06796/oauthlib-3.1.1.tar.gz"
    sha256 "8f0215fcc533dd8dd1bee6f4c412d4f0cd7297307d43ac61666389e3bc3198a3"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/35/8c/69ed04ae31ad498c9bdea55766ed4c0c72de596e75ac0d70b58aa25e0acf/pbr-5.6.0.tar.gz"
    sha256 "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/3d/64/a3b379cb9c7827ad33c67dcda4c4ad117bdef1b7d68b22a05c963cf4727d/protobuf-3.17.3.tar.gz"
    sha256 "72804ea5eaa9c22a090d2803813e280fb273b62d5ae497aaf3553d141c4fdd7b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/6b/b5/f7022f2d950327ba970ec85fb8f85c79244031092c129b6f34ab17514ae0/pyelftools-0.27.tar.gz"
    sha256 "cde854e662774c5457d688ca41615f6594187ba7067af101232df889a6b7a66b"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "pysha3" do
    url "https://files.pythonhosted.org/packages/73/bf/978d424ac6c9076d73b8fdc8ab8ad46f98af0c34669d736b1d83c758afee/pysha3-1.0.2.tar.gz"
    sha256 "fe988e73f2ce6d947220624f04d467faf05f1bbdbc64b0a201296bb3af92739e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/4d/ce/78b651fe0adbd4227578fa432d1bde03b4f4945a70c81e252a2b6a2d895f/requests-unixsocket-0.2.0.tar.gz"
    sha256 "9e5c1a20afc3cf786197ae59c79bcdb0e7565f218f27df5f891307ee8817c1ea"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/d4/52/3be868c7ed1f408cb822bc92ce17ffe4e97d11c42caafce0589f05844dd0/semantic_version-2.8.5.tar.gz"
    sha256 "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/12/22/6ba3031e7cbd6eb002e13ffc7397e136df95813b6a2bd71ece52a8f89613/setuptools-rust-0.12.1.tar.gz"
    sha256 "647009e924f0ae439c7f3e0141a184a69ad247ecb9044c511dabde232d3d570e"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/49/45/a16db4f0fa383aaf0676fb7e3c660304fe390415c243f41a77c7f917d59b/simplejson-3.17.2.tar.gz"
    sha256 "75ecc79f26d99222a084fbdd1ce5aad3ac3a8bd535cd9059528452da38b68841"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  end

  resource "testresources" do
    url "https://files.pythonhosted.org/packages/9d/57/8e3986cd95a80dd23195f599befa023eb85d031d2d870c47124fa5ccbf06/testresources-2.0.1.tar.gz"
    sha256 "ee9d1982154a1e212d4e4bac6b610800bfb558e4fb853572a827bc14a96e4417"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/6d/49/7acf7708e971fdd81edfe4fd9d8d8ce8bf2fe282746410943a4a595ae77e/tinydb-4.4.0.tar.gz"
    sha256 "d57c29524ecacc081ebc24f96e0d787bba11dc20d52634a32a709b878be3545a"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/ce/a0/6d0fcb2d9d097b0dd05ed168eb947375d311f5d52a09ae40585c2d5601cf/wadllib-1.3.5.tar.gz"
    sha256 "84fecbaec2fef5ae2d7717a8115d271f18c6b5441eac861c58be8ca57f63c1d3"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/38/f9/4fa6df2753ded1bcc1ce2fdd8046f78bd240ff7647f5c9bcf547c0df77e3/zipp-3.4.1.tar.gz"
    sha256 "3607921face881ba3e026887d8150cca609d517579abe052ac81fc5aeffdbd76"
  end

  # Fix error on ARM due to missing architecture definition for 'arm64'
  # Remove in the next release
  patch do
    url "https://github.com/snapcore/snapcraft/commit/61029a4a2ae36f5368a7108b5d99bc99ccac54c5.patch?full_index=1"
    sha256 "0950b41e5e33ea9c1a40ac4d308d22d0e13adb44655a01f469973fcd1e7c9d91"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"]="en_US.UTF-8"
    system "#{bin}/snapcraft", "--version"
    system "#{bin}/snapcraft", "--help"
    system "#{bin}/snapcraft", "init"
    assert_predicate testpath/"snap/snapcraft.yaml", :exist?
  end
end
