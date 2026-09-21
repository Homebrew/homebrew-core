class Sickchill < Formula
  include Language::Python::Virtualenv

  desc "Automatic Video Library Manager for TV Shows"
  homepage "https://sickchill.github.io"
  url "https://files.pythonhosted.org/packages/31/fc/337b2989dc67bbb505cea34a05c029cbba3056311177586835f704ddc13a/sickchill-2024.3.1.tar.gz"
  sha256 "e7079bb77b415eb6697a63d9018db1ad317d06ad285d0d77893747cbf000aa17"
  license "GPL-3.0-or-later"
  revision 8
  head "https://github.com/SickChill/SickChill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb5ea863b1a82e1fda42eac281e3d9f449716780dd55bf0d1297a389f9a616db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "012e8ead5adecf2255c06f25d312430d75fa35367b3de3417a0559877886c4ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6b479f58aa5f75aee955b4fa0d25216dd53828c1f29367c407f5ca212099c72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "41791c6fa366c2e7f6317904c6292e0e2d8ba89b2285a1d4b0cad816de050ad1"
    sha256 cellar: :any,                 arm64_linux:       "d7ba3e748b24d73547e77d057e2da03202e66e28e65e15b7cf88460274ec4fef"
    sha256 cellar: :any,                 x86_64_linux:      "e716c37f919cb62cdebbd8de042e97a0b074f630cc6a52b8d44a9866313b2e0a"
  end

  depends_on "rust" => :build # for cachecontrol
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography],
                # For `setuptools``, `enzyme` requires `setuptools<82`
                # For `stevedore`, `subliminal` requires `stevedore<5.6.0` to keep method signature compatibility
                extra_packages:   %w[setuptools<82 stevedore==5.5.0]

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

  resource "beekeeper-alt" do
    url "https://files.pythonhosted.org/packages/28/68/b1c59d68275715e5174c0ec0185d3ceca3223933a6a35cda31389438e545/beekeeper-alt-2022.9.3.tar.gz"
    sha256 "18addaa163febd69a9e1ec4ec4dddc210785c94c6c1f9b2bcb2a73451b2f23e3"
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
    url "https://files.pythonhosted.org/packages/b1/51/cd61c567092a6cec796144510a68aff158ebfc1df82950a45bae65f28413/chardet-7.6.0.tar.gz"
    sha256 "93d9df6089ded42ed1fe9f57e272c0b74bd0464d45c0c7d50f09f26f31105c3c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "cinemagoer" do
    url "https://files.pythonhosted.org/packages/06/de/3aa6eb738b5c5e39f1909bc080a392842841f9af866edb960de2f22af53c/cinemagoer-2023.5.1.tar.gz"
    sha256 "5ce1d77ae6546701618f11e5b1556a19d18edecad1b6d7d96973ec34941b18f2"

    # Replace `pkgutil.find_loader` removed in 3.14: https://github.com/cinemagoer/cinemagoer/pull/543
    patch do
      url "https://github.com/cinemagoer/cinemagoer/commit/fec0b1a0f90e2d6201f6fa5fd429f13d9b7a747d.patch?full_index=1"
      sha256 "a9f225c42d011f07e0aabb9b29f19c666f8808206787d7e53f9d56df4d749edd"
      type :backport
      resolves "https://github.com/cinemagoer/cinemagoer/pull/543"
    end
    # Backport https://github.com/cinemagoer/cinemagoer/commit/88a86cdacc7737d0fcfe299ad7a2e9b365ff379c and
    # https://github.com/cinemagoer/cinemagoer/commit/cb4b61c3be3d7ed0bfc4f3cb506628c3cbb59828
    patch :DATA
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "deluge-client" do
    url "https://files.pythonhosted.org/packages/f1/53/d6672ad7b44190d578ce7520822af34e7119760df9934cad4d730b0592a2/deluge-client-1.10.2.tar.gz"
    sha256 "3881aee3c4e0ca9dd8a56b710047b837e1d087a83e421636a074771f92a9f1b5"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "enzyme" do
    url "https://files.pythonhosted.org/packages/dd/99/e4eee822d9390ebf1f63a7a67e8351c09fb7cd75262e5bb1a5256898def9/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "gntp" do
    url "https://files.pythonhosted.org/packages/c4/6c/fabf97b5260537065f32a85930eb62776e80ba8dcfed78d4247584fd9aa9/gntp-1.0.3.tar.gz"
    sha256 "f4a4f2009ecb8bb41a1aaddd5fb7c03087b2a14cac2c03af029ba04b9166dae0"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/0b/d8/7cc97c142388aef03f622e001c572c4f84e9252a439549d483f555771970/greenlet-3.5.5.tar.gz"
    sha256 "adb4bae02e91a8e863e48b177e4014bdcac8a6b5e047ea1df687a61534b85e6c"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/d0/07/5a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cd/guessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/cf/59/4b0dd64676aa6fb4986a755790cb6fc558559cf0084effad516820208ec3/imagesize-1.5.0.tar.gz"
    sha256 "8bfc5363a7f2133a89f0098451e0bcb1cd71aba4dc02bbcecb39d99d40e1b94f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "jsonrpclib-pelix" do
    url "https://files.pythonhosted.org/packages/79/21/51a59adb17c2aa27ec3cef8787485df66e06c29f08e19a9d554e45b8f56d/jsonrpclib_pelix-0.4.3.4.tar.gz"
    sha256 "e82d6f4da907a7d111ef93fd2361c8c20b79d248be4fe99678e08626aa8fcbef"
  end

  resource "kodipydent-alt" do
    url "https://files.pythonhosted.org/packages/dd/77/6695c399c31ffca5efa10eef3d07fd2b6b24176260477a909d35f0fc1a0b/kodipydent-alt-2022.9.3.tar.gz"
    sha256 "61fc4e5565646a799c783bcf5ae7503223513906e3242bff2ecc8aa66dc80826"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ad/a9/970b8fa0ecc4fbf1dfaed0d89bbc1fc1421b25ec26a2038c91e872dc6c8e/lxml-6.1.2.tar.gz"
    sha256 "1055241852f2b02068af4a625a5d32c087db193c12251928af2562ecd2239f18"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/2a/12/b5fa2353e2754cd67fb9f83793fa48ff42c213a5da7e719869d2301f6ab8/mako-1.4.1.tar.gz"
    sha256 "d7904710b662996425a21627710c4777c45053146942cf8a7aebf757c92b8c27"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/e4/ae/07d4a5fcaa5509221287d289323d75ac8eda5a5a4ac9de2accf7bbcc2b88/markdown2-2.5.5.tar.gz"
    sha256 "001547e68f6e7fcf0f1cb83f7e82f48aa7d48b2c6a321f0cd20a853a8a2d1664"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/6d/44/ea2100ec54d30c46ee9dba10a3bfb79b655e96c6df237238a3234c75869b/msgpack-1.2.2.tar.gz"
    sha256 "9eb0b0e602064527a045ea28c4f174ed69383587e29cebe28947e3b84106eb2a"
  end

  resource "new-rtorrent-python" do
    url "https://files.pythonhosted.org/packages/18/c6/67a7afff87d09baa7f43f35e94722a5affc4f0f9bd54671cf02008d9c6df/new-rtorrent-python-1.0.1a0.tar.gz"
    sha256 "7a9319d6006b98bab66e68fbd79ec353c81c6e1aea2197a4e9097fd2760d3cfb"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "profilehooks" do
    url "https://files.pythonhosted.org/packages/18/5a/c69fdf542b730c74b9de1cc2cc02692cd5d6a34a9d95e29217262937f91e/profilehooks-1.13.0.tar.gz"
    sha256 "54a541cad49ddccee97b61a617404d7d736bf0bf79d36fbe2ac7caa3a1d9daaf"
  end

  resource "putio-py" do
    url "https://files.pythonhosted.org/packages/a6/2a/52bc4e441b680f3d50921e7142d54c8ff39a04cc13cfa1f2aca8301b24c6/putio_py-8.8.0.tar.gz"
    sha256 "f9a40959f730d0af9c6fe5c9f1dae123a4cd6b2a82f57928a1890b05fb73b4c2"
  end

  resource "pynma" do
    url "https://files.pythonhosted.org/packages/6e/94/37a7ee7b0b8adec69797c3ac1b9a158f6b1ecb608bfe289d155c3b4fc816/PyNMA-1.0.tar.gz"
    sha256 "f90a7f612d508b628daf022068967d2a103ba9b2355b53df12600b8e86ce855b"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/c1/d4/1067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085/pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
  end

  resource "pysrt" do
    url "https://files.pythonhosted.org/packages/31/1a/0d858da1c6622dcf16011235a2639b0a01a49cecf812f8ab03308ab4de37/pysrt-1.1.2.tar.gz"
    sha256 "b4f844ba33e4e7743e9db746492f3a193dc0bc112b153914698e7c1cdeb9b0b9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "python-twitter" do
    url "https://files.pythonhosted.org/packages/59/63/5941b988f1a119953b046ae820bc443ada3c9e0538a80d67f3938f9418f1/python-twitter-3.5.tar.gz"
    sha256 "45855742f1095aa0c8c57b2983eee3b6b7f527462b50a2fa8437a8b398544d90"
  end

  resource "python3-fanart" do
    url "https://files.pythonhosted.org/packages/2e/55/d09b26a5c3bc41e9b92cba5342f1801ea9e8c1bec0862a428401e24dfd19/python3-fanart-2.0.0.tar.gz"
    sha256 "8bfb0605ced5be0123c9aa82c392e8c307e9c65bff47d545d6413bbb643a4a74"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/fb/48/fb042503b6ca6cd271261dc559fd6432f7d8c713153e9ec5c591af4dfc1c/pytz-2026.3.post1.tar.gz"
    sha256 "2211d3fcf9a797d3405cac96ac7f61d80e6a644f72a3309607282fe8a2010c5d"
  end

  resource "qbittorrent-api" do
    url "https://files.pythonhosted.org/packages/d6/a9/88fce9b8c5e79bac74b0e9624ec8af2da8280dddc87f91298178aafb7759/qbittorrent_api-2024.12.71.tar.gz"
    sha256 "4bb62ac075826d47529de562896bd97fe8527d2f55851ac3611d7b221c4507e2"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/b2/eb/33ea5625de4e84144069ea021a282ea3c44ff7bd341b740bcadff028bea7/rarfile-4.5.tar.gz"
    sha256 "7425d0afa180f0092db903abb1526a130b36858980aad90b3694f48e41420155"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/09/d4/77c29644d1f9b1ef2881211c9c2a0f89d437f28c80edbc74c698f23055bd/rebulk-6.0.1.tar.gz"
    sha256 "d6df0c8c896e160087c6981f3770ed513ec973a9f4066b9e4b0614eb08ba0ce1"
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
    url "https://files.pythonhosted.org/packages/c5/f0/184b4b5f8d00f2a92cf96eec8967a3d550b52cf94362dad1100df9e48d57/send2trash-2.1.0.tar.gz"
    sha256 "1c72b39f09457db3c05ce1d19158c2cbef4c32b8bedd02c155e49282b7ea7459"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/0d/1c/73e719955c59b8e424d015ab450f51c0af856ae46ea2da83eba51cc88de1/setuptools-81.0.0.tar.gz"
    sha256 "487b53915f52501f0a79ccfd0c02c165ffe06631443a886740b91af4b7a5845a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/69/99/a6ca3beb3ccacb41fb3321d8a60e5566f9e6467601ef8eba6a17e1b89778/soupsieve-2.9.2.tar.gz"
    sha256 "4a55d8cf158a9c2e587fa4922f1bbb91d68ac829e2d6f25403a85747c71daf74"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/3b/21/77b4c147963073040dc3c3a5cb7a8c3001a1893c0209432cb77f9df836aa/sqlalchemy-2.0.52.tar.gz"
    sha256 "5e2d46356ac2ccb7d268ab6c2319ac6a2b42f1b8d5fd8bd3d46855cd82abee97"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/2a/5f/8418daad5c353300b7661dd8ce2574b0410a6316a8be650a189d5c68d938/stevedore-5.5.0.tar.gz"
    sha256 "d31496a4f4df9825e1a1e4f1f74d19abb0154aff311c3b376fcc89dae8fccd73"
  end

  resource "subliminal" do
    url "https://files.pythonhosted.org/packages/dd/3a/ac02011988ad013f24a11cb6123a7ff9e17a75369964c7edd9f64bfea80f/subliminal-2.1.0.tar.gz"
    sha256 "c6439cc733a4f37f01f8c14c096d44fd28d75d1f6f6e2d1d1003b1b82c65628b"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "timeago" do
    url "https://files.pythonhosted.org/packages/5f/88/8dac5496354650972434966ba570a4a824fafed43471cf190faea4b085fc/timeago-1.0.16-py3-none-any.whl"
    sha256 "9b8cb2e3102b329f35a04aa4531982d867b093b19481cfbb1dac7845fa2f79b0"
  end

  resource "tmdbsimple" do
    url "https://files.pythonhosted.org/packages/26/f4/275cbab0d90819bb902bb3cbc8b9ba48d0556a05b7f6f818b908e9366fbf/tmdbsimple-2.9.8.tar.gz"
    sha256 "746904be2d5db535a74ca2ca0f3a4d3db2d7173b5b98161fa772c303a4dca0a0"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/10/d3/343e5bb989d6515b1646cf3d40135d73f3d5e45339bded401b56cdac24dd/tornado-6.5.8.tar.gz"
    sha256 "9452e1b208a8bd771e2cb1f2ff564985b9b214bdebbe622793e1799e0a6bd23f"
  end

  resource "tus-py" do
    url "https://files.pythonhosted.org/packages/54/3c/266c0aadca8969b8f4832e4975a86afe9c869b3ee6918a408b03619746d6/tus.py-1.3.4.tar.gz"
    sha256 "b80feda87700aae629eb19dd98cec68ae520cd9b2aa24bd0bab2b777be0b4366"
  end

  resource "tvdbsimple" do
    url "https://files.pythonhosted.org/packages/73/7d/b8e4d5c5473d6f9a492bf30916fdbf96f06034e6d23fde31ccb86704e41c/tvdbsimple-1.0.6.tar.gz"
    sha256 "a8665525fa8b7aaf1e15fc3eec18b6f181582e25468830f300ab3809dbe948fe"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/9b/21/40a249498eee5a244a017582c06c0af01851179e2617928063a3d628bc8f/validators-0.22.0.tar.gz"
    sha256 "77b2689b172eeeb600d9605ab86194641670cdb73b60afd577142a9397873370"
  end

  resource "win-inet-pton" do
    url "https://files.pythonhosted.org/packages/d9/da/0b1487b5835497dea00b00d87c2aca168bb9ca2e2096981690239e23760a/win_inet_pton-1.1.0.tar.gz"
    sha256 "dd03d942c0d3e2b1cf8bab511844546dfa5f74cb61b241699fa379ad707dea4f"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
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
    pid = spawn bin/"sickchill", "--port", port, "--datadir", testpath, "--nolaunch"
    sleep 30
    assert_path_exists testpath/"config.ini"
    assert_path_exists testpath/"sickchill.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

__END__
diff --git a/imdb/parser/http/piculet.py b/imdb/parser/http/piculet.py
index d0c2b7b..806c9f0 100644
--- a/imdb/parser/http/piculet.py
+++ b/imdb/parser/http/piculet.py
@@ -32,7 +32,7 @@ from argparse import ArgumentParser
 from collections import deque
 from functools import partial
 from operator import itemgetter
-from pkgutil import find_loader
+from importlib.util import find_spec

 __version__ = '1.2b1'

@@ -202,7 +202,7 @@ def html_to_xhtml(document, omit_tags=None, omit_attrs=None):
 # sigalias: XPathResult = Union[Sequence[str], Sequence[Element]]


-_USE_LXML = find_loader('lxml') is not None
+_USE_LXML = find_spec('lxml') is not None
 if _USE_LXML:
     from lxml import etree as ElementTree
     from lxml.etree import Element
