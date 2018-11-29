class VstsCli < Formula
  include Language::Python::Virtualenv

  desc "Manage and work with VSTS/TFS resources from the command-line"
  homepage "https://docs.microsoft.com/en-us/cli/vsts"
  url "https://files.pythonhosted.org/packages/f9/c2/3ed698480ab30d2807fc961eef152099589aeaec3f1407945a4e07275de5/vsts-cli-0.1.4.tar.gz"
  sha256 "27defe1d8aaa1fcbc3517274c0fdbd42b5ebe2c1c40edfc133d98fe4bb7114de"

  bottle do
    cellar :any_skip_relocation
    sha256 "55cd1a1328f4d3f85d4f7319b8cc1eaa6bfb2c528922f7707e5156649a54c997" => :mojave
    sha256 "0ab4def28bd633cdbd4d82158db3eb7f105e91091c2740cf37a6f84d065a0c69" => :high_sierra
    sha256 "cffcc18b4f1785c13c9599de7f829df864fa319ee614383b1652526a17ea87a3" => :sierra
  end

  depends_on "python"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/21/9741e5e5e63245a8cdafb32ffc738bff6e7ef6253b65953e77933e56ce88/argcomplete-1.9.4.tar.gz"
    sha256 "06c8a54ffaa6bfc9006314498742ec8843601206a3b94212f82657673662ecf1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/b6/4f0cefba47656583217acd6cd797bc2db1fede0d53090fdc28ad2c8e0716/certifi-2018.10.15.tar.gz"
    sha256 "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/0d/2d/8cb8583e4dc4e44932460c88dbe1d7fde907df60589452342bc242ac7da0/humanfriendly-4.7.tar.gz"
    sha256 "ee071c8f6c7457db53472ae9974aaf561c95fdbe072e1f2a3ba29aaa6ca51098"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a0/c9/c08bf10bd057293ff385abaef38e7e548549bbe81e95333157684e75ebc6/keyring-13.2.1.tar.gz"
    sha256 "6364bb8c233f28538df4928576f4e051229e0451651073ab20b315488da16a58"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/b5/58/2ba172d2ea8babae13a2a4d3fc0be810fd067429f990e850e4088f22494e/knack-0.4.1.tar.gz"
    sha256 "ba45fd69c2faf91fd3d6e95cec1c0ef7e0f4362e33c59bf5a260216ffcb859a0"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/d8/9a/34f359d9acba054274202f6a2f0bdc3c907f938aeb7dff612002874f17ea/msrest-0.6.2.tar.gz"
    sha256 "1b8daa01341fb77b0797c5fbc28e7e957388eb562721cc6392603ea5a4a39345"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/df/5f/3f4aae7b28db87ddef18afed3b71921e531ca288dc604eb981e9ec9f8853/oauthlib-2.1.0.tar.gz"
    sha256 "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/63/a2/91c31c4831853dedca2a08a0f94d788fc26a48f7281c99a303769ad2721b/Pygments-2.3.0.tar.gz"
    sha256 "82666aac15622bd7bb685a4ee7f6625dd716da3ef7473620c192c0168aae64fc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/40/35/298c36d839547b50822985a2cf0611b3b978a5ab7a5af5562b8ebe3e1369/requests-2.20.1.tar.gz"
    sha256 "ea881206e59f41dbd0bd445437d792e43906703fff75ca8ff43ccdb11f33f263"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/be/072464f05b70e4142cb37151e215a2037b08b1400f8a56f2538b76ca6205/requests-oauthlib-1.0.0.tar.gz"
    sha256 "8886bfec5ad7afb391ed5443b1f697c6f4ae98d0e5620839d8b4499c032ada3f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/12/c2/11d6845db5edf1295bc08b2f488cf5937806586afe42936c3f34c097ebdc/tabulate-0.8.2.tar.gz"
    sha256 "e4ca13f26d0a6be2a2915428dc21e732f1e44dad7f76d7030b2ef1ec251cf7f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  resource "vsts" do
    url "https://files.pythonhosted.org/packages/e7/37/d8725833efba01d234aabda5a0c2ffb6c369dd3286bca265dfbbe7a51250/vsts-0.1.20.tar.gz"
    sha256 "1ece70729d616029f7fd1859524ee6b7d95ff07403af7bb4f963322ad28005f8"
  end

  resource "vsts-cli" do
    url "https://files.pythonhosted.org/packages/f9/c2/3ed698480ab30d2807fc961eef152099589aeaec3f1407945a4e07275de5/vsts-cli-0.1.4.tar.gz"
    sha256 "27defe1d8aaa1fcbc3517274c0fdbd42b5ebe2c1c40edfc133d98fe4bb7114de"
  end

  resource "vsts-cli-admin" do
    url "https://files.pythonhosted.org/packages/96/15/501240b53c6de9c81ba7c2c57e4a7227cc68eacb776a7b034178d7ffb56d/vsts-cli-admin-0.1.4.tar.gz"
    sha256 "d8a56dd57112a91818557043a8c1e98e26b8d9e793a448ceaa9df0439972cfd5"
  end

  resource "vsts-cli-admin-common" do
    url "https://files.pythonhosted.org/packages/fa/bc/13802bc886316f41f39ee47e086e60d1d2bf00b03399afbcb07bb8d3abd9/vsts-cli-admin-common-0.1.4.tar.gz"
    sha256 "6794d7b6d016b93e66613b84c31f67a90c2b296675b29b2ea9bbf1566e996f8a"
  end

  resource "vsts-cli-build" do
    url "https://files.pythonhosted.org/packages/69/8b/0b03651a621a8a1f438cbdad2023a6cf1bf83f528452ba628a33d773983f/vsts-cli-build-0.1.4.tar.gz"
    sha256 "e4152ead1961506371e8a17656b18bc8797034411c2b2d355b73250c86b27052"
  end

  resource "vsts-cli-build-common" do
    url "https://files.pythonhosted.org/packages/d9/2e/294931be3d181742362feb138084f2dfef4632aa6f9762e89c8e14b2d8a7/vsts-cli-build-common-0.1.4.tar.gz"
    sha256 "64fe48b944a04f2ae7df0afa9bfcd37b281d786d3558bb66c597c990f0745f08"
  end

  resource "vsts-cli-code" do
    url "https://files.pythonhosted.org/packages/98/ce/d2edb9adcb403b5abb76efcf6a9ae3c5e1943215a4fb1fa20062e3094853/vsts-cli-code-0.1.4.tar.gz"
    sha256 "2154f0769cdb694110886ef7859dda86f19c02f67d037dc592ae21772a51b938"
  end

  resource "vsts-cli-code-common" do
    url "https://files.pythonhosted.org/packages/63/8a/1afd03644034f2f81e912864f6f8457b7da95580e3319b45fe6e17d4dbb0/vsts-cli-code-common-0.1.4.tar.gz"
    sha256 "ed41220313ceb67612d6dc30596ef53cd2bbf1f55df826ca8cecd364a8a92130"
  end

  resource "vsts-cli-common" do
    url "https://files.pythonhosted.org/packages/d4/4e/58e5b3a1a36e2db2f032d26d3be78ef227467d69ac280f9d69d1abc514e6/vsts-cli-common-0.1.4.tar.gz"
    sha256 "a031ad9748b9dbd8552357b42a92363a641572fe1035540c2542b05078aa9005"
  end

  resource "vsts-cli-package" do
    url "https://files.pythonhosted.org/packages/2e/25/4c36f9d006c06fe0cf91694ec04ec68171492b9854e8e6ab5492c9db50c2/vsts-cli-package-0.1.4.tar.gz"
    sha256 "74ab09d40b2e3572518e618d0e46d227bfa3f5db999e936a04f590a4fc6ed1ec"
  end

  resource "vsts-cli-package-common" do
    url "https://files.pythonhosted.org/packages/26/d2/16071a391735a1d71d121fe0fb0789baedcb14192cda597027bc7538453f/vsts-cli-package-common-0.1.4.tar.gz"
    sha256 "07cbe4e4f6602b6ef7168a24110925433dbb357135c269952457c8c071ff877c"
  end

  resource "vsts-cli-release" do
    url "https://files.pythonhosted.org/packages/24/8e/245b35fc07684290628ed4cfd4e3821c8401c47091ce12f67efdc0cf81d9/vsts-cli-release-0.1.4.tar.gz"
    sha256 "9b82ed707da696c4708285e5f1ea4ff0f72a010c90e7c6d070267a8fb9343ca5"
  end

  resource "vsts-cli-release-common" do
    url "https://files.pythonhosted.org/packages/e5/2d/889686657c3d82b7768d95989fde922dddf64339735a3159848c5468f7d7/vsts-cli-release-common-0.1.4.tar.gz"
    sha256 "619022dd2e9092db941b6bb6dbc6958d1f5f2e6c41c67f015e181325a562e859"
  end

  resource "vsts-cli-team" do
    url "https://files.pythonhosted.org/packages/ed/7b/f6178e31d666257a80fd9ec8281809a4eead3de0f61c3031c4fad38f0c3c/vsts-cli-team-0.1.4.tar.gz"
    sha256 "ca966527eff69441d89a7aaa5758d53ab31d5d527acc064d29d72270f1b913a2"
  end

  resource "vsts-cli-team-common" do
    url "https://files.pythonhosted.org/packages/c6/d4/0d0d9b15d22e1a2044760152864279fc0c4054f8a0254e86529dad3fae53/vsts-cli-team-common-0.1.4.tar.gz"
    sha256 "57aab81b472d76ef010036ed90f7bd11fffb66c79c1991d64b0694a8b2f47c08"
  end

  resource "vsts-cli-work" do
    url "https://files.pythonhosted.org/packages/68/2d/547a18affb25bd1f8be2fdcec64df2a75fb5fb4377a5edd2432b522b46f6/vsts-cli-work-0.1.4.tar.gz"
    sha256 "dca2324f5445765a3ff4d9178d9b37c985b75e22c20660741d43ef24ac72ec74"
  end

  resource "vsts-cli-work-common" do
    url "https://files.pythonhosted.org/packages/36/51/d4b7accf6b9e009875f4a2c05ceba7ddd8936f99c2dde5f4308a40edc360/vsts-cli-work-common-0.1.4.tar.gz"
    sha256 "ec023e69d88292024e6bd5ac34b9d5913aa92c4ce148751c33fdf9da13e0d522"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink "#{libexec}/bin/vsts" => "vsts"
  end

  test do
    system "#{bin}/vsts", "configure", "--help"
    output = shell_output("#{bin}/vsts logout 2>&1", 1)
    assert_equal "ERROR: The credential was not found", output.chomp
    output = shell_output("#{bin}/vsts work 2>&1", 2)
    assert_match "vsts work: error: the following arguments are required", output
  end
end
