class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/1f/ce/d2dee5da2cf76cdec5a5fb9dc7b99849b08ea28a5dc17830afc2baadaffc/snakefmt-0.10.0.tar.gz"
  sha256 "53eae69fc81425e2192684eba76171bd648b05dcba93c9d5f45746d3fadb8617"
  license "MIT"
  revision 1
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8b8c38f1348c34df1e4a0b6a948100c7191dda228b5171d9c7477292938db5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5528b6471981aa8f8947df016af868efb9033a489fb5e8032a1a484e61a95c0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97b294b95734549eee3ed91cf3869b1d3942d12cf8826f1b95166d2fe9b15370"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9a137260a61930b35150010f5a6c3f0a94b12477edf6fc70328cab07599c624"
    sha256 cellar: :any_skip_relocation, ventura:        "a94cdc1757e49180eff82067b11f88149129d18bbd748bd7b666765482c8f785"
    sha256 cellar: :any_skip_relocation, monterey:       "39aedd0dcd06a9c8c23cfa72f0c024834186c7d35dfae8a40d95220e5fe4a79b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3b65601552d9c6b102ce447ce8ea4a775b3575ddeca93d33d2e2e37fc9b867"
  end

  depends_on "python@3.12"

  resource "black" do
    url "https://files.pythonhosted.org/packages/8f/5f/bac24a952668c7482cfdb4ebf91ba57a796c9da8829363a772040c1a3312/black-24.3.0.tar.gz"
    sha256 "a0c9c4a0771afc6919578cec71ce82a3e31e054904e7197deacbc9382671c41f"
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
