class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.17.1.14.tar.gz"
  sha256 "8fdd20e5e9c55ea4e24677e602a06a94a93f1155f9970c55b25dede5e037b974"
  license "GPL-2.0"
  revision 4
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc13679d7b02e8ff8deb976e1866fa715cdd71a11afb4c749ed7f72ca9dd4121" => :catalina
    sha256 "7c50f6d779aef1d69d7620433ec0bb90a5031960c0e701ff11bcb8a9737af72c" => :mojave
    sha256 "4731567ca54e4fb86125dd7d37bce5d079fdcbd0830151c68f2c01854eff1512" => :high_sierra
  end

  depends_on "python@3.9"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

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
