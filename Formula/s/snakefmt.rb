class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/67/b8/d44a8f77f181fb679451493701db94293e6810db31e9b320aa0a5c2c69db/snakefmt-0.10.1.tar.gz"
  sha256 "b04a34fc5481b15667c8bc7f23b5722b98ef827b27c6fd6dfbab8b34b245e32b"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ccc5d172b3343a184755285dcd238919eb1e7680ee2e05c7188fb8b0b382c6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ccc5d172b3343a184755285dcd238919eb1e7680ee2e05c7188fb8b0b382c6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ccc5d172b3343a184755285dcd238919eb1e7680ee2e05c7188fb8b0b382c6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fab253ee39c7625ba52196d890dd6f5b150e5ebf5ed9ecfcfda196b3650abe5"
    sha256 cellar: :any_skip_relocation, ventura:        "9fab253ee39c7625ba52196d890dd6f5b150e5ebf5ed9ecfcfda196b3650abe5"
    sha256 cellar: :any_skip_relocation, monterey:       "9fab253ee39c7625ba52196d890dd6f5b150e5ebf5ed9ecfcfda196b3650abe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10adfd773285dfeac790af6e08bb188abb33229024cbf584f76b6ab93bf60c8"
  end

  depends_on "python@3.12"

  resource "black" do
    url "https://files.pythonhosted.org/packages/e7/29/58e93d7775544b6058f1df71dce4a8f5b039c2f8e381d3c695444c3d3d5f/black-24.4.0.tar.gz"
    sha256 "f07b69fda20578367eaebbd670ff8fc653ab181e1ff95d84497f9fa20e7d0641"
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
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
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
