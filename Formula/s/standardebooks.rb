class Standardebooks < Formula
  include Language::Python::Virtualenv

  desc "Tools for producing ebook files"
  homepage "https://github.com/standardebooks/tools"
  url "https://files.pythonhosted.org/packages/be/7e/45048bb8e3bc7c031f4ee80e7ec749c5c131176a6727ad7aa1a2e4cb55d4/standardebooks-4.0.0.tar.gz"
  sha256 "29ade25bd3114395dda50fcb9551ceeda1e1af43dd442e27a6ca9ee42213ae12"
  license "GPL-3.0-or-later"
  head "https://github.com/standardebooks/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cba4725aaa2c14c5d67b4c111259e4b06feaf2e6e4036eb30b2a5e9d68269a53"
    sha256 cellar: :any, arm64_sequoia: "6a41262c5f95cee781b4a851e21b6ca96e4aefae0c98b2f45969da64d186bccd"
    sha256 cellar: :any, arm64_sonoma:  "22a27e2b9945a01e11f9fad0d39d84966425a866df37fba244a72e4038aebc45"
    sha256 cellar: :any, sonoma:        "673c252750a71e339d4545aa45131c59042fb0c514453bc4cd7b33a49fb7e63f"
    sha256 cellar: :any, arm64_linux:   "5bd2528f548df79e5b96a828d94e2f3c9fa554d8993239023003c92ccc657928"
    sha256 cellar: :any, x86_64_linux:  "2a26f3354a3377349185b93ebf5f42fc4546139db0a6ab34e26fdfe44ae323ab"
  end

  depends_on "rust" => :build # for selenium
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "openjdk"
  depends_on "pillow" => :no_linkage
  depends_on "py3cairo" => :no_linkage
  depends_on "pycparser" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: %w[certifi cffi pillow pycairo]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "cairocffi" do
    url "https://files.pythonhosted.org/packages/70/c5/1a4dc131459e68a173cbdab5fad6b524f53f9c1ef7861b7698e998b837cc/cairocffi-1.7.1.tar.gz"
    sha256 "2e48ee864884ec4a3a34bfa8c9ab9999f688286eb714a15a43ec9d068c36557b"
  end

  resource "cairosvg" do
    url "https://files.pythonhosted.org/packages/38/07/e8412a13019b3f737972dea23a2c61ca42becafc16c9338f4ca7a0caa993/cairosvg-2.9.0.tar.gz"
    sha256 "1debb00cd2da11350d8b6f5ceb739f1b539196d71d5cf5eb7363dbd1bfbc8dc5"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/19/b6/9df434a8eeba2e6628c465a1dfa31034228ef79b26f76f46278f4ef7e49d/chardet-7.4.3.tar.gz"
    sha256 "cc1d4eb92a4ec1c2df3b490836ffa46922e599d34ce0bb75cf41fd2bf6303d56"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/ec/2e/cdfd8b01c37cbf4f9482eefd455853a3cf9c995029a46acd31dfaa9c1dd6/cssselect-1.4.0.tar.gz"
    sha256 "fdaf0a1425e17dfe8c5cf66191d211b357cf7872ae8afc4c6762ddd8ac47fc92"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e0/20/92eaa6b0aec7189fa4b75c890640e076e9e793095721db69c5c81142c2e1/cssselect2-0.9.0.tar.gz"
    sha256 "759aa22c216326356f65e62e791d66160a0f9c91d1424e8d8adc5e74dddfc6fb"
  end

  resource "cssutils" do
    url "https://files.pythonhosted.org/packages/01/00/7e89107ea389e952eea73b1b90ac6633e15a519c4a518ee90bb93a2f83dc/cssutils-2.15.0.tar.gz"
    sha256 "e9739237f3915037dacba787c4b58f280e3ec5d9864953e185bf23d40ff7d021"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "encutils" do
    url "https://files.pythonhosted.org/packages/86/24/15d0f368875e53fb02bf7475e8a8c9aec36dee5a3dcb23efc77f585f9eb6/encutils-1.0.0.tar.gz"
    sha256 "38eca5af18cebabd8be43c17f14c9d3fbba83cc5f7ac8e3ab1c86e24c4b2b91a"
  end

  resource "ftfy" do
    url "https://files.pythonhosted.org/packages/a5/d3/8650919bc3c7c6e90ee3fa7fd618bf373cbbe55dff043bd67353dbb20cd8/ftfy-6.3.1.tar.gz"
    sha256 "9b3c3d90f84fb267fe64d375a07b7f8912d817cf86009ae134aa03e1819506ec"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/33/f6/354ae6491228b5eb40e10d89c4d13c651fe1cf7556e35ebdded50cff57ce/gitpython-3.1.50.tar.gz"
    sha256 "80da2d12504d52e1f998772dc5baf6e553f8d2fcfe1fcc226c9d9a2ee3372dcc"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/83/a4/ce09af12e1a91b5b77cefc893ef5054619553734c5b42f143d93ed581744/importlib_resources-1.0.2.tar.gz"
    sha256 "d3279fd0f6f847cced9f7acc19bd3e5df54d34f93a2e7bb5f238f81545787078"
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

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/98/df/77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2/outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "oxipng-pybind" do
    url "https://files.pythonhosted.org/packages/f7/a1/7b3ba274fafeba75a9c6109d34bcecb3504087f5287c0345f3a9fdf58ac2/oxipng_pybind-10.1.1.post2.tar.gz"
    sha256 "cf71ed8f447ee1db1d1dad19144f8999917e13df0ac4de3776826c12387bf5b8"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/69/56/e4d7e1bd70d997713649c5ce530b2d15a5fc2245a74ca820fc2d51d89d4d/pyphen-0.17.2.tar.gz"
    sha256 "f60647a9c9b30ec6c59910097af82bc5dd2d36576b918e44148d8b07ef3b4aa3"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f1/05/e4f219230e11e774a6c9987d2ab0d0c6b8573e13a17e143d0015bee710ef/regex-2026.6.28.tar.gz"
    sha256 "3cb4b6c5cb3060cc31efdc1fbb27c25fb9b29044afd87e40601a1c4d9db54342"
  end

  resource "repro-zipfile" do
    url "https://files.pythonhosted.org/packages/68/d4/514da0758e1ba5723ad45ff9981c8e3b30f5114516f9ba3968ccae3c0043/repro_zipfile-0.4.1.tar.gz"
    sha256 "0d5995b4311ed4871cbf6b3210e6a340b0f35f6e4ce2ba27676470bf6987c1db"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "roman" do
    url "https://files.pythonhosted.org/packages/9c/7c/3901b35ed856329bf98e84da8e5e0b4d899ea0027eee222f1be42a24ff3f/roman-5.2.tar.gz"
    sha256 "275fe9f46290f7d0ffaea1c33251b92b8e463ace23660508ceef522e7587cb6f"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/86/48/486aa67320f27452e9f551b8608f1a59ce7091c8fe7ebc9f4eba274775d4/selenium-4.45.0.tar.gz"
    sha256 "563f0c4102f112df1cda30d46ce6d177b2e4a7a3d4b0756902d5dc84d3a8a365"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "smartypants" do
    url "https://files.pythonhosted.org/packages/6c/8f/a033f78196d9467b402d100ec40b95166d43fa2642693f23f771473d8195/smartypants-2.0.2.tar.gz"
    sha256 "39d64ce1d7cc6964b698297bdf391bc12c3251b7f608e6e55d857cd7c5f800c6"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/a3/ae/2ca4913e5c0f09781d75482874c3a95db9105462a92ddd303c7d285d3df2/tinycss2-1.5.1.tar.gz"
    sha256 "d339d2b616ba90ccce58da8495a78f46e55d4d25f9fd71dfd526f07e7d53f957"
  end

  resource "titlecase" do
    url "https://files.pythonhosted.org/packages/63/17/04d2d3e30e2bc5a3eefa1060b08e3fb628510440f938eaecabbe08976a26/titlecase-2.4.1.tar.gz"
    sha256 "7d83a277ccbbda11a2944e78a63e5ccaf3d32f828c594312e4862f9a07f635f5"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/52/b6/c744031c6f89b18b3f5f4f7338603ab381d740a7f45938c4607b2302481f/trio-0.33.0.tar.gz"
    sha256 "a29b92b73f09d4b48ed249acd91073281a7f1063f09caba5dc70465b5c7aa970"
  end

  resource "trio-websocket" do
    url "https://files.pythonhosted.org/packages/d1/3c/8b4358e81f2f2cfe71b66a267f023a91db20a817b9425dd964873796980a/trio_websocket-0.12.2.tar.gz"
    sha256 "22c72c436f3d1e264d0910a3951934798dcc5b00ae56fc4ee079d46c7cf20fae"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c7/79/12135bdf8b9c9367b8701c2c19a14c913c120b882d50b014ca0d38083c2c/wsproto-1.3.2.tar.gz"
    sha256 "b86885dcf294e15204919950f666e06ffc6c7c114ca900b060d6e16293528294"
  end

  def install
    # Remove vendored prebuilt binary
    rm "se/vendor/calibre_azw3/upstream/html5_parser/html_parser.cpython-312-x86_64-linux-gnu.so"

    virtualenv_install_with_resources

    bash_completion.install "se/completions/bash/se"
    fish_completion.install "se/completions/fish/se.fish"
    zsh_completion.install "se/completions/zsh/_se"
  end

  test do
    system bin/"se", "extract-ebook", test_fixtures("test.epub")
    extracted_index = testpath/"test.epub.extracted/index.html"
    assert_match("<title>0667c70e8ab1b6a6cfca6abd397ee2c6</title>", extracted_index.read)

    system bin/"se", "create-draft", "--title", "Homebrew & the Haunted House", "--author", "Max Howell"
    testbook = testpath/"max-howell_homebrew-the-haunted-house"
    assert_path_exists(testbook)

    bodytext = testbook/"src/epub/text/body.xhtml"
    bodytext.write <<~XML
      <?xml version="1.0" encoding="utf-8"?>
      <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" epub:prefix="z3998: http://www.daisy.org/z3998/2012/vocab/structure/, se: https://standardebooks.org/vocab/1.0" xml:lang="en-GB">
        <head>
          <title>I</title>
          <link href="../css/core.css" rel="stylesheet" type="text/css"/>
          <link href="../css/local.css" rel="stylesheet" type="text/css"/>
        </head>
        <body epub:type="bodymatter z3998:fiction">
          <section id="chapter-1" epub:type="chapter">
            <h2 epub:type="ordinal z3998:roman">I</h2>
            <p>We can assume that any 'instance' of a point can be construed--maybe--as a themeless "formula".</p>
          </section>
        </body>
      </html>
    XML

    # Test word-count subcommand
    wc_out = shell_output("#{bin}/se -p word-count #{testbook}/src/epub/text").strip
    assert_match(/\d+/, wc_out)

    # Test typogrify subcommand
    system bin/"se", "typogrify", (testbook/"src/epub/text").to_s
    content = bodytext.read
    assert_includes content, "“"
    assert_includes content, "”"
    assert_includes content, "—"
    refute_includes content, "construed--maybe--as"

    # Test hyphenate subcommand
    system bin/"se", "hyphenate", (testbook/"src/epub/text").to_s
    content = bodytext.read
    assert_match(/\u00AD/, content)

    # Test build subcommand, which uses java
    system bin/"se", "build", (testbook/"src").to_s
    assert_path_exists("max-howell_homebrew-the-haunted-house.epub")
    assert_path_exists("max-howell_homebrew-the-haunted-house_advanced.epub")
  end
end
