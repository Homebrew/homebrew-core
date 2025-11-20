class Streamrip < Formula
  include Language::Python::Virtualenv

  desc "Scriptable music downloader for Qobuz, Tidal, SoundCloud, and Deezer"
  homepage "https://github.com/nathom/streamrip"
  # Test dependencies should be removed, so they are added to `pypi_packages`
  # `pygments` should be added manually, it is removed with test dependencies
  # PR ref: https://github.com/nathom/streamrip/pull/886
  url "https://files.pythonhosted.org/packages/b8/c9/6997772e0217f3081e4e692c7b8b104aaa564c008f2593341e81bbbd2396/streamrip-2.1.0.tar.gz"
  sha256 "e59b4b406f9ac77eb59c927a1a082644e0902152ffeb6212b6b24af7fbef5540"
  license "GPL-3.0-only"
  revision 4

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cb99ccc280138a02c60a02338de7102ecabd0b9c0d5e2338a7de73f656a518d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2efb45173f8115b662ced341861854541a61cb62d73b9e4b42515f397726506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2fc5455027b00f71e2bbe7b1964a7ddfee81db1240a0b62bb60af0d36494164"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fb4432584e2f381914ca14447e952272f745b747017c325317338fe9e437796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab867ddb7331039afc3ee0b32bd9bd4690f75c20fc7c9309571ec12c8496fe17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad94cdbab906a7c82d12b4280b36e9e595a188f8c21f705b47cf27efd7c15e8"
  end

  depends_on "certifi" => :no_linkage
  depends_on "ffmpeg"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[certifi pillow pytest pytest-asyncio pytest-mock]

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/17/0a/163e5260cecc12de6abc259d158d9da3b8ec062ab863107dcdb1166cdcef/aiodns-3.5.0.tar.gz"
    sha256 "11264edbab51896ecf546c18eb0dd56dff0428c6aa6d2cd87e643e07300eb310"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/06/f0/af90f3fb4066b0707b6a5af3ffd5fd9b3809bbb52f0153a3c7550e594de3/aiofiles-0.7.0.tar.gz"
    sha256 "a1c4fc9b2ff81568c83e21392a82f344ea9d23da906e4f6a52662764545e19d4"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/62/f1/8515650ac3121a9e55c7b217c60e7fae3e0134b5acfe65691781b5356929/aiohttp-3.13.0.tar.gz"
    sha256 "378dbc57dd8cf341ce243f13fa1fa5394d68e2e02c15cd5f28eae35a70ec7f67"
  end

  resource "aiolimiter" do
    url "https://files.pythonhosted.org/packages/f1/23/b52debf471f7a1e42e362d959a3982bdcb4fe13a5d46e63d28868807a79c/aiolimiter-1.2.1.tar.gz"
    sha256 "e02a37ea1a855d9e832252a105420ad4d15011505512a1a1d814647451b5cca9"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "click-help-colors" do
    url "https://files.pythonhosted.org/packages/6f/50/76f51d9c7fcd72a12da466801f7c1fa3884424c947787333c74327b4fcf3/click-help-colors-0.9.4.tar.gz"
    sha256 "f4cabe52cf550299b8888f4f2ee4c5f359ac27e33bcfe4d61db47785a5cc936c"
  end

  resource "deezer-py" do
    url "https://files.pythonhosted.org/packages/97/4e/18a8530aaed95350a34923556c68691e58440532495be9f4cd2ed684819d/deezer-py-1.3.6.tar.gz"
    sha256 "a3ef151f7971d69769e7393f71373eaf896bccd22167213872ae46e04e14a2d7"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/f4/1f/6370b6c5ba1975f5299bdda0e953e381880accbad1d2daa8fb0da3548051/m3u8-0.9.0.tar.gz"
    sha256 "3ee058855c430dc364db6b8026269d2b4c1894b198bcc5c824039c551c05f497"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/60/f7/ff244fdd8ed98e98d4f9acecfe74a890e5e3245ce55253ef88db51e94652/pathvalidate-2.5.2.tar.gz"
    sha256 "5ff57d0fabe5ecb7a4f1e4957bfeb5ad8ab5ab4c0fa71f79c6bbc24bd9b7d14d"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/8d/ad/9d1e96486d2eb5a2672c4d9a2dd372d015b8d7a332c6ac2722c4c8e6bbbf/pycares-4.11.0.tar.gz"
    sha256 "c863d9003ca0ce7df26429007859afd2a621d3276ed9fef154a9123db9252557"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
    sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/d8/80/f0f10b4045628645a841d3d98b584a8699005ee03a211fc7c45f6c6f0e99/simple_term_menu-1.6.6.tar.gz"
    sha256 "9813d36f5749d62d200a5599b1ec88469c71378312adc084c00c00bfbb383893"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/65/ed/7b7216101bc48627b630693b03392f33827901b81d4e1360a76515e3abc4/tomlkit-0.7.2.tar.gz"
    sha256 "d7a454f319a7e9bd2e249f239168729327e4dd2d27b17dc68be264ad1ce36754"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    system bin/"rip", "url", "https://soundcloud.com/radiarc/radiarc-irrelevance-fading"
  end
end
