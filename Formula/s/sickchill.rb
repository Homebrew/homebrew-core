class Sickchill < Formula
  include Language::Python::Virtualenv

  desc "Automatic Video Library Manager for TV Shows"
  homepage "https://sickchill.github.io"
  url "https://files.pythonhosted.org/packages/31/fc/337b2989dc67bbb505cea34a05c029cbba3056311177586835f704ddc13a/sickchill-2024.3.1.tar.gz"
  sha256 "e7079bb77b415eb6697a63d9018db1ad317d06ad285d0d77893747cbf000aa17"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca63d4eadaf57c83b555b06d053c820e301127790f74d274363f898798e805cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c7b3a360dc2ed4f29b760f4aec808c1fe4c9799af68212209b9d548d3e0a58a"
    sha256 cellar: :any,                 arm64_monterey: "d0c69a836838a645b7bbd30cc4b2728fb20d04d4bd7c897314485cd28af607cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "71464ac6e7667f48af74add021d7e189e1529d9e7ea2ee7cbf3681fc565a18d6"
    sha256 cellar: :any_skip_relocation, ventura:        "31379000bdb110072b7e8fbd4859527d077e1686a3fef19d6bed162d5e76127c"
    sha256 cellar: :any,                 monterey:       "d20d22d4dd6c676e1f1764630b900472ba22277c77cd22dad3e140fb428d105b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46daf35ab5d87a83b5a38e1717360e849999a3bf9db65fe1b38bed51e65481c"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/02/0d/e72bf59672ebceae99cd339106df2b0d59964e00a04f7286ae9279d9da6c/babelfish-0.6.0.tar.gz"
    sha256 "2dadfadd1b205ca5fa5dc9fa637f5b7933160a0418684c7c46a7a664033208a2"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "beekeeper-alt" do
    url "https://files.pythonhosted.org/packages/28/68/b1c59d68275715e5174c0ec0185d3ceca3223933a6a35cda31389438e545/beekeeper-alt-2022.9.3.tar.gz"
    sha256 "18addaa163febd69a9e1ec4ec4dddc210785c94c6c1f9b2bcb2a73451b2f23e3"
  end

  resource "bencode-py" do
    url "https://files.pythonhosted.org/packages/e8/6f/1fc1f714edc73a9a42af816da2bda82bbcadf1d7f6e6cae854e7087f579b/bencode.py-4.0.0.tar.gz"
    sha256 "2a24ccda1725a51a650893d0b63260138359eaa299bb6e7a09961350a2a6e05c"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/06/55/edea9d90ee57ca54d34707607d15c20f72576b96cb9f3e7fc266cb06b426/cachecontrol-0.14.0.tar.gz"
    sha256 "7db1195b41c81f8274a7bbd97c956f44e8348265a1bc7641c37dfebc39f0c938"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cinemagoer" do
    url "https://files.pythonhosted.org/packages/06/de/3aa6eb738b5c5e39f1909bc080a392842841f9af866edb960de2f22af53c/cinemagoer-2023.5.1.tar.gz"
    sha256 "5ce1d77ae6546701618f11e5b1556a19d18edecad1b6d7d96973ec34941b18f2"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deluge-client" do
    url "https://files.pythonhosted.org/packages/f1/53/d6672ad7b44190d578ce7520822af34e7119760df9934cad4d730b0592a2/deluge-client-1.10.2.tar.gz"
    sha256 "3881aee3c4e0ca9dd8a56b710047b837e1d087a83e421636a074771f92a9f1b5"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/94/c9/99a8cc80eace8877845b08bbccc43147afdc9830f604cbd9f8619bfb0409/dogpile.cache-1.3.2.tar.gz"
    sha256 "4f71dc0333ad351c9c6f704f5ba2a37bf51c6eed0437d1adf56e075959afe63b"
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
    url "https://files.pythonhosted.org/packages/17/14/3bddb1298b9a6786539ac609ba4b7c9c0842e12aa73aaa4d8d73ec8f8185/greenlet-3.0.3.tar.gz"
    sha256 "43374442353259554ce33599da8b692d5aa96f8976d567d4badf263371fbe491"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/d0/07/5a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cd/guessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "jsonrpclib-pelix" do
    url "https://files.pythonhosted.org/packages/f5/10/839b1d2cbd6157e4b09d4499c849b48127cd1d761e1d5bfeb1522c8be50d/jsonrpclib-pelix-0.4.3.2.tar.gz"
    sha256 "e9e0b33efa8fa20d817dd78dfd9e4cdb3967c8a5d3cb5a783be1ee81c4a89c7c"
  end

  resource "kodipydent-alt" do
    url "https://files.pythonhosted.org/packages/dd/77/6695c399c31ffca5efa10eef3d07fd2b6b24176260477a909d35f0fc1a0b/kodipydent-alt-2022.9.3.tar.gz"
    sha256 "61fc4e5565646a799c783bcf5ae7503223513906e3242bff2ecc8aa66dc80826"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/d4/1b/71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072/Mako-1.3.2.tar.gz"
    sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/74/89/a6bb59171d0bd5a3b19deb834ec29378a7c8e05bcb0a4dd4e5cb418ea03b/markdown2-2.4.13.tar.gz"
    sha256 "18ceb56590da77f2c22382e55be48c15b3c8f0c71d6398def387275e6c347a9f"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/08/4c/17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087/msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "new-rtorrent-python" do
    url "https://files.pythonhosted.org/packages/18/c6/67a7afff87d09baa7f43f35e94722a5affc4f0f9bd54671cf02008d9c6df/new-rtorrent-python-1.0.1a0.tar.gz"
    sha256 "7a9319d6006b98bab66e68fbd79ec353c81c6e1aea2197a4e9097fd2760d3cfb"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "profilehooks" do
    url "https://files.pythonhosted.org/packages/f7/73/25ef2a50d78a463297228e85e0b1e34099a774c54ec169c21b1f5e5152c6/profilehooks-1.12.0.tar.gz"
    sha256 "05b87589df8a8c630fd701bae6008cc1cfff4457bd0064887ad25248327a5ba3"
  end

  resource "putio-py" do
    url "https://files.pythonhosted.org/packages/7a/63/af072aadbb7fb643588e41dd8b434ee47238fcb15f04976101fae38b1b12/putio.py-8.7.0.tar.gz"
    sha256 "ecfbedeada74a2c7540a665c4d5b9bb147b32fbdb90c40149e65b3786f0e7300"
  end

  resource "pynma" do
    url "https://files.pythonhosted.org/packages/6e/94/37a7ee7b0b8adec69797c3ac1b9a158f6b1ecb608bfe289d155c3b4fc816/PyNMA-1.0.tar.gz"
    sha256 "f90a7f612d508b628daf022068967d2a103ba9b2355b53df12600b8e86ce855b"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
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
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "qbittorrent-api" do
    url "https://files.pythonhosted.org/packages/01/5f/c5f6e791ffbf0eb7ac8fde3d16b383a58aa97aa15355e86bed2847ba8baa/qbittorrent-api-2024.2.59.tar.gz"
    sha256 "db6eef9ce26661cadb61df0c8d31bc73cdac7f76b034e17f6f101bcb426549f0"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/d7/ee/b3f1e882c4fcfaf3a33bb12d5ef77d7f1b92474628d2aedcab231a21cfb4/rarfile-4.1.tar.gz"
    sha256 "db60b3b5bc1c4bdeb941427d50b606d51df677353385255583847639473eda48"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/f2/06/24c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296/rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/4a/d2/d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551/Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/b9/fc/327f0072d1f5231d61c715ad52cb7819ec60f0ac80dc1e507bc338919caa/SQLAlchemy-2.0.27.tar.gz"
    sha256 "86a6ed69a71fe6b88bf9331594fa390a2adda4a49b5c06f98e47bf0d392534f8"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/e7/c1/b210bf1071c96ecfcd24c2eeb4c828a2a24bf74b38af13896d02203b1eec/stevedore-5.2.0.tar.gz"
    sha256 "46b93ca40e1114cea93d738a6c1e365396981bb6bb78c27045b7587c9473544d"
  end

  resource "subliminal" do
    url "https://files.pythonhosted.org/packages/dd/3a/ac02011988ad013f24a11cb6123a7ff9e17a75369964c7edd9f64bfea80f/subliminal-2.1.0.tar.gz"
    sha256 "c6439cc733a4f37f01f8c14c096d44fd28d75d1f6f6e2d1d1003b1b82c65628b"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  # upstream issue report, https://github.com/hustcc/timeago/issues/45
  resource "timeago" do
    url "https://github.com/hustcc/timeago/archive/refs/tags/1.0.16.tar.gz"
    sha256 "7b54b88b3d0566cbf01ca11077dad8f7ae07a4318479e3d1b30feebe85f7137f"
  end

  resource "tmdbsimple" do
    url "https://files.pythonhosted.org/packages/a1/87/3309cb03df1c9f9895fccd87e9875050f19e2cfec5a50b9d72e50d420fc8/tmdbsimple-2.9.1.tar.gz"
    sha256 "636eaaaec82027929e8a91c2166e01f552ec63f869bf1fcd65aa561b705c7464"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/bd/a2/ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2/tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
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
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/f7/89/19151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3e/Unidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
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
    begin
      port = free_port.to_s

      pid = fork do
        exec bin/"sickchill", "--port", port, "--datadir", testpath, "--nolaunch"
      end
      sleep 30
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
    assert_predicate testpath/"config.ini", :exist?
    assert_predicate testpath/"sickchill.db", :exist?
  end
end
