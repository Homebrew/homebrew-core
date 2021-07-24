class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/5c/a6/3a419ec60a4c95b658e81f9efa42d2b072014ae559156f04e9637f54462d/trash-cli-0.21.7.23.tar.gz"
  sha256 "db1d13dde021e7c2dee1c1e30afdb6f813323a134eaffea802128db204c15ac6"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f67830940753ba946de47afcff2dd0a2a6bd5b4c665cbbf4fe25264b89022efb"
    sha256 cellar: :any_skip_relocation, big_sur:       "16ffdf6c7f458ea55eb8139dc67c5f65116bb4d76b4f40f68705525d6e8c0ded"
    sha256 cellar: :any_skip_relocation, catalina:      "c6d062d4f298bab84722d8365eb428d4bd4f0fe6c317a9e6c13a7fcbf0ae08bc"
    sha256 cellar: :any_skip_relocation, mojave:        "c6767dea374173883c805b91c53c103b694bacca19b7b5452a95d851ed1b87c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e631a6f59594c8d8718d39c34f85ee95bc6a0de702136c07ec26306c53731f79"
  end

  depends_on "python@3.9"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
