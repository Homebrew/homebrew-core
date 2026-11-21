class Standardebooks < Formula
  include Language::Python::Virtualenv

  desc "Tools for producing ebook files"
  homepage "https://github.com/standardebooks/tools"
  url "https://files.pythonhosted.org/packages/e5/12/782a37f8833b099096e1bc5da4237416c9dac966a7e7defb41a751899bcf/standardebooks-4.1.1.tar.gz"
  sha256 "30a5db8224235645256d16653f3f3ce39c8d2890c7fdada43548e0c7eab233c8"
  license "GPL-3.0-or-later"
  head "https://github.com/standardebooks/tools.git", branch: "master"

  bottle do
    manifest_sha256 "c9fcf8c13234df6094f79d56729f9966113b27ed490fb5a8163991ba76566382"
    sha256 cellar: :any, arm64_golden_gate: "9f75a1e99fdd2726a17248c72a8c84959396ffbb4fad934e9c17682dec77070b"
    sha256 cellar: :any, arm64_tahoe:       "edefda55668e84cf907defc9bb875a1504b6f47bdb47852472bb7974e7884b73"
    sha256 cellar: :any, arm64_sequoia:     "7fff9b832c4969f19c9b99348dbde48d87ae0c21e4c490d6c31852493e4477a6"
    sha256 cellar: :any, arm64_linux:       "25d51515630459803317bf48dec17b2ea193bbd7945c7632e730b7934b74c8af"
    sha256 cellar: :any, x86_64_linux:      "0ee541cbd26941f1b0ba01693c5873986752947d5845eea3a5324e1f30d07ed8"
  end

  depends_on "rust" => :build # for selenium
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "openjdk"
  depends_on "pillow" => :no_linkage
  depends_on "pycparser" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: %w[certifi cffi pillow],
                extra_packages:   "pyxdg" # Linux only

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "cairocffi" do
    url "https://files.pythonhosted.org/packages/70/c5/1a4dc131459e68a173cbdab5fad6b524f53f9c1ef7861b7698e998b837cc/cairocffi-1.7.1.tar.gz"
    sha256 "2e48ee864884ec4a3a34bfa8c9ab9999f688286eb714a15a43ec9d068c36557b"
  end

  resource "cairosvg" do
    url "https://files.pythonhosted.org/packages/c6/80/db62c0a96d2e55282c83524f6b1d02f09c7fd7f612e93bf83e30de1dc75c/cairosvg-2.9.1.tar.gz"
    sha256 "861bc28ad97ce4f537d50eb3d6ee97a7afcccec9c61ac25c4e7d073fe409aec7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/47/92/3d893ac5d338b9a9af34c5b517d77492dcea8a10254254eead4215a96f3f/chardet-7.7.0.tar.gz"
    sha256 "0ba38a05201b0abf7570c12d8af45c30b2af835bd5cc52bfc7105082eda82c1e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/c8/8b/dc32df939ab541fca6ee8964d26aa231dbe231cdc2b2713228161441ba9c/cssselect-1.6.0.tar.gz"
    sha256 "8c83a7139e97b93aa5ebdc0f46e785f7056a08a8bf201e597a6a2629d7eb11db"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/06/00/2456b6b664c7a770989cbe3c352aac4eb962c938486f03a2e1255ae963c6/cssselect2-0.10.1.tar.gz"
    sha256 "83b0d820ef589dabaf693289b647c2f5b410f76d285f56deba911ffa75a7b9d1"
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
    url "https://files.pythonhosted.org/packages/c0/ff/fee293f1ec3e1b64db6eb270e00964f29c086d769201474cedb8d1608930/gitpython-3.2.1.tar.gz"
    sha256 "0f1229ec5c057bdabdeeda8bda4f17bda679ab33dbccc00f24e6a480553c8613"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
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
    url "https://files.pythonhosted.org/packages/a3/5c/da4b37c49a5498b90cc34f9db2bc0884af8e2e8a6fa74610266615fa88d1/oxipng_pybind-10.2.1.post3.tar.gz"
    sha256 "83b9bf41bec302a59027887a918b36763faa460dab222d77ed0b197c2b0130a4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/94/47/8430452269cd28863d73b903d07d329d058cf762527ff211b3864ba61fc7/pyphen-0.18.1.tar.gz"
    sha256 "dbae6fbbe4f01cb206108b43573d857c67107be9d0e38eb1b08d6fa2210634a7"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b8/17/ef8c46a9e7cf2304968eb260f594bbd4220fab6281e64c090cdd85884511/regex-2026.11.19.tar.gz"
    sha256 "2826a006b68acfd3ed5074433caafe21d7f9d026eb82cb856724a4a893a70915"
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
    url "https://files.pythonhosted.org/packages/1d/2c/bf42413d7965c0f84cf86bb04214081d268793fc5d1c38b72ddde9f9c57d/selenium-4.53.0.tar.gz"
    sha256 "efb45b129cbd7f46da99c82e7d327978bda29ed987223465c341f96404a86a2c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
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
    url "https://files.pythonhosted.org/packages/9c/e2/1db4e79abb730bbf048c1024a622b0e1e895f5b0e18c59f3f6b3e4b296ef/trio-0.35.0.tar.gz"
    sha256 "7efb295c78a0ecd1235c5759e620b5da564ca80d2efcb0055423588547248b96"
  end

  resource "trio-websocket" do
    url "https://files.pythonhosted.org/packages/d1/3c/8b4358e81f2f2cfe71b66a267f023a91db20a817b9425dd964873796980a/trio_websocket-0.12.2.tar.gz"
    sha256 "22c72c436f3d1e264d0910a3951934798dcc5b00ae56fc4ee079d46c7cf20fae"
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
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/d8/cb/a5abcc2891249f393827c650c6296660ce40374ac22d99ab9aea41f9d2a2/websocket_client-1.9.2.tar.gz"
    sha256 "0fcb57545848be86992e128218fd96dd87a6769ffdb1a968dff79632b85604d0"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c7/79/12135bdf8b9c9367b8701c2c19a14c913c120b882d50b014ca0d38083c2c/wsproto-1.3.2.tar.gz"
    sha256 "b86885dcf294e15204919950f666e06ffc6c7c114ca900b060d6e16293528294"
  end

  def install
    # Remove vendored prebuilt binary
    rm "se/vendor/calibre_azw3/upstream/html5_parser/html_parser.cpython-312-x86_64-linux-gnu.so"

    without = "pyxdg" unless OS.linux?
    virtualenv_install_with_resources(without:)

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
