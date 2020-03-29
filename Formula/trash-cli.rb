class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.17.1.14.tar.gz"
  sha256 "8fdd20e5e9c55ea4e24677e602a06a94a93f1155f9970c55b25dede5e037b974"
  revision 3
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11d325db1d011fbc8e148e21418fc7b28acc5ed709f1650326691fd276342494" => :catalina
    sha256 "da23c8fae828c479cf01dffeb4c9838d734b9da6022991a1561572a82e913ef2" => :mojave
    sha256 "2bdc29f08a37d62fabc5ff53535209320f009b6f8c5a94a091d3acb3c3e16118" => :high_sierra
  end

  depends_on "python@3.8"

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
