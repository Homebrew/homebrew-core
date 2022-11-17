class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  url "https://github.com/returntocorp/semgrep.git",
      tag:      "v0.122.0",
      revision: "349ee7f98ecfe61fa515cf2bfdd3d4c6e7268e11"
  license "LGPL-2.1-only"
  head "https://github.com/returntocorp/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f68efe27a78114684f3f5f690c6bf36d530134f93be951a4a38ad9e4786ca26e"
    sha256 cellar: :any, arm64_monterey: "89e4d69c43a3874cceecd100a9668117d102661c1942acceb6b98e4f72cb8100"
    sha256 cellar: :any, arm64_big_sur:  "718e109314bb81fce6e5c8ca6fb656596cf74b56e7e62806f5236e12e51d9b2c"
    sha256 cellar: :any, ventura:        "063eafa19923aff0c7982ceeedb2f59e11b2b470b43f98a4b1ee1d7cba82811a"
    sha256 cellar: :any, monterey:       "74772834439ae1bcd2b481dff758083f4058825322757ba8b0ec2c64bb5e64a6"
    sha256 cellar: :any, big_sur:        "065783694ebfa868a84bbda67c3b80a68bf6fed6f210317f319fce8aa55bc6ac"
    sha256 cellar: :any, catalina:       "6bb714397e9d0e2efe6353af39f354da920049ccb674203dbc352d02695c4508"
    sha256               x86_64_linux:   "d6a63ed7c3353922439195cc99465c40ec677b64aca67d8afa5ac5348854c4c4"
  end

  depends_on "cmake" => :build
  depends_on "coreutils"=> :build
  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pipenv" => :build
  depends_on "pkg-config" => :build
  depends_on "jsonschema"
  depends_on "pcre"
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "tree-sitter"

  uses_from_macos "rsync" => :build

  fails_with gcc: "5"

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/ad/1f/6c0608d86e0fc77c982a2923ece80eef85f091f2332fc13cbce41d70d502/boltons-21.0.0.tar.gz"
    sha256 "65e70a79a731a7fe6e98592ecfb5ccf2115873d01dbc576079874629e5c90f13"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/4c/29/ff7cd69825b5bfb48e39853b75d5dc2e98a581730f2b6c9c014188730755/click-option-group-0.5.5.tar.gz"
    sha256 "78ee474f07a0ca0ef6c0317bb3ebe79387aafb0c4a1e03b1d8b2b0be1e42fc78"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "face" do
    url "https://files.pythonhosted.org/packages/d7/bc/4d0f6c1e095eb977782edd94245f84b69c6f8df152480c78ab310e895098/face-22.0.0.tar.gz"
    sha256 "d5d692f90bc8f5987b636e47e36384b9bbda499aaf0a77aa0b0bbe834c76923d"
  end

  resource "glom" do
    url "https://files.pythonhosted.org/packages/3f/d1/69432deefa6f5283ec75b246d0540097ae26f618b915519ee3824c4c5dd6/glom-22.1.0.tar.gz"
    sha256 "1510c6587a8f9c64a246641b70033cbc5ebde99f02ad245693678038e821aeb5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "peewee" do
    url "https://files.pythonhosted.org/packages/17/c8/8035f2155832580d786c35cb1ce0a89d80a67be522f620878fc294742905/peewee-3.15.4.tar.gz"
    sha256 "2581520c8dfbacd9d580c2719ae259f0637a9e46eda47dfc0ce01864c6366205"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/4a/03ddad85a10dd52e209993a14afa0cb0dc5c348e4647329f1c53856ad9e6/ujson-5.5.0.tar.gz"
    sha256 "b25077a971c7da47bd6846a912a747f6963776d90720c88603b1b55d81790780"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
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

      # Run configure script in ocaml-tree-sitter-core
      cd "semgrep-core/src/ocaml-tree-sitter-core" do
        system "./configure"
      end

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

    # we depend on jsonschema, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    jsonschema = Formula["jsonschema"].opt_libexec
    (libexec/site_packages/"homebrew-jsonschema.pth").write jsonschema/site_packages
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
