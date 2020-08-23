class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.17.1.14.tar.gz"
  sha256 "8fdd20e5e9c55ea4e24677e602a06a94a93f1155f9970c55b25dede5e037b974"
  license "GPL-2.0"
  revision 3
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "abef6ba69850e6dfa74ed7ed5d5a21b9c93aa45822fa7561b298e70889a6ca7f" => :catalina
    sha256 "3e1575beadbf5223f948d050b792671755874ad645c852c3ce2f5c3495a5cd21" => :mojave
    sha256 "14a43467042890dd35c6ae2f832a5a91c5d8b4d7fa0b731c7f9eeb9dee2d8a15" => :high_sierra
  end

  depends_on "python@3.8"

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
