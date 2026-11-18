class Sickchill < Formula
  include Language::Python::Virtualenv

  desc "Automatic Video Library Manager for TV Shows"
  homepage "https://sickchill.github.io"
  url "https://github.com/SickChill/sickchill/archive/refs/tags/2026.11.23.tar.gz"
  sha256 "2df8e5414b9f3012b61e28f01a962752951d7ed0066e88cf5db8c1731c10e03d"
  license "GPL-3.0-or-later"
  head "https://github.com/SickChill/SickChill.git", branch: "master"

  bottle do
    manifest_sha256 "901500983bc5ffe7cf878c71e40a9e576c6ca472d4574450313e199d0a08684b"
    sha256 cellar: :any, arm64_golden_gate: "aa16785f8aebac2190c31c265953d5c5bd319f9f98f032c10582d9699d052665"
    sha256 cellar: :any, arm64_tahoe:       "19d313bae02a4e90e366d4e5d976a7904c4f5713e78c5b37cc933e93f74deef2"
    sha256 cellar: :any, arm64_sequoia:     "359082bd26d8ee2c28d885e263a3811d383a8fd756a3b42ae3faf019b06fb209"
    sha256 cellar: :any, arm64_linux:       "d6c24282e8228eb134cb24544a2e692036af91cf66d2a3d4309f1fa30feeff74"
    sha256 cellar: :any, x86_64_linux:      "95fa27b79fc0a7b2c2dddfc36cf1568cd4f44730a866e4e8f57e59524cfd4597"
  end

  depends_on "rust" => :build # for cachecontrol
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  # `imdbpie` only imports `botocore`; legacy `boto` fails to build on Python 3.12+
  pypi_packages exclude_packages: %w[boto certifi cryptography]

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bencode-py" do
    url "https://files.pythonhosted.org/packages/c5/e9/97a84f30337c38f1572baa299eaeacc3ca090c6d383da9839edad166fef4/bencode_py-4.1.0.tar.gz"
    sha256 "f93372b45dc370fe4024f9230128f1f9fbc0fe30c3d41f1c3a7d02fe6c899813"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/2d/f6/c972b32d80760fb79d6b9eeb0b3010a46b89c0b23cf6329417ff7886cd22/cachecontrol-0.14.4.tar.gz"
    sha256 "e6220afafa4c22a47dd0badb319f84475d79108100d04e26e8542ef7d3ab05a1"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/47/92/3d893ac5d338b9a9af34c5b517d77492dcea8a10254254eead4215a96f3f/chardet-7.7.0.tar.gz"
    sha256 "0ba38a05201b0abf7570c12d8af45c30b2af835bd5cc52bfc7105082eda82c1e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/1d/03/454dafcda21ca579bfa3d3583edd91f283cf6fb7b9a63d00a3212e8e2d4c/click_option_group-0.5.10.tar.gz"
    sha256 "22d6a7d102b4ead6a0b8601d577386d390deae91038662f2bd1d013806184ab7"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/4e/a2/dc08c667e7e51cb035ffab38ae98d7d0f249092591130db4f67dc26b0021/decorator-5.3.2.tar.gz"
    sha256 "d9883f1b8259e3bfc42565d0bc6fdc760012008552aa449f75efd2d48319b82b"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deluge-client" do
    url "https://files.pythonhosted.org/packages/f1/53/d6672ad7b44190d578ce7520822af34e7119760df9934cad4d730b0592a2/deluge-client-1.10.2.tar.gz"
    sha256 "3881aee3c4e0ca9dd8a56b710047b837e1d087a83e421636a074771f92a9f1b5"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "enzyme" do
    url "https://files.pythonhosted.org/packages/6e/d8/a390f96ac0ccc33ca1c0e5c9cb9fc73f0623117e310594b6bc3be87005de/enzyme-0.5.2.tar.gz"
    sha256 "7cf779148d9e66eb2838603eace140c53c3cefc8b8fe5d4d5a03a5fb5d57b3c1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/6c/bf/a895b0b8e83d0a64d134f658e393e83998abfc22bbb8b58181ce55268706/filelock-4.3.0.tar.gz"
    sha256 "143407310acf479e82d88068e3b9a6486f45fb410c0ed8729fe7359eaabeb6f1"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/dc/56/695c6636debcc79bdac890e1e7120a48043a1ca825b6dc39adefa50a48f9/guessit-4.5.4.tar.gz"
    sha256 "a1a892d0a08b5bfb6211c1c99019d1e1c9568eab19d95b6e7c93ff526d5b2739"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/fb/5e/513ff06670c84e7b9887c1fdf61b2d42b4f574a831f2f1d2222023049d8a/imagesize-2.0.1.tar.gz"
    sha256 "b2ba6a4dea487a7ebcd53248d3476aca449d30db12a2dde5e0c5ca9624fd77e5"
  end

  resource "knowit" do
    url "https://files.pythonhosted.org/packages/4b/d0/96c31fa152ac3d0991e57bd109135e3ccbbd5ac668ccafb95711bcc09768/knowit-0.8.0.tar.gz"
    sha256 "46ce6bd8ad927cb4d4522c112a14878f168ccd736773bc5ac2c3c3647bd0fbeb"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/e4/ae/07d4a5fcaa5509221287d289323d75ac8eda5a5a4ac9de2accf7bbcc2b88/markdown2-2.5.5.tar.gz"
    sha256 "001547e68f6e7fcf0f1cb83f7e82f48aa7d48b2c6a321f0cd20a853a8a2d1664"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cc/52/1ec7ead2c7528bf3d1db73e886fa4df10f9e6f0eb7854a448b7090cfcef7/msgpack-1.2.4.tar.gz"
    sha256 "475c44e12f2a5de766a8448783f149c9b33f3f49b88953c6cd739a77d93c732c"
  end

  resource "new-rtorrent-python" do
    url "https://files.pythonhosted.org/packages/18/c6/67a7afff87d09baa7f43f35e94722a5affc4f0f9bd54671cf02008d9c6df/new-rtorrent-python-1.0.1a0.tar.gz"
    sha256 "7a9319d6006b98bab66e68fbd79ec353c81c6e1aea2197a4e9097fd2760d3cfb"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/33/17/2bb072de0b990303c985f26869fd47bb179024a051f47e7f9d208eb92f8e/oauthlib-4.0.1.tar.gz"
    sha256 "3d73febdb6faa00f277c81fb04be7b7586fb96fc3b7f0b9c772dada69a25ede7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "putio-py" do
    url "https://files.pythonhosted.org/packages/a6/2a/52bc4e441b680f3d50921e7142d54c8ff39a04cc13cfa1f2aca8301b24c6/putio_py-8.8.0.tar.gz"
    sha256 "f9a40959f730d0af9c6fe5c9f1dae123a4cd6b2a82f57928a1890b05fb73b4c2"
  end

  resource "pymediainfo" do
    url "https://files.pythonhosted.org/packages/4d/80/80a6fb21005b81e30f6193d45cba13857df09f5d483e0551fa6fbb3aaeed/pymediainfo-7.0.1.tar.gz"
    sha256 "0d5df59ecc615e24c56f303b8f651579c6accab7265715e5d429186d7ba21514"
  end

  resource "pysubs2" do
    url "https://files.pythonhosted.org/packages/c7/bc/3c90851b917956efbc316ac70bd699adb91722918c90a49003e8e9892489/pysubs2-1.9.1.tar.gz"
    sha256 "7c2956780d50e543d261f57417bed067249272e939da10dbd449a2446b9993af"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/cb/4e/20a9c45c4bb839e6e03e5971a546c623d12f950aa496cf344dc8e9f07167/python_discovery-1.9.6.tar.gz"
    sha256 "383aa67858d73a9585a843a37a4383c6be98e4d86a981a031328e393a6eb2632"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/5a/e6/8527e71118340258eb7e81def3f4377924528eda1e1be70fad008a31b70f/python_slugify-9.2.0.tar.gz"
    sha256 "cee32948083476013804de1667724fb1362dacb71e47b1d5d92adf8db6ee3298"
  end

  resource "python3-fanart" do
    url "https://files.pythonhosted.org/packages/2e/55/d09b26a5c3bc41e9b92cba5342f1801ea9e8c1bec0862a428401e24dfd19/python3-fanart-2.0.0.tar.gz"
    sha256 "8bfb0605ced5be0123c9aa82c392e8c307e9c65bff47d545d6413bbb643a4a74"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "qbittorrent-api" do
    url "https://files.pythonhosted.org/packages/48/5b/9d8b20d8a84ace25f235323756d3c8aa345576c428fdacabc50360dcd9ee/qbittorrent_api-2026.10.1.tar.gz"
    sha256 "70a66abf381170256240e188c825634849fd02eb2ec40bf6e157a2df8f5d484b"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/b2/eb/33ea5625de4e84144069ea021a282ea3c44ff7bd341b740bcadff028bea7/rarfile-4.5.tar.gz"
    sha256 "7425d0afa180f0092db903abb1526a130b36858980aad90b3694f48e41420155"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/95/7e/284e071fbf6dbd3c760c898b2c19cd9e6cb78452cd83ae6bf6363d8ea908/rebulk-6.0.2.tar.gz"
    sha256 "91d792483690aeb249bb56b3357598dd658f0f533066680db8c3e1b6f7dc8929"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/aa/9c/41c11853a5fb67b4639993a628182d326ffe4327eb28a125d202fb49950f/send2trash-2.2.0.tar.gz"
    sha256 "e0ac412073f7984288908d9d8b8d13c82be69a615bb513d948fa2f053447970a"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/82/77/d59ca6aa338bdd8d880234d15b7c466cb176e44502899a9df81ba2e13cd0/soupsieve-4.1.3.tar.gz"
    sha256 "13f70186c8f40bf8d0ff7bbab09a18fb149600b465269207b5e5b588f55fda08"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/3f/69/b87a540f6888ebc1f63a6e6138e8dc0827331a9be7c5eb15e3bd40a76281/sqlalchemy-2.1.9.tar.gz"
    sha256 "d700a8b2edfb26282a470333d6bc4a454c4acda4d201a3bea7b72fa76c217d28"
  end

  resource "srt" do
    url "https://files.pythonhosted.org/packages/66/b7/4a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030/srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/7a/ec/b628c3b1613fe9340de1c5daba957f5b152159ac350b6ce4ad3d2469f822/stevedore-5.10.0.tar.gz"
    sha256 "6005f32c09dc3159802a61c04862770e439e32db22f6da78ba56e8a735466882"
  end

  resource "subliminal" do
    url "https://files.pythonhosted.org/packages/e7/3d/ff49ee5bffbac38dc4d4a154d11115e854859c0d65315594090a8275e1ed/subliminal-2.8.0.tar.gz"
    sha256 "0d784e621d0fa7d173f75798427b3572d4ab071a90bc0b9a8a88f1925670f691"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tmdbsimple" do
    url "https://files.pythonhosted.org/packages/26/f4/275cbab0d90819bb902bb3cbc8b9ba48d0556a05b7f6f818b908e9366fbf/tmdbsimple-2.9.8.tar.gz"
    sha256 "746904be2d5db535a74ca2ca0f3a4d3db2d7173b5b98161fa772c303a4dca0a0"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/2b/8ff2b41620cbba0eeb0862fed21dcaa5a2ad36c6dd9bb465f9ff7a147be2/tornado-6.6.1.tar.gz"
    sha256 "28e6311402af59c8b02e3fa0f5e7d8eb465b25081381803b127d97e6a4395d5a"
  end

  resource "trakit" do
    url "https://files.pythonhosted.org/packages/1a/94/f9e905bbc91a294a30b61c7d13d8216a4e301217fdcfd0298062760d725a/trakit-0.5.0.tar.gz"
    sha256 "592a6aac08b16f04d020590662365b34116fddf79b3bad0716b4d73d0ec3b063"
  end

  resource "tus-py" do
    url "https://files.pythonhosted.org/packages/08/5b/8eeed702003b06ff507eeea986fcaf200b973935ef3849253b60755d80e9/tus_py-1.4.0.tar.gz"
    sha256 "7f4f5e44dfc8218f52a5158a6058035cf2a9e368f2369ce06191c951443a7eaa"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/e0/c3/7f507928cfbe7de639fde0118190ab17dcb8a6da83f921032859a922a5ec/virtualenv-21.15.12.tar.gz"
    sha256 "a3976f886eb6019fcb1d137b223d160adaeff524ab0ad785c729a43c31cc158c"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"sickchill", "--datadir", var/"sickchill", "--quiet", "--nolaunch"]
    keep_alive true
    working_dir var/"sickchill"
  end

  test do
    port = free_port.to_s
    with_test_process(bin/"sickchill", "--port", port, "--datadir", testpath, "--nolaunch") do
      sleep 30
      assert_path_exists testpath/"config.ini"
      assert_path_exists testpath/"sickchill.db"
    end
  end
end
