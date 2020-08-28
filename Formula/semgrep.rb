class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  url "https://github.com/returntocorp/semgrep.git",
    tag:      "v0.21.0",
    revision: "116f73ca6126f5839dde26c45b9c6676bedaace1"
  license "LGPL-2.1-only"
  head "https://github.com/returntocorp/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "a990e86e4d499c8f114ff644c29e6ee85d93c58cd52c277d67300188f49bf6a3" => :catalina
    sha256 "49e5ea1e112f4388c486a9887089485b412b6898d3437f131d9186f9c811b55f" => :mojave
    sha256 "f81daac5cbc83fb38992fa4efe8bdd1071c00eb2a17db53a59c09a0c6a6f89dd" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "coreutils"=> :build
  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/e2/ae/0b037584024c1557e537d25482c306cf6327b5a09b6c4b893579292c1c38/importlib_metadata-1.7.0.tar.gz"
    sha256 "90bb658cdbbf6d1735b6341ce708fc7024a3e14e99ffdc5783edea9f9b077f83"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/8c/c278395367a46c00d28036143fdc6583db8f98622b83875403f16473509b/more-itertools-8.1.0.tar.gz"
    sha256 "c468adec578380b6281a114cb8a5db34eb1116277da92d7c46f904f0b52d3288"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/8c/46/4e93ab8a379d7efe93f20a0fb8a27bdfe88942cc954ab0210c3164e783e0/pyrsistent-0.14.11.tar.gz"
    sha256 "3ca82748918eb65e2d89f222b702277099aca77e34843c5eb9d52451173970e2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/16/8b/54a26c1031595e5edd0e616028b922d78d8ffba8bc775f0a4faeada846cc/ruamel.yaml-0.16.10.tar.gz"
    sha256 "099c644a778bf72ffa00524f78dd0b6476bca94a1da344130f4bf3381ce5b954"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/92/28/612085de3fae9f82d62d80255d9f4cf05b1b341db1e180adcf28c1bf748d/ruamel.yaml.clib-0.2.0.tar.gz"
    sha256 "b66832ea8077d9b3f6e311c4a53d06273db5dc2db6e8a908550f3c14d67e718c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/71/6c/6530032ec26dddd47bb9e052781bcbbcaa560f05d10cdaf365ecb990d220/tqdm-4.48.0.tar.gz"
    sha256 "6baa75a88582b1db6d34ce4690da5501d2a1cb65c34664840a456b2c9f794d29"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d4/cd/ef86396dce8910413b6ca1ef31ec09367c47e15fc1a12def2cc8ae134dea/zipp-1.0.0.tar.gz"
    sha256 "d38fbe01bbf7a3593a32bc35a9c4453c32bc42b98c377f9bff7e9f8da157786c"
  end

  def install
    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"

      # Used by semgrep-core for clang to find libtree-sitter.a
      ENV["LIBRARY_PATH"] = lib

      # Used by ocaml-tree-sitter to find tree-sitter/*.h headers
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      ENV["C_INCLUDE_PATH"] = include

      # Used by tree-sitter to place libtree-sitter.a, and header files
      ENV["PREFIX"] = prefix

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.4.10.0" }

      system "opam", "exec", "--", "make", "setup"
      system "opam", "install", "./pfff"

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
        bin.install "_build/default/bin/Main.exe" => "semgrep-core"
      end
    end

    python_path = "semgrep"
    cd python_path do
      venv = virtualenv_create(libexec, Formula["python@3.8"].bin/"python3.8")
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
