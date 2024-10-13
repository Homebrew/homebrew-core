class Tartufo < Formula
  include Language::Python::Virtualenv

  desc "Searches through git repositories for high entropy strings and secrets"
  homepage "https://tartufo.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/f3/be/a004a02e3b2be08c998f66f391df238de701320af3f0a0438e724db943e2/tartufo-5.0.1.tar.gz"
  sha256 "5eda46cd6a68dfe35b61b0f18a63bc0a7fc9bb6c096e4a26c8e1aaec8dea9324"
  license "GPL-2.0-only"
  head "https://github.com/godaddy/tartufo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a2d3ce41516c254e47ee05124c57fc3cd0180da845f23dc1a0b6296f27db981e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6780d70ce53b81d93686023e0eb59ab1d8573b58ac59c9446d2f49d719388a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6780d70ce53b81d93686023e0eb59ab1d8573b58ac59c9446d2f49d719388a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6780d70ce53b81d93686023e0eb59ab1d8573b58ac59c9446d2f49d719388a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2cbdf5faa974325f07a9c7872c810c1720873f2b74ee45477933d26dc60421c"
    sha256 cellar: :any_skip_relocation, ventura:        "f2cbdf5faa974325f07a9c7872c810c1720873f2b74ee45477933d26dc60421c"
    sha256 cellar: :any_skip_relocation, monterey:       "f2cbdf5faa974325f07a9c7872c810c1720873f2b74ee45477933d26dc60421c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3703dd93bb1d935240217e728662a06c0a87f150a625309fa58377a50db5cec"
  end

  depends_on "pygit2"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4b/34/f5f4fbc6b329c948a90468dd423aaa3c3bfc1e07d5a76deec269110f2f6e/tomlkit-0.13.0.tar.gz"
    sha256 "08ad192699734149f5b97b45f1f18dad7eb1b6d16bc72ad0c2335772650d7b72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tartufo --version")

    output = shell_output("#{bin}/tartufo scan-remote-repo https://github.com/godaddy/tartufo.git")
    assert_match "All clear. No secrets detected.", output
  end
end
