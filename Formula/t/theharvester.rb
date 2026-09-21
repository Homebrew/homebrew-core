class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "https://www.edge-security.com"
  url "https://github.com/laramies/theHarvester/archive/refs/tags/4.11.1.tar.gz"
  sha256 "73a931f6e346972939203a82ae38fed24570b3137bfce5d1ae5517e8284df6df"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/laramies/theHarvester.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "18d87f08113c98ae6701382c2a3e97f1e06142891d81c350a6aa8665134713a1"
    sha256 cellar: :any, arm64_tahoe:       "3b958689893b72f40caf8eb9f94acf5442787d863d9eb9e7c0894a2bdec7c0ac"
    sha256 cellar: :any, arm64_sequoia:     "3f3bf7bf525c3666cbd9520ceb8eb6bb693916522611fe4a692d1cce0c65e866"
    sha256 cellar: :any, arm64_linux:       "04a2f6a2ae39f42d7ff6ba5c76ab59ecafe676f6b967bbbe786268932268fc4a"
    sha256 cellar: :any, x86_64_linux:      "83d384ebb6c9be8207fe57ff916da57f2f3ad850902131d1d73f1906de011915"
  end

  depends_on "cmake" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[cffi certifi playwright pydantic],
                extra_packages:   %w[greenlet pyee]

  # No sdist on PyPI, so we use the GitHub tarball
  # Ref: https://github.com/microsoft/playwright-python/issues/2579
  resource "playwright" do
    url "https://github.com/microsoft/playwright-python/archive/refs/tags/v1.62.0.tar.gz"
    sha256 "30cc72a0c00a22c3d287539233d3d6abd579becbfe7d02aef80bd3e75c951455"

    livecheck do
      url :url
    end
  end

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/9b/22/a2d928e0e42baad0471d12ec44c71152ac870486e8298dddb2893b888c29/aiodns-4.0.4.tar.gz"
    sha256 "cb10e0c0d2591636716ad2fe402e977c16d71bdaf76bb8cb49e8a6633596f736"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/41/c3/534eac40372d8ee36ef40df62ec129bee4fdb5ad9706e58a29be53b2c970/aiofiles-25.1.0.tar.gz"
    sha256 "a8d728f0a29de45dc521f18f07297428d56992a742f0cd2701ba86e44d23d5b2"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ee/ab/93ce242f899b68c51b0578c027aafa791ab3614cb9345fa5d37b5f5c8e3e/aiohttp-3.14.0.tar.gz"
    sha256 "2882de819734c715fd1b9c11c97e09fa020d14438203d1d354d8ed1702791c9b"
  end

  resource "aiohttp-socks" do
    url "https://files.pythonhosted.org/packages/1f/cc/e5bbd54f76bd56291522251e47267b645dac76327b2657ade9545e30522c/aiohttp_socks-0.11.0.tar.gz"
    sha256 "0afe51638527c79077e4bd6e57052c87c4824233d6e20bb061c53766421b10f0"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/02/d4/1e69e17dda5df91734b70d03dbbf9f222ddb438e1f3bf4ea8fa135ce46de/aiomultiprocess-0.9.1.tar.gz"
    sha256 "f0231dbe0291e15325d7896ebeae0002d95a4f2675426ca05eb35f24c60e495b"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "censys" do
    url "https://files.pythonhosted.org/packages/41/aa/ed0d0faf4f7015bac902cdad929f487f9baefd224ab6fa9aba5635dd5d60/censys-2.2.19.tar.gz"
    sha256 "9202e17c2583d4b3d0af32a5be161ddb505edd390a9ca909f2e7470d4af19a97"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/c3/a4/34847b59150da33690a36da3681d6bbc2ec14ee9a846bc30a6746e5984e4/click_plugins-1.1.1.2.tar.gz"
    sha256 "d7af3984a99d243c131aa1a828331e7630f4a88a9741fd05c927b204bcf92261"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/81/2d/ff8d91d7b564d464629a0fd50a4489c97fcb836ac230bf3a7269232a9b1f/fastapi-0.136.3.tar.gz"
    sha256 "e487fae93ad408e6f47641ee4dfe389864fd7bec92e547ea8498fc13f43e83ab"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5e/ac/8c98b17ee3900147b38ef7884a1e590b070b63f0d59fd8b46ef0205f4576/filelock-4.0.0.tar.gz"
    sha256 "3611eca5d818ca9b00ec3cc7db1dcfe1e2aafc8d44fb4920d8cf60ad1f6bfda6"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "limits" do
    url "https://files.pythonhosted.org/packages/71/69/826a5d1f45426c68d8f6539f8d275c0e4fcaa57f0c017ec3100986558a41/limits-5.8.0.tar.gz"
    sha256 "c9e0d74aed837e8f6f50d1fcebcf5fd8130957287206bc3799adaee5092655da"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/14/95/989c1b5ca17b72128661530cd6e351a0a83cda9a4d6c036e9ed976c18931/multidict-6.8.0.tar.gz"
    sha256 "5cd4637ce76312ba1e05eb9c5193fec231f64fee0944e135fa1e951242355b37"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/df/a0/9c823651872e6a0face3f0311de2a40c8bbcb9c8dcb15680bd019ac56ac7/pycares-5.0.1.tar.gz"
    sha256 "5a3c249c830432631439815f9a818463416f2a8cbdb1e988e78757de9ae75081"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/8b/04/e7c1fe4dc78a6fdbfd6c337b1c3732ff543b8a397683ab38378447baa331/pyee-13.0.1.tar.gz"
    sha256 "0b931f7c14535667ed4c7e0d531716368715e860b988770fc7eb8578d1f67fc8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-socks" do
    url "https://files.pythonhosted.org/packages/db/ad/5bbfab3d3a266963cca0c09e23a725bbf5f0535d21c8bd1d5272e4430771/python_socks-2.8.2.tar.gz"
    sha256 "ffc493951854fa3fc0551e0434a09a7b9f9047f9ad666dce42cb94a52e8a34b6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/c8/5a/b17e1e257d3e6f2e7758930e1256832c9ddd576f8631781e6a072914befa/retrying-1.4.2.tar.gz"
    sha256 "d102e75d53d8d30b88562d45361d6c6c934da06fab31bd81c0420acb97a8ba39"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c5/06/c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28/shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "slowapi" do
    url "https://files.pythonhosted.org/packages/a0/99/adfc7f94ca024736f061257d39118e1542bade7a52e86415a4c4ae92d8ff/slowapi-0.1.9.tar.gz"
    sha256 "639192d0f1ca01b1c6d95bf6c71d794c3a9ee189855337b4821f7f457dddad77"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/69/99/a6ca3beb3ccacb41fb3321d8a60e5566f9e6467601ef8eba6a17e1b89778/soupsieve-2.9.2.tar.gz"
    sha256 "4a55d8cf158a9c2e587fa4922f1bbb91d68ac829e2d6f25403a85747c71daf74"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/01/a9/ed5d3be29bfaf90c00b7159d3884b311f3880b55833d1c7be764164dc288/tldextract-5.3.2.tar.gz"
    sha256 "c017431bc0800f2d3d1b57cce36e06668f0930f60a6d8c4615d4e2b8da298fa9"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/bc/78/937198ea8708182dd1edbf0237bf255a96feab3f511691ad08b84da98e5d/ujson-5.12.1.tar.gz"
    sha256 "5b7e96406c301a1366534479a7352ec40ec68bb327c0c119091635acd5925e35"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/e6/bf/f6544ba992ddb9a6077343a576f9844f7f8f06ab819aefd00206e9255f18/uvicorn-0.48.0.tar.gz"
    sha256 "a5504207195d08c2511bf9125ede5ac4a4b71725d519e758d01dcf0bc2d31c37"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/42/a6/6375d56c44d590ef24acf0f8f5bf7ed768ff7a510b959306ec412611e90f/wrapt-2.4.1.tar.gz"
    sha256 "fd6390aab9e8aa40c52eff3c180f098e8d9f5894b1fd4c4fd2c207067b33ed16"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/46/2c/c06ef49dc36e7954e55b802a8b231770d286a9758b3d936bd1e04ce5ba88/xlsxwriter-3.2.9.tar.gz"
    sha256 "254b1c37a368c444eac6e2f867405cc9e461b0ed97a3233b2ac1e574efb4140c"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  deny_network_access! [:test]

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT"] = resource("playwright").version
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/theHarvester" => "theharvester"
  end

  test do
    output = shell_output("#{bin}/theharvester -d brew.sh --source invalid 2>&1", 1)
    assert_match "theHarvester #{version}", output
    assert_match "The following engines are not supported", output

    system libexec/"bin/python", "-c", "import theHarvester.lib.api.api"
  end
end
