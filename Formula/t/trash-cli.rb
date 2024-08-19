class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/f7/6c/d51b36377c35e4f9e69af4d8b61a920f26251483cdc0165f5513da7aefeb/trash_cli-0.24.5.26.tar.gz"
  sha256 "c721628e82c4be110b710d72b9d85c9595d8b524f4da241ad851a7479d0bdceb"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52494b0f151cb64bcbaf135234a3dba653c62ba58acab0738238ef76a0e7e5d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "840acb0031d2dff6846a108168e587565c668408ff198114705956afef881a4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2260988e4f3d877e696902b51ea38df68e2b54d48abfcabe897efbe88b683883"
    sha256 cellar: :any_skip_relocation, sonoma:         "c71b355edab688f219463348e5212574f1647c994e7e807f886fc526cae95976"
    sha256 cellar: :any_skip_relocation, ventura:        "38638689e159a256579221c3e05c81c746de0e76e8cdc890bcac13e67a557743"
    sha256 cellar: :any_skip_relocation, monterey:       "effc0045b6313f3c46375dfe54ab9d69410e478f7bbdae82aad27c422e6049b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079ba93c9e3201cb09eeeea1d838e6221c9eaf06ecaab8519a58c6b49859fd2f"
  end

  depends_on "python@3.12"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
