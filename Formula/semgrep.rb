class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  url "https://github.com/returntocorp/semgrep.git",
      tag:      "v0.37.0",
      revision: "f6c762cf5ad1246643ee47ae9c9b340261450804"
  license "LGPL-2.1-only"
  head "https://github.com/returntocorp/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "d4a8fc635feaf8fd4c9ab04b5b32d7e296a5091afe478016c25d8a50ac66aedf" => :big_sur
    sha256 "81e3799f943d8916cfedc27959c45d7d22f84bcacfcd8d9ffba1672e7341dc24" => :catalina
    sha256 "1b0f73f9697ceda313b6332b513e4741013ad79c9b48ee66ca7fb5b4e4db7db7" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "coreutils"=> :build
  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/c5/e81b9fb8033fe78a2355ea7b1774338e1dca2c9cbd2ee140211a9e6291ab/packaging-20.8.tar.gz"
    sha256 "78598185a7008a470d64526a8059de9aaa449238f280fc9eb6b13ba6c4109093"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/4d/70/fd441df751ba8b620e03fd2d2d9ca902103119616f0f6cc42e6405035062/pyrsistent-0.17.3.tar.gz"
    sha256 "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/16/8b/54a26c1031595e5edd0e616028b922d78d8ffba8bc775f0a4faeada846cc/ruamel.yaml-0.16.10.tar.gz"
    sha256 "099c644a778bf72ffa00524f78dd0b6476bca94a1da344130f4bf3381ce5b954"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/69/50/9f29874d835945b845812799edc732ba30c41e9d20431f9f69c8ffb9c670/tqdm-4.56.0.tar.gz"
    sha256 "fe3d08dd00a526850568d542ff9de9bbc2a09a791da3c334f3213d8d0bbbca65"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  def install
    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"

      # Used by semgrep-core for clang to find libtree-sitter.a
      ENV["LIBRARY_PATH"] = lib

      # Officially suggested workaround for breaking change in setuptools v50.0.0
      # See: https://sourceforge.net/p/ruamel-yaml/tickets/356/
      # Relevant Issue: https://github.com/pypa/setuptools/issues/2355
      ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

      # Used by ocaml-tree-sitter to find tree-sitter/*.h headers
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      ENV["C_INCLUDE_PATH"] = include

      # Used by tree-sitter to place libtree-sitter.a, and header files
      ENV["PREFIX"] = prefix

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.4.10.0" }

      system "opam", "exec", "--", "make", "setup"

      # Install spacegrep
      cd "spacegrep" do
        system "opam", "install", "--deps-only", "-y", "."
        system "opam", "exec", "--", "make"
        system "opam", "exec", "--", "make", "install"
        bin.install "_build/default/src/bin/Space_main.exe" => "spacegrep"
      end

      # Install tree-sitter
      cd "ocaml-tree-sitter" do
        cd "tree-sitter" do
          system "opam", "exec", "--", "make"
          system "opam", "exec", "--", "make", "install"
        end
        system "opam", "install", "-y", "."
      end

      # Install semgrep-core
      cd "semgrep-core" do
        system "opam", "install", "--deps-only", "-y", "."
        system "opam", "exec", "--", "make", "all"
        system "opam", "exec", "--", "make", "install"
        bin.install "_build/default/cli/Main.exe" => "semgrep-core"
      end
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    python_path = "semgrep"
    cd python_path do
      venv = virtualenv_create(libexec, Formula["python@3.9"].bin/"python3.9")
      venv.pip_install resources
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
  end
end
