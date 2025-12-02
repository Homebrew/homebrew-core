class Standardebooks < Formula
  include Language::Python::Virtualenv

  desc "Tools for producing ebook files"
  homepage "https://github.com/standardebooks/tools"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/standardebooks/tools.git", branch: "master"

  stable do
    url "https://github.com/standardebooks/tools/archive/refs/tags/2.10.0.tar.gz"
    sha256 "817948c4d7c0d25db2c8a05c09449f9d6a39e75343ca31571430f2c3fba0a8e9"

    # Backport fix for libxml2 >= 2.15
    patch do
      url "https://github.com/standardebooks/tools/commit/16387537a0ca44d251168eabb5fd239cb73c1c8c.patch?full_index=1"
      sha256 "ef57b70a33cf2e90fd09deff2c385d6cd05174af2f447cd54b31a0797130cff3"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8db597c1a1ad0858129ec883fabf0c3f93eed47f8b06bfd68807e5999d0c2363"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54afbfb5fb13337418eee1309ba1383f72098a10f38ae7497958ab4f5f0bf973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51405c25effc19cbe4d707cd13c1f2cc4bb3a0b919e7d3137e18754e044829b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bcae9a32191f175a0be207ddfb1847f931f8035f2a447b1d530cb0e467e7214"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dd0ad52715c2a7038a5dc1b369e97fdaf5e26035b814e6dff4253957dff7dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667ee83fe7d886afdb4e816eeda2a1b05a1d4ea5a6edab0820afc226b58fa56c"
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
  uses_from_macos "zlib"

  pypi_packages exclude_packages: %w[certifi cffi pillow pycairo]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "cairocffi" do
    url "https://files.pythonhosted.org/packages/70/c5/1a4dc131459e68a173cbdab5fad6b524f53f9c1ef7861b7698e998b837cc/cairocffi-1.7.1.tar.gz"
    sha256 "2e48ee864884ec4a3a34bfa8c9ab9999f688286eb714a15a43ec9d068c36557b"
  end

  resource "cairosvg" do
    url "https://files.pythonhosted.org/packages/d5/e6/ec5900b724e3c44af7f6f51f719919137284e5da4aabe96508baec8a1b40/CairoSVG-2.7.1.tar.gz"
    sha256 "432531d72347291b9a9ebfb6777026b607563fd8719c46ee742db0aef7271ba0"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/72/0a/c3ea9573b1dc2e151abfe88c7fe0c26d1892fe6ed02d0cdb30f0d57029d5/cssselect-1.3.0.tar.gz"
    sha256 "57f8a99424cfab289a1b6a816a43075a4b00948c86b4dcf3ef4ee7e15f7ab0c7"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/9f/86/fd7f58fc498b3166f3a7e8e0cddb6e620fe1da35b02248b1bd59e95dbaaa/cssselect2-0.8.0.tar.gz"
    sha256 "7674ffb954a3b46162392aee2a3a0aedb2e14ecf99fcc28644900f4e6e3e9d3a"
  end

  resource "cssutils" do
    url "https://files.pythonhosted.org/packages/33/9f/329d26121fe165be44b1dfff21aa0dc348f04633931f1d20ed6cf448a236/cssutils-2.11.1.tar.gz"
    sha256 "0563a76513b6af6eebbe788c3bf3d01c920e46b3f90c8416738c5cfc773ff8e2"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
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
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/83/a4/ce09af12e1a91b5b77cefc893ef5054619553734c5b42f143d93ed581744/importlib_resources-1.0.2.tar.gz"
    sha256 "d3279fd0f6f847cced9f7acc19bd3e5df54d34f93a2e7bb5f238f81545787078"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/80/61/d3dc048cd6c7be6fe45b80cedcbdd4326ba4d550375f266d9f4246d0f4bc/lxml-5.3.2.tar.gz"
    sha256 "773947d0ed809ddad824b7b14467e1a481b8976e87278ac4a730c2f7c7fcddc1"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/98/df/77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2/outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
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
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "repro-zipfile" do
    url "https://files.pythonhosted.org/packages/ed/86/a680b85796b667a060bc673294e8adc3201a28381b23a61702ac0f51f732/repro_zipfile-0.4.0.tar.gz"
    sha256 "fde4cf1300e740f2fd1745708ba8f1366a70853a39af6266e1e04ae81c1231c1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "roman" do
    url "https://files.pythonhosted.org/packages/85/49/b01cf3c88006005613234cfc78b2e371adc3b55fe125641679bca46963f9/roman-5.0.tar.gz"
    sha256 "cb35293c1c4046105fd899194f4f2985f78c955a8b05937f7ab93f3be1660697"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/e0/bf/642cce8b5a9edad8e4880fdefbeb24f69bec2086b1121c63f883c412b797/selenium-4.31.0.tar.gz"
    sha256 "441cffc436a2e6659fe3cfb012692435652efd38b0d368d16f661a5db47825f5"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/81/9c/42314ee079a3e9c24b27515f9fbc7a3c1d29992c33451779011c74488375/setuptools-78.1.1.tar.gz"
    sha256 "fcc17fd9cd898242f6b4adfaca46137a9edef687f43e6f78469692a5e70d851d"
  end

  resource "smartypants" do
    url "https://files.pythonhosted.org/packages/6c/8f/a033f78196d9467b402d100ec40b95166d43fa2642693f23f771473d8195/smartypants-2.0.2.tar.gz"
    sha256 "39d64ce1d7cc6964b698297bdf391bc12c3251b7f608e6e55d857cd7c5f800c6"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
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
    url "https://files.pythonhosted.org/packages/7a/fd/7a5ee21fd08ff70d3d33a5781c255cbe779659bd03278feb98b19ee550f4/tinycss2-1.4.0.tar.gz"
    sha256 "10c0972f6fc0fbee87c3edb76549357415e94548c1ae10ebccdea16fb404a9b7"
  end

  resource "titlecase" do
    url "https://files.pythonhosted.org/packages/63/17/04d2d3e30e2bc5a3eefa1060b08e3fb628510440f938eaecabbe08976a26/titlecase-2.4.1.tar.gz"
    sha256 "7d83a277ccbbda11a2944e78a63e5ccaf3d32f828c594312e4862f9a07f635f5"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/76/8f/c6e36dd11201e2a565977d8b13f0b027ba4593c1a80bed5185489178e257/trio-0.31.0.tar.gz"
    sha256 "f71d551ccaa79d0cb73017a33ef3264fde8335728eb4c6391451fe5d253a9d5b"
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
    url "https://files.pythonhosted.org/packages/f7/89/19151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3e/Unidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
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
