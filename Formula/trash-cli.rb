class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.17.1.14.tar.gz"
  sha256 "8fdd20e5e9c55ea4e24677e602a06a94a93f1155f9970c55b25dede5e037b974"
  head "https://github.com/andreafrancia/trash-cli.git"

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with "osxutils", :because => "both install a `trash` binary"
  conflicts_with "trash", :because => "both install a `trash` binary"

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert File.exist?("testfile")
    system bin/"trash-put", "testfile"
    assert !File.exist?("testfile")
  end
end
