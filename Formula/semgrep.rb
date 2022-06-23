class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  url "https://github.com/returntocorp/semgrep.git",
      tag:      "v0.100.0",
      revision: "facd90461b6a99fbac4406a7fe51ee91d1039eb2"
  license "LGPL-2.1-only"
  head "https://github.com/returntocorp/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c0c185b52061aeea1a2db6ce387f1df1cdeaf7586c58900b489c819969b3d6eb"
    sha256 cellar: :any, arm64_big_sur:  "eb8d578c6340c8bf2a29829d7c516baee0aadffca6e4ce5363c1e713f63ba9d0"
    sha256 cellar: :any, monterey:       "8c5566c663618799c6de6f1930be7be3cc1778c33c1b8327189a1ca7ed1ad568"
    sha256 cellar: :any, big_sur:        "98e27a84f95cc5a893c15272cb902cc64e42c4d51b57f48a4e733bab8dab8523"
    sha256 cellar: :any, catalina:       "c5e00b3c4c35bb3beafbc7f4097d278d2c7761224476a930f95ba153610b8c45"
    sha256               x86_64_linux:   "a8ea2d8a44233bf7a7a1e8b1e80dbba4151fa33a8c9f64ec9077ecc5bdfbbea8"
  end

  depends_on "cmake" => :build
  depends_on "coreutils"=> :build
  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pipenv" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "python@3.10"
  depends_on "tree-sitter"

  uses_from_macos "rsync" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/ad/1f/6c0608d86e0fc77c982a2923ece80eef85f091f2332fc13cbce41d70d502/boltons-21.0.0.tar.gz"
    sha256 "65e70a79a731a7fe6e98592ecfb5ccf2115873d01dbc576079874629e5c90f13"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/3c/86/5de6d909d9dcc85627a178788ec3e8c3ef81cda175badb48ad0bb582628d/click-option-group-0.5.3.tar.gz"
    sha256 "a6e924f3c46b657feb5b72679f7e930f8e5b224b766ab35c91ae4019b4e0615e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "face" do
    url "https://files.pythonhosted.org/packages/ae/ab/2b18c4815f3db1e04bce325271fefda55d0893738ea84e3a655218944b03/face-20.1.1.tar.gz"
    sha256 "7d59ca5ba341316e58cf72c6aff85cca2541cf5056c4af45cb63af9a814bed3e"
  end

  resource "glom" do
    url "https://files.pythonhosted.org/packages/3f/d1/69432deefa6f5283ec75b246d0540097ae26f618b915519ee3824c4c5dd6/glom-22.1.0.tar.gz"
    sha256 "1510c6587a8f9c64a246641b70033cbc5ebde99f02ad245693678038e821aeb5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "peewee" do
    url "https://files.pythonhosted.org/packages/d4/22/b9d912a9611e8fd3f25ce040aa683c1dabbae7404e77db0f6a511363a112/peewee-3.15.0.tar.gz"
    sha256 "48eac70be812ac84daa5400fb8e7b545e0c83adcfa05c8e2a8612f9ced4da495"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e9/23/384d9953bb968731212dc37af87cb75a885dc48e0615bd6a303577c4dc4b/requests-2.28.0.tar.gz"
    sha256 "d568723a7ebd25875d8d1eaf5dfa068cd2fc8194b2e483d7b1f7c81918dbec6b"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/98/2a/838de32e09bd511cf69fe4ae13ffc748ac143449bfc24bb3fd172d53a84f/tqdm-4.64.0.tar.gz"
    sha256 "40be55d30e200777a307a7585aee69e4eabb46b4ec6a4b4a5f2d9f11e7d5408d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/fe/71/1df93bd59163c8084d812d166c907639646e8aac72886d563851b966bf18/typing_extensions-4.2.0.tar.gz"
    sha256 "f1c24655a0da0d1b67f07e17a5e6b2a105894e6824b92096378bb3668ef02376"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/92/38/a8c8d8cdacd586e0e66673ca60daf295a79cd5b4fae72a25f1bfa482554d/ujson-5.3.0.tar.gz"
    sha256 "ab938777b3ac0372231ee654a7f6a13787e587b1ca268d8aa7e6fb6846e477d0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/95/b3/597b79292584de5b790146871e50cf3cb3bf37cf845232a20123fc784ef2/wcmatch-8.4.tar.gz"
    sha256 "ba4fc5558f8946bf1ffc7034b05b814d825d694112499c86035e0e4d398b6a67"
  end

  def install
    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"

      # Officially suggested workaround for breaking change in setuptools v50.0.0
      # See: https://sourceforge.net/p/ruamel-yaml/tickets/356/
      # Relevant Issue: https://github.com/pypa/setuptools/issues/2355
      ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.4.14.0" }

      # Manually run steps from `opam exec -- make setup` to link Homebrew's tree-sitter
      system "opam", "update", "-y"

      # We pass --no-depexts so as to disable the check for pkg-config.
      # It seems to not be found when building on ubuntu
      # See discussion on https://github.com/Homebrew/homebrew-core/pull/82693
      system "opam", "install", "-y", "--deps-only", "--no-depexts", "./semgrep-core/src/pfff"
      system "opam", "install", "-y", "--deps-only", "--no-depexts", "./semgrep-core/src/ocaml-tree-sitter-core"
      system "opam", "install", "-y", "--deps-only", "--no-depexts", "./semgrep-core"

      # Install semgrep-core and spacegrep
      cd "semgrep-core" do
        system "opam", "install", "--deps-only", "-y", "."
        system "opam", "exec", "--", "make", "all"
        system "opam", "exec", "--", "make", "install"
        bin.install "_build/install/default/bin/semgrep-core" => "semgrep-core"
        bin.install "_build/install/default/bin/spacegrep" => "spacegrep"
      end
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    python_path = "cli"
    cd python_path do
      venv = virtualenv_create(libexec, Formula["python@3.10"].bin/"python3.10")
      venv.pip_install resources.reject { |r| r.name == "ocaml-tree-sitter" }
      venv.pip_install_and_link buildpath/python_path
    end
  end

  test do
    system "#{bin}/semgrep", "--help"
    (testpath/"script.py").write <<~EOS
      def silly_eq(a, b):
        return a + b == a + b
    EOS

    output = shell_output("#{bin}/semgrep script.py -l python -e '$X == $X'")
    assert_match "a + b == a + b", output

    (testpath/"script.ts").write <<~EOS
      function test_equal() {
        a = 1;
        b = 2;
        //ERROR: match
        if (a + b == a + b)
            return 1;
        return 0;
      }
    EOS

    output = shell_output("#{bin}/semgrep script.ts -l ts -e '$X == $X'")
    assert_match "a + b == a + b", output
  end
end
