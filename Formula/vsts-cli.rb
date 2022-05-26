class VstsCli < Formula
  include Language::Python::Virtualenv

  desc "Manage and work with VSTS/TFS resources from the command-line"
  homepage "https://docs.microsoft.com/en-us/cli/vsts"
  url "https://files.pythonhosted.org/packages/f9/c2/3ed698480ab30d2807fc961eef152099589aeaec3f1407945a4e07275de5/vsts-cli-0.1.4.tar.gz"
  sha256 "27defe1d8aaa1fcbc3517274c0fdbd42b5ebe2c1c40edfc133d98fe4bb7114de"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_monterey: "4dc169e5bbff8bd9eaa9db72b8b2a83d83716e40202854906cd8ac59cdc0bc5c"
    sha256 cellar: :any, arm64_big_sur:  "752413507a6e22fe0b1a2c1ac153b71707d18cd169ae3449de5f273fd703b990"
    sha256 cellar: :any, monterey:       "d584b9d130263ae074a4c4c7332ecd46108c527939407dbef22a7d9cbb4b0126"
    sha256 cellar: :any, big_sur:        "d7efb21997c73cca1c609e1e720f7322ff5329961fb8908c4ad3d40370c167e8"
    sha256 cellar: :any, catalina:       "f77d99672e32d1b8a5fc5fc01d8dcc6a4959af4a369d67c32a595fc1503fdbaf"
  end

  # https://github.com/Azure/azure-devops-cli-extension/pull/219#issuecomment-456404611
  disable! date: "2022-05-27", because: :unsupported

  depends_on "rust" => :build
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/cb/53/d2e3d11726367351b00c8f078a96dacb7f57aef2aca0d3b6c437afc56b55/argcomplete-1.12.2.tar.gz"
    sha256 "de0e1282330940d52ea92a80fea2e4b9e0da1932aaa570f84d268939d1897b04"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/cc/98/8a258ab4787e6f835d350639792527d2eb7946ff9fc0caca9c3f4cf5dcfe/cryptography-3.4.8.tar.gz"
    sha256 "94cc5ed4ceaefcbe5bf38c8fba6a21fc1d365bb8fb826ea1688e3370b2e24a1c"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/0d/2d/8cb8583e4dc4e44932460c88dbe1d7fde907df60589452342bc242ac7da0/humanfriendly-4.7.tar.gz"
    sha256 "ee071c8f6c7457db53472ae9974aaf561c95fdbe072e1f2a3ba29aaa6ca51098"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/bb/4f/06017fbbe94eeaf1e7852c2dd7a065ca7d813e17b4500f4e842531d72593/jeepney-0.6.0.tar.gz"
    sha256 "7d59b6622675ca9e993a6bd38de845051d315f8b0c72cca3aef733a20b648657"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
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
    url "https://files.pythonhosted.org/packages/bb/2c/e8ac4f491efd412d097d42c9eaf79bcaad698ba17ab6572fd756eb6bd8f8/msrest-0.6.21.tar.gz"
    sha256 "72661bc7bedc2dc2040e8f170b6e9ef226ee6d3892e01affd4d26b06474d68d8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/cd/08/758aeb98db87547484728ea08b0292721f1b05ff9005f59b040d6203c009/SecretStorage-3.3.1.tar.gz"
    sha256 "fd666c51a6bf200643495a04abb261f83229dcb6fd8472ec393df7ffc8b6f195"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d7/8d/7ee68c6b48e1ec8d41198f694ecdc15f7596356f2ff8e6b1420300cf5db3/urllib3-1.26.3.tar.gz"
    sha256 "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73"
  end

  resource "vsts" do
    url "https://files.pythonhosted.org/packages/ce/fa/4405cdb2a6b0476a94b24254cdfb1df7ff43138a91ccc79cd6fc877177af/vsts-0.1.25.tar.gz"
    sha256 "da179160121f5b38be061dbff29cd2b60d5d029b2207102454d77a7114e64f97"
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

  resource "pycparser" do
    on_linux do
      url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz#sha256=a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
      sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
    end
  end

  resource "cffi" do
    on_linux do
      url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz#sha256=599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
      sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
    end
  end

  resource "cryptography" do
    on_linux do
      url "https://files.pythonhosted.org/packages/be/60/da377e1bed002716fb2d5d1d1cab720f298cb33ecff7bf7adea72788e4e4/cryptography-2.8.tar.gz#sha256=3cda1f0ed8747339bbdf71b9f38ca74c7b592f24f65cdb3ab3765e4b02871651"
      sha256 "3cda1f0ed8747339bbdf71b9f38ca74c7b592f24f65cdb3ab3765e4b02871651"
    end
  end

  resource "jeepney" do
    on_linux do
      url "https://files.pythonhosted.org/packages/3a/b6/28c665d48e48b5b7e6a26853d6b4595c4031de7798a6c4985b14492ebd14/jeepney-0.4.1.tar.gz#sha256=13806f91a96e9b2623fd2a81b950d763ee471454aafd9eb6d75dbe7afce428fb"
      sha256 "13806f91a96e9b2623fd2a81b950d763ee471454aafd9eb6d75dbe7afce428fb"
    end
  end

  resource "secretstorage" do
    on_linux do
      url "https://files.pythonhosted.org/packages/a6/89/df343dbc2957a317127e7ff2983230dc5336273be34f2e1911519d85aeb5/SecretStorage-3.1.1.tar.gz#sha256=20c797ae48a4419f66f8d28fc221623f11fc45b6828f96bdb1ad9990acb59f92"
      sha256 "20c797ae48a4419f66f8d28fc221623f11fc45b6828f96bdb1ad9990acb59f92"
    end
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
