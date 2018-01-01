class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.17.1.14.tar.gz"
  sha256 "8fdd20e5e9c55ea4e24677e602a06a94a93f1155f9970c55b25dede5e037b974"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cf098db9eb5888ad3e513cb222930975089034c9a3e8f2d6c1c53bb93b4ea1c" => :high_sierra
    sha256 "6c2e56df6aeed7ed8bcbdea702b9d66058ea17be38bc39a26feba5928dbe053a" => :sierra
    sha256 "92c6ab8dc868bad029103c897ccdc5a04e6e0f6809dfd2759c58aa390a7d5e8f" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  conflicts_with "trash", :because => "both install a `trash` binary"

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
