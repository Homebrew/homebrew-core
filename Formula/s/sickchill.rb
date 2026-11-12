class Sickchill < Formula
  include Language::Python::Virtualenv

  desc "Automatic Video Library Manager for TV Shows"
  homepage "https://sickchill.github.io"
  url "https://github.com/SickChill/sickchill/archive/refs/tags/2026.10.8.tar.gz"
  sha256 "52b8d786ccfb6870da996bf9b62530dd80d01e818470d8340967c3a8d006cdbb"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/SickChill/SickChill.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f115c30cec4f2bbfabd8000c54406f8d2990099a135f279afff365667ea32162"
    sha256 cellar: :any, arm64_tahoe:       "17f91c489738c5f41f877fa6d6097e6543c92e55db658fcbcd68a15b8e529bad"
    sha256 cellar: :any, arm64_sequoia:     "81976eb7ada499a17b62795599878d5b78099c4d795c62c9bb7a363a47bd020f"
    sha256 cellar: :any, arm64_linux:       "f3261724ae1e0ae8835e55397cc646d4a5b41adaf4caba73a1c0743dd035e7cf"
    sha256 cellar: :any, x86_64_linux:      "533779aa5d9a96ef459ad776c88aabf1c5dab3da6a574d4a06cba401c32dceb8"
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

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
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

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4d/92/480a2c685a9b02a947541a217ae615d5e78f287d833cc1b9f23dfc39e313/botocore-1.44.0.tar.gz"
    sha256 "224efbd3ee978856da460585533ebf1b97831960e575857ca2424f33e554917b"
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
    url "https://files.pythonhosted.org/packages/ef/ff/d291d66595b30b83d1cb9e314b2c9be7cfc7327d4a0d40a15da2416ea97b/click_option_group-0.5.9.tar.gz"
    sha256 "f94ed2bc4cf69052e0f29592bd1e771a1789bd7bfc482dd0bc482134aff95823"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deluge-client" do
    url "https://files.pythonhosted.org/packages/f1/53/d6672ad7b44190d578ce7520822af34e7119760df9934cad4d730b0592a2/deluge-client-1.10.2.tar.gz"
    sha256 "3881aee3c4e0ca9dd8a56b710047b837e1d087a83e421636a074771f92a9f1b5"
  end

  resource "diskcache-community" do
    url "https://files.pythonhosted.org/packages/ab/19/7b58d6973c4021034936d595051916e850549bff096dffa3edefcd3310b2/diskcache_community-5.8.4.tar.gz"
    sha256 "ed359124af93879978b2851a81f437c4e708f946e4ee5db7256b95f562ee0eeb"
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
    url "https://files.pythonhosted.org/packages/a1/cf/05bcdacabdc0aec7dc8e19d76281bd82325df62dae3b6430e9ba57397689/filelock-4.2.10.tar.gz"
    sha256 "fcc3c0cb8bfe7f4b3bb0e231c04b15dbad068cb3c2515f343d8fde4dce93bd5d"
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
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/67/22/4a0e35d27d9537e7f03753e0814f4525200e866e43b1c6bd29d901fbac03/guessit-4.5.1.tar.gz"
    sha256 "df09f2bd6f4ab24eb7960422292cc2332be7bd7d338ff14511b9d1174a78e383"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/pull/589"
    end

    # Python 3.14 with setuptools 81+ compatibility (`pkg_resources` removal)
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/1dbc19cd6db72cb919885827bc4883423e0cb647.patch?full_index=1"
      sha256 "5951b823f353dd70806ad6e163ab8f46899496c1e8bb53970c99abe8d1df1a78"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/pull/592"
    end
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
    url "https://files.pythonhosted.org/packages/cf/59/4b0dd64676aa6fb4986a755790cb6fc558559cf0084effad516820208ec3/imagesize-1.5.0.tar.gz"
    sha256 "8bfc5363a7f2133a89f0098451e0bcb1cd71aba4dc02bbcecb39d99d40e1b94f"
  end

  resource "imdbpie" do
    url "https://files.pythonhosted.org/packages/4b/84/ca3046e6b5880243e17e7bcffc1691017f77cb6df3a3578dca47794ab01a/imdbpie-5.8.1.tar.gz"
    sha256 "de0fc8debf91800f3eb6b82c515ad52c6133e9098802ffdac57c04579f31b7b5"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "js2py" do
    url "https://files.pythonhosted.org/packages/cb/a5/3d8b3e4511cc21479f78f359b1b21f1fb7c640988765ffd09e55c6605e3b/Js2Py-0.74.tar.gz"
    sha256 "39f3a6aa8469180efba3c8677271df27c31332fd1b471df1af2af58b87b8972f"
  end

  resource "jsonrpclib-pelix" do
    url "https://files.pythonhosted.org/packages/b4/47/b6231a142df47d951c61d6eb0dd4a3a7b07de6ac77dac1656a9783a2d219/jsonrpclib_pelix-1.2.0.tar.gz"
    sha256 "353b66707c0fc4263edc8fd6bbd471b7aede823a83e4dbf1614b0c83aee20f18"
  end

  resource "knowit" do
    url "https://files.pythonhosted.org/packages/c5/fe/5a7691c55e27051a9b9d2657e8417b5bc927524db1507683111d54192542/knowit-0.7.1.tar.gz"
    sha256 "66e5601873c18776411eb18294a17ddfef9243e64bf9635df8cf6549090bbb80"
  end

  resource "kodipydent-alt" do
    url "https://files.pythonhosted.org/packages/dd/77/6695c399c31ffca5efa10eef3d07fd2b6b24176260477a909d35f0fc1a0b/kodipydent-alt-2022.9.3.tar.gz"
    sha256 "61fc4e5565646a799c783bcf5ae7503223513906e3242bff2ecc8aa66dc80826"
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
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "profilehooks" do
    url "https://files.pythonhosted.org/packages/18/5a/c69fdf542b730c74b9de1cc2cc02692cd5d6a34a9d95e29217262937f91e/profilehooks-1.13.0.tar.gz"
    sha256 "54a541cad49ddccee97b61a617404d7d736bf0bf79d36fbe2ac7caa3a1d9daaf"
  end

  resource "putio-py" do
    url "https://files.pythonhosted.org/packages/a6/2a/52bc4e441b680f3d50921e7142d54c8ff39a04cc13cfa1f2aca8301b24c6/putio_py-8.8.0.tar.gz"
    sha256 "f9a40959f730d0af9c6fe5c9f1dae123a4cd6b2a82f57928a1890b05fb73b4c2"
  end

  resource "pyjsparser" do
    url "https://files.pythonhosted.org/packages/48/ef/c72abcfa2c6accd03e7c89c400790fc3d908c5804d50a7c4e9ceabd74d23/pyjsparser-2.7.1.tar.gz"
    sha256 "be60da6b778cc5a5296a69d8e7d614f1f870faf94e1b1b6ac591f2ad5d729579"
  end

  resource "pymediainfo" do
    url "https://files.pythonhosted.org/packages/4d/80/80a6fb21005b81e30f6193d45cba13857df09f5d483e0551fa6fbb3aaeed/pymediainfo-7.0.1.tar.gz"
    sha256 "0d5df59ecc615e24c56f303b8f651579c6accab7265715e5d429186d7ba21514"
  end

  resource "pynma" do
    url "https://files.pythonhosted.org/packages/6e/94/37a7ee7b0b8adec69797c3ac1b9a158f6b1ecb608bfe289d155c3b4fc816/PyNMA-1.0.tar.gz"
    sha256 "f90a7f612d508b628daf022068967d2a103ba9b2355b53df12600b8e86ce855b"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/74/b7/da07bae88f5a9506b4def6f2f4903cf4c3b8831e560dba8fa18ca08f758f/pyopenssl-26.3.0.tar.gz"
    sha256 "589de7fae1c9ea670d18422ed00fc04da787bbde8e1454aea872aa57b49ad341"
  end

  resource "pysubs2" do
    url "https://files.pythonhosted.org/packages/c7/bc/3c90851b917956efbc316ac70bd699adb91722918c90a49003e8e9892489/pysubs2-1.9.1.tar.gz"
    sha256 "7c2956780d50e543d261f57417bed067249272e939da10dbd449a2446b9993af"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/68/55/70b46fae646bc6f5cb5e82569949d925cff1c7b5ce20ec4a11e0d977f8c6/python_discovery-1.9.5.tar.gz"
    sha256 "86279f5d2728bc067de28b7ddc571be2eacc2ae0e7048f8629d2481a0f8848a2"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/bd/e8/26b1af09d728d604dc16427a39f53985b22a170dbd61addac3f48db73f03/python_slugify-9.1.3.tar.gz"
    sha256 "90e997f2e0987239ce95e12f700086eb18e1d1d3ee22624fbbdbd095afca42b6"
  end

  resource "python-twitter" do
    url "https://files.pythonhosted.org/packages/59/63/5941b988f1a119953b046ae820bc443ada3c9e0538a80d67f3938f9418f1/python-twitter-3.5.tar.gz"
    sha256 "45855742f1095aa0c8c57b2983eee3b6b7f527462b50a2fa8437a8b398544d90"
  end

  resource "python3-fanart" do
    url "https://files.pythonhosted.org/packages/2e/55/d09b26a5c3bc41e9b92cba5342f1801ea9e8c1bec0862a428401e24dfd19/python3-fanart-2.0.0.tar.gz"
    sha256 "8bfb0605ced5be0123c9aa82c392e8c307e9c65bff47d545d6413bbb643a4a74"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
    url "https://files.pythonhosted.org/packages/c5/f0/184b4b5f8d00f2a92cf96eec8967a3d550b52cf94362dad1100df9e48d57/send2trash-2.1.0.tar.gz"
    sha256 "1c72b39f09457db3c05ce1d19158c2cbef4c32b8bedd02c155e49282b7ea7459"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/95/48/21a393ff731b8f928fa4f8176f9a7ceba2252ee60a5149f25b45c292aa5c/soupsieve-4.1.tar.gz"
    sha256 "ca9abf7126667010d8f6e9b39bfc1bc3b23c8aed9bcb0f54a754dde969bb8aab"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/9c/e7/2855174facf54a83b4fa3eddcece3631c6bdae43605dacd69cc3b6794319/sqlalchemy-2.1.8.tar.gz"
    sha256 "8bc4081dd7c17c073f2384ad0f5ee968e63b43507b2e024a3523c000a06d70da"
  end

  resource "srt" do
    url "https://files.pythonhosted.org/packages/66/b7/4a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030/srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
  end

  resource "subliminal" do
    url "https://files.pythonhosted.org/packages/56/05/3529ed61f1471fe7c01a6a14183e21c12f3ae09dc79f796962a484d91f28/subliminal-2.6.0.tar.gz"
    sha256 "e6e7aee1b218d543dcb3b7b2248ea0f92afc4c223ce3e7af8d2c3843e31bafe5"
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

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/2b/8ff2b41620cbba0eeb0862fed21dcaa5a2ad36c6dd9bb465f9ff7a147be2/tornado-6.6.1.tar.gz"
    sha256 "28e6311402af59c8b02e3fa0f5e7d8eb465b25081381803b127d97e6a4395d5a"
  end

  resource "trakit" do
    url "https://files.pythonhosted.org/packages/47/35/e2273b5152ff6f77b9dd6449547c4d14bfb170fa00893f64fd785ec67116/trakit-0.4.0.tar.gz"
    sha256 "bdf04ca6840ce25f60bc31c4496832e8c14167725b9240badf0e2edf38bb7305"
  end

  resource "tus-py" do
    url "https://files.pythonhosted.org/packages/08/5b/8eeed702003b06ff507eeea986fcaf200b973935ef3849253b60755d80e9/tus_py-1.4.0.tar.gz"
    sha256 "7f4f5e44dfc8218f52a5158a6058035cf2a9e368f2369ce06191c951443a7eaa"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/d8/89/2bd035df331499589fc92e59375c17c6cea6a500453b2c5f6a6ec9572825/tzlocal-5.4.5.tar.gz"
    sha256 "ba976898bad27945178c9ca25c222c19e322b30c10342b9f40b46714f70d2d5f"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/53/66/a435d9ae49850b2f071f7ebd8119dd4e84872b01630d6736761e6e7fd847/validators-0.35.0.tar.gz"
    sha256 "992d6c48a4e77c81f1b4daba10d16c3a9bb0dbb79b3a19ea847ff0928e70497a"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b3/bd/e40ad2df6a9efc1f859ea23d63fd7371cff68252833f182ca9af819bb4d3/virtualenv-21.15.6.tar.gz"
    sha256 "c8b65c7d206ca6ef18de9352c160b3f04f66fff9f6b0ec8fd31f14688eba52c4"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
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
