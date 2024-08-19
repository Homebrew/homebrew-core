class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/b4/61/0228586a10b76064431e1d0c965f030b4c7dfbea6d1cfcb4d3f0cb0e6726/snakefmt-0.10.2.tar.gz"
  sha256 "4286a5903b66da7e52763c5e8184da4edc95113b758f4448528804fb54f9b75a"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8fd280ae822515f5b14f7effad93e2f0df080d991903db385e1ea655e1b6f53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1828c0bb7690ba94ccf9eacc96668a16310aca77cbb6fdfb290f1d8ceef2162f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3f32132484530b6322291005c4a3847d719e6d7cec79993da139b8f463432ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "16d9aa32e9501e241a408a31a5a3ee69372d0a60e44d68217e702966d5dcb61e"
    sha256 cellar: :any_skip_relocation, ventura:        "e446de4b895a0b7215a441501ee9dc7deffc0a3f68fa9d78bc643155209d60fd"
    sha256 cellar: :any_skip_relocation, monterey:       "b2bb2882075c72ddc84d5c5b8b76c9b0c2a876ac25cad77f557268d705cf0d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e31caf6a3286d9d105fc81902efa3fce86c9bc41b002b8e08f162c333aa763"
  end

  depends_on "python@3.12"

  resource "black" do
    url "https://files.pythonhosted.org/packages/a2/47/c9997eb470a7f48f7aaddd3d9a828244a2e4199569e38128715c48059ac1/black-24.4.2.tar.gz"
    sha256 "c872b53057f000085da66a19c55d68f6f8ddcac2642392ad3a355878406fbd4d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b2/e4/2856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937/platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end
